//
//  DSGViewController.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGViewController.h"
#import "DSGTestLevel.h"

@implementation DSGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
	skView.ignoresSiblingOrder = YES;
	_attackButton.alpha = 0.0;
	
	NSLog(@"Height: %f, Width %f", self.view.frame.size.height, self.view.frame.size.width);
	
		//ask level to load assets and implament completion handler.
	[DSGTestLevel loadAssetsWithHandler:^{
			// Create and configure the scene.
		CGSize size = skView.bounds.size;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			size.height *= 0.75;
			size.width *=0.75;
		}
		SKScene * scene = [DSGTestLevel sceneWithSize:size];
		scene.scaleMode = SKSceneScaleModeAspectFill;
		[skView presentScene:scene];
	}];
	
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
	return UIInterfaceOrientationMaskLandscape;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)start:(id)sender{
		//start button pushed
	
		//get view
	SKView *skView = (SKView*)self.view;
	DSGTestLevel *scene = (DSGTestLevel *)skView.scene;
		//animate away start button, and in attack button
	[UIView animateWithDuration:1 animations:^{
		self.startButton.alpha = 0;
		self.attackButton.alpha = 1;
	} completion:^(BOOL finished) {
			//begin the game.
		[scene startLevel];
	}];
	
	
}

-(IBAction)attack:(id)sender{
		//ATTACK!
	
	SKView *view = (SKView*)self.view;
	DSGTestLevel *scene = (DSGTestLevel *)view.scene;
	[scene requestAttack];
	
	
}
@end
