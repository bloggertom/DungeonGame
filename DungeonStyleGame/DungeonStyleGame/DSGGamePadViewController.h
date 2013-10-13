//
//  DSGGamePadViewController.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DSGControllable.h"
#import "DSGJoyPadDelegate.h"

@class DSGJoyPadView;
@class  DSGiPhoneExternalViewController;
@class DSGLevel;

@interface DSGGamePadViewController : UIViewController <DSGJoyPadDelegate>

	//@property (nonatomic, weak)id<DSGControllable> controllable;
@property (nonatomic, weak)DSGLevel *scene;

@property (nonatomic)IBOutlet DSGJoyPadView *joypad;

-(void)actionButtonPushed:(id)sender;
-(void)didConnectionExternalScreen:(UIScreen *)screen;
-(void)didDisconnectionExternalScreen;
@end
