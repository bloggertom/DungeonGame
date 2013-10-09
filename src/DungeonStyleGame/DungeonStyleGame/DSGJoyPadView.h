//
//  DSGJoyPadView.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGJoyPadDelegate.h"
#define THUMB_STICK_RADIUS 30
@class DSGGamePadViewController;

@interface DSGJoyPadView : UIView

@property(nonatomic, weak)IBOutlet id <DSGJoyPadDelegate> delegate;
@property(nonatomic, strong)UIView *stickView;
@property(nonatomic)UIButton *actionButton;

@end
