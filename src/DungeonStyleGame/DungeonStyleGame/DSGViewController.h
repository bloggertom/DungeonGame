//
//  DSGViewController.h
//  DungeonStyleGame
//

//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface DSGViewController : UIViewController

@property (nonatomic)IBOutlet UIButton *startButton;
@property (nonatomic)IBOutlet UIButton *attackButton;

-(IBAction)start:(id)sender;
-(IBAction)attack:(id)sender;



@end
