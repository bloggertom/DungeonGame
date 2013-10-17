//
//  DSGMapBuilder.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface DSGMapBuilder : NSObject


@property (nonatomic)SKNode *start;//start of map
@property (nonatomic)SKNode *finish;//end of map
@property (nonatomic, strong)NSArray *floorTextures; //textures for the floor
@property (nonatomic, strong)NSArray *wallTexture; //textures for the wall (not made yet)

-(id)initWithFloorTexture:(SKTexture *)floorTexture andWallTexture:(SKTexture *)wallTexture;
-(id)initWithFloorTextures:(NSArray*)floorTextures andWallTextures:(NSArray*)wallTextures;

-(NSMutableArray*)buildMapOfSize:(CGSize)size forTilesOfSize:(CGSize)tileSize;

@end
