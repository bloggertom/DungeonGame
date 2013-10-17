//
//  DSGGamePadViewController.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGGamePadViewController.h"
#import "DSGJoyPadView.h"
#import "DSGLevel.h"
#import "DSGHero.h"
@interface DSGGamePadViewController ()

@end

@implementation DSGGamePadViewController

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
	
		//set up view bound stretching
	self.view.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Joy Pad methods
-(void)actionButtonPushed:(id)sender{
	NSLog(@"action button Pushed");
	[_scene requestAttack];
}
-(void)joypadMovedInDirection:(CGPoint)direction{
	NSLog(@"Joy Pad Moved");
		//tell the hero to move
	_scene.hero.targetDirection = direction;
	_scene.hero.movementRequested = YES;
	
}

#pragma mark - child view delegate methods
-(BOOL)prefersStatusBarHidden{
	return YES;
}
-(BOOL)shouldAutorotate{
	return YES;
}
#pragma mark - External Screen handlers
-(void)didConnectionExternalScreen:(UIScreen *)screen{
		//hi
	[self setNeedsStatusBarAppearanceUpdate];//still not working
	
}
-(void)didDisconnectionExternalScreen{
		//do stuff if needed
}


@end
