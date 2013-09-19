//
//  DSGWizard.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGWizard.h"

#define kNIdelFrames 4
#define kNWalkingRightFrames 8
#define kNwalkingLeftFrames 8
#define kNFiringRightFrames 8
@implementation DSGWizard

-(id)initatPosition:(CGPoint)position{
	SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Wizard_Idle"];
	SKTexture *texture = [atlas textureNamed:@"Idle_right"];
	
	return [super initWithTexture:texture atPosition:position];
}

+(void)loadAssets{
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
			//NSLog(@"Boo");
			//idle frames
		sIdleFrames = [[NSMutableArray alloc]initWithCapacity:kNIdelFrames];
		SKTextureAtlas *idle = [SKTextureAtlas atlasNamed:@"Wizard_Idle"];
		SKTexture *idleRight = [idle textureNamed:@"Idle_right"];
		[sIdleFrames insertObject:idleRight atIndex:DSGCharacterFacingUp];
		[sIdleFrames insertObject:idleRight atIndex:DSGCharacterFacingRight];
		SKTexture *idleLeft = [idle textureNamed:@"Idle_left"];
		[sIdleFrames insertObject:idleLeft atIndex:DSGCharacterFacingDown];
		[sIdleFrames insertObject:idleLeft atIndex:DSGCharacterFacingLeft];
		
			//walking right frames
		sWalkingRightFrames = [[NSMutableArray alloc]initWithCapacity:kNWalkingRightFrames];
		SKTextureAtlas *wRight = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Right"];
		for (int i=1; i<kNWalkingRightFrames; i++) {
			SKTexture *frame = [wRight textureNamed:[NSString stringWithFormat:@"Walking_right_%d",i]];
			[sWalkingRightFrames addObject:frame];
		}
		
			//walking left frames
		sWalkingLeftFrames = [[NSMutableArray alloc]initWithCapacity:kNwalkingLeftFrames];
		SKTextureAtlas *wLeft = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Left"];
		for (int i=1; i<kNwalkingLeftFrames; i++) {
			SKTexture *frame = [wLeft textureNamed:[NSString stringWithFormat:@"Walking_left_%d",i]];
			[sWalkingLeftFrames addObject:frame];
		}
		
			//firing right frames
			//NSLog(@"Boo");
		sFiringRightFrames = [[NSMutableArray alloc]initWithCapacity:kNFiringRightFrames];
		SKTextureAtlas *fRight = [SKTextureAtlas atlasNamed:@"Wizard_Firing_Right"];
		for (int i = 1; i<kNFiringRightFrames; i++) {
			SKTexture *frame = [fRight textureNamed:[NSString stringWithFormat:@"Firing_right_%d",i]];
			[sFiringRightFrames addObject:frame];
		}
	});
	
}

static NSMutableArray *sIdleFrames;
-(NSArray *)idleFrames{
	return sIdleFrames;
}
static NSMutableArray *sWalkingRightFrames;
-(NSArray *)walkingRightFrames{
	return sWalkingRightFrames;
}
static NSMutableArray *sWalkingLeftFrames;
-(NSArray *)walkingLeftFrames{
	return sWalkingLeftFrames;
}
static NSMutableArray *sWalkingUpFrames;
-(NSArray *)walkingUpFrames{
	return sWalkingUpFrames;
}
static NSMutableArray *sWalkingDownFrames;
-(NSArray *)walkingDownFrames{
	return sWalkingDownFrames;
}

static NSMutableArray *sFiringRightFrames;
static NSMutableArray *sFiringLeftFrames;
static NSMutableArray *sFiringUpFrames;
static NSMutableArray *sFiringDownFrames;
@end
