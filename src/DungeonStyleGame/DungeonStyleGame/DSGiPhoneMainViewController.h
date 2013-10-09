//
//  DSGiPhoneMainViewController.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@class DSGGamePadViewController;
@class DSGiPhoneExternalViewController;

@interface DSGiPhoneMainViewController : UIViewController

@property(nonatomic, strong)DSGiPhoneExternalViewController *gameViewController;
@property(nonatomic, strong)DSGGamePadViewController *gamePadController;
@property(nonatomic)IBOutlet UIView *startingView;
@property(nonatomic)IBOutlet UIButton *startButton;
@property(nonatomic)IBOutlet UIView *coverView;
@property(nonatomic)IBOutlet UILabel *message;
@property(nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)startButtonPushed:(id)sender;


-(void)externalControllerDidFinishLoadingAssets;
-(void)externalControllerDidPresentScene:(SKScene *)scene;
@end
