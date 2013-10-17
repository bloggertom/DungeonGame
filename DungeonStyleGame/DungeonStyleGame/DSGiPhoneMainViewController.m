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
	//where the magic happens
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_gamePadController = [[UIStoryboard storyboardWithName:@"iPhone" bundle:Nil]instantiateViewControllerWithIdentifier:@"JoyPad"];
	
		//add game pad view controller as child view controller
	[self addChildViewController:_gamePadController];
	[self.view insertSubview:_gamePadController.view belowSubview:_startingView];
	[_gamePadController didMoveToParentViewController:self];
	
		//prepare message, just in case
	_message.text = @"Please Connect External Screen.\nOr connect to AirPlay with mirroring.";
	
		//set up notification for when display added or taken away.
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(screenNumberDidChange:) name:UIScreenDidConnectNotification object:nil];
	[center addObserver:self selector:@selector(screenNumberDidChange:) name:UIScreenDidDisconnectNotification object:nil];
	
		//set up screens
	[self screenNumberDidChange:nil];
	
		//this isn't working
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
		//how many screens are there?
	if([screens count] > 1){
		
			//get the external screen (self is always 0)
		_externalScreen = [screens objectAtIndex:1];
		if (!_externalWindow) {
				//make a window with it's bounds
			_externalWindow = [[UIWindow alloc]initWithFrame:_externalScreen.bounds];
		}
			//give the window a screen to display on
		_externalWindow.screen = _externalScreen;
		
			//init game view controller if we havn't already
		if(!_gameViewController){
			_gameViewController = [[DSGiPhoneExternalViewController alloc]init];
			_gameViewController.callback = self;
		}
			//set scan overcompensation
			//_externalScreen.overscanCompensation = UIScreenOverscanCompensationInsetApplicationFrame;
		
			//set the external windows root view controller
		_externalWindow.rootViewController = _gameViewController;
		
			//display it
		[_externalWindow makeKeyAndVisible];
			//notify outselfs of a job well done
		[self didConnectionExternalScreen:_externalScreen];
		
	}else{
			//ONE SCREENS NOT GOOD ENOUGH! TRY HARDER!
		_externalScreen = nil;
		_externalWindow = nil;
			//let everyone know
		[self didDisconnectionExternalScreen];		
			
	}
}
-(void)didConnectionExternalScreen:(UIScreen *)screen{
		//let controllers know that external display has been connected
	[_gamePadController didConnectionExternalScreen:screen];
		//animate away the conver view and message
	[UIView animateWithDuration:2 animations:^{
		_coverView.alpha = 0;
		_message = 0;
	}];
		//remove activity view if the gameViewController is ready.
	if(!_gameViewController){
		[_activityIndicator setHidden:NO];
		[_activityIndicator startAnimating];
	}
	
}
-(void)didDisconnectionExternalScreen{
		//stop animating activity indicator
	[_activityIndicator stopAnimating];
		//animate in message
	[UIView animateWithDuration:2 animations:^{
		_coverView.alpha = 1;
		_message.alpha = 1;
	}completion:^(BOOL finished) {
		[_activityIndicator setHidden:YES];
	}];
		//let people know.
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
		//scene loaded, give reference to controller.
	_gamePadController.scene = (DSGLevel *)scene;
}
@end
