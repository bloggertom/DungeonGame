//
//  DSGTestLevel.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGLevel.h"

#define kWorldSize 2000
#define kWorldCenter 1000
#define kNumTilesTextures 4
#define kGroundTileSize 32
#define kBackgroundTileDevisor (kWorldSize/kGroundTileSize)
@interface DSGTestLevel : DSGLevel <SKPhysicsContactDelegate>

-(void)startLevel;



@end
