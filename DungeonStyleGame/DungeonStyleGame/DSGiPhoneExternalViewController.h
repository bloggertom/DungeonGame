//
//  DSGiPhoneExternalViewController.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class DSGiPhoneMainViewController;

@interface DSGiPhoneExternalViewController : UIViewController 

@property(nonatomic)UIScreen *screen;
@property(nonatomic, weak)DSGiPhoneMainViewController *callback;

-(void)startGame;
@end
