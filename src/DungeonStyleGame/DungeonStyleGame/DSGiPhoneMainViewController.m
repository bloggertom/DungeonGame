//
//  DSGiPhoneMainViewController.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGiPhoneMainViewController.h"
#import "DSGGamePadViewController.h"
#import "DSGiPhoneExternalViewController.h"
#import "DSGCharacter.h"
#import "DSGLevel.h"
@interface DSGiPhoneMainViewController ()
@property (nonatomic)UIScreen *externalScreen;
@property (nonatomic)UIWindow *externalWindow;


@end

@implementation DSGiPhoneMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_gamePadController = [[UIStoryboard storyboardWithName:@"iPhone" bundle:Nil]instantiateViewControllerWithIdentifier:@"JoyPad"];
	
	[self addChildViewController:_gamePadController];
	[self.view insertSubview:_gamePadController.view belowSubview:_startingView];
	[_gamePadController didMoveToParentViewController:self];
	
	_message.text = @"Please Connect External Screen.\nOr connect to AirPlay with mirroring.";
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(screenNumberDidChange:) name:UIScreenDidConnectNotification object:nil];
	[center addObserver:self selector:@selector(screenNumberDidChange:) name:UIScreenDidDisconnectNotification object:nil];
	
	[self screenNumberDidChange:nil];
	
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIViewController*)childViewControllerForStatusBarHidden{
	return _gamePadController;
}
#pragma mark - Screen Handlers
-(void)screenNumberDidChange:(NSNotification *)notification{
	NSLog(@"Screen connection");
	NSArray *screens = [UIScreen screens];
	if([screens count] > 1){
			//remove messages

		_externalScreen = [screens objectAtIndex:1];
		if (!_externalWindow) {
			_externalWindow = [[UIWindow alloc]initWithFrame:_externalScreen.bounds];
		}
		_externalWindow.screen = _externalScreen;
		
		if(!_gameViewController){
			_gameViewController = [[DSGiPhoneExternalViewController alloc]init];
			_gameViewController.callback = self;
		}
		
			//_externalScreen.overscanCompensation = UIScreenOverscanCompensationInsetApplicationFrame;
		
		_externalWindow.rootViewController = _gameViewController;
		[_externalWindow makeKeyAndVisible];
		[self didConnectionExternalScreen:_externalScreen];
		
	}else{

		_externalScreen = nil;
		_externalWindow = nil;
		[self didDisconnectionExternalScreen];		
			//show messages
	}
}
-(void)didConnectionExternalScreen:(UIScreen *)screen{
	[_gamePadController didConnectionExternalScreen:screen];
	[UIView animateWithDuration:2 animations:^{
		_coverView.alpha = 0;
		_message = 0;
	}];
	if(!_gameViewController){
		[_activityIndicator setHidden:NO];
		[_activityIndicator startAnimating];
	}
	
}
-(void)didDisconnectionExternalScreen{
	[_activityIndicator stopAnimating];
	[UIView animateWithDuration:2 animations:^{
		_coverView.alpha = 1;
		_message.alpha = 1;
	}completion:^(BOOL finished) {
		[_activityIndicator setHidden:YES];
	}];
	[_gamePadController didDisconnectionExternalScreen];
	
}
#pragma mark - GL HF
-(IBAction)startButtonPushed:(id)sender{
	[UIView animateWithDuration:2 animations:^{
		_startingView.alpha = 0;
		_startButton.alpha = 0;
		
	} completion:^(BOOL finished) {
		_startButton.userInteractionEnabled = NO;
		[_gameViewController startGame];
	}];
}

-(void)externalControllerDidFinishLoadingAssets{
	[_activityIndicator stopAnimating];
		//start animation
	[UIView animateWithDuration:1.5 animations:^{
		_activityIndicator.alpha = 0;;
	}completion:^(BOOL finished) {
			
		[UIView animateWithDuration:1.5 animations:^{//second animation for start button
			_startButton.alpha = 1;
		}];//end of second animation
			
	}];//end first animation;
}
-(void)externalControllerDidPresentScene:(SKScene *)scene{
	_gamePadController.scene = (DSGLevel *)scene;
}
@end
