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
	
	NSLog(@"Height: %f, Width %f", self.view.frame.size.height, self.view.frame.size.width);
	
	[DSGTestLevel loadAssetsWithHandler:^{
			// Create and configure the scene.
		CGSize size = skView.bounds.size;
		size.height *= 0.75;
		size.width *=0.75;
		SKScene * scene = [DSGTestLevel sceneWithSize:size];
		scene.scaleMode = SKSceneScaleModeAspectFill;
		[skView presentScene:scene];
	}];
	
    
    
    // Present the scene.
    
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
	SKView *skView = (SKView*)self.view;
	DSGTestLevel *scene = (DSGTestLevel *)skView.scene;
	[UIView animateWithDuration:2 animations:^{
		self.startButton.alpha = 0;
	} completion:^(BOOL finished) {
		[scene startLevel];
	}];
	
	
}
@end
