//
//  DSGiPhoneExternalViewController.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGiPhoneExternalViewController.h"
#import "DSGTestLevel.h"
#import "DSGiPhoneMainViewController.h"
@interface DSGiPhoneExternalViewController ()

@end

@implementation DSGiPhoneExternalViewController

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
	
	[super viewDidLoad];
	
		// Configure the view.
	SKView *skView = [[SKView alloc]initWithFrame:_screen.bounds];
    self.view = skView;
	skView.showsFPS = YES;
	skView.showsNodeCount = YES;
	
		//NSLog(@"Height: %f, Width %f", self.view.frame.size.height, self.view.frame.size.width);
	
	[DSGTestLevel loadAssetsWithHandler:^{
			// Create and configure the scene.
		[_callback externalControllerDidFinishLoadingAssets];
		CGSize size = skView.bounds.size;
		size.height *= 0.8;
		size.width *=0.8;
		SKScene * scene = [DSGTestLevel sceneWithSize:size];
		scene.scaleMode = SKSceneScaleModeFill;//best so far
		[skView presentScene:scene];
		[_callback externalControllerDidPresentScene:scene];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startGame{
	SKView *skView = (SKView *)self.view;
	DSGTestLevel *level = (DSGTestLevel *)skView.scene;
	[level startLevel];
}


@end
