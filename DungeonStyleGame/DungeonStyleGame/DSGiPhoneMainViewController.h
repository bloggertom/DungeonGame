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

@property(nonatomic, strong)DSGiPhoneExternalViewController *gameViewController; //where the games is played
@property(nonatomic, strong)DSGGamePadViewController *gamePadController; //where the controller is made
@property(nonatomic)IBOutlet UIView *startingView; //to show the start button
@property(nonatomic)IBOutlet UIButton *startButton; //the said start button
@property(nonatomic)IBOutlet UIView *coverView;//view of covering
@property(nonatomic)IBOutlet UILabel *message;//message which be contain there within the covering view
@property(nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)startButtonPushed:(id)sender;


-(void)externalControllerDidFinishLoadingAssets;
-(void)externalControllerDidPresentScene:(SKScene *)scene;
@end
