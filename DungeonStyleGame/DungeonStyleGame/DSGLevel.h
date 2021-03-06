//
//  DSGMyScene.h
//  DungeonStyleGame
//

//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kSpriteSize 32
#define DEBUG_COLLISIONS 0
#define kWorldSize 2100.0

#define kWorldCenter 1000
#define kNumTilesTextures 4
#define kGroundTileSize 300.0
#define kMazeSize kWorldSize-(2*kGroundTileSize)
typedef void (^DSGLoadAssesCompleteHandler)(void);

typedef enum : uint8_t {
	DSGWorldLayerGround = 0,
	DSGCharacterLayer,
	DSGDebugLayer,
	kWorldLayerCount
} DSGWorldLayer;

@class DSGHero;

@interface DSGLevel : SKScene

	//@property (nonatomic) NSMutableArray *heros;
@property (nonatomic) NSMutableArray *mapSprites;
@property (nonatomic) NSMutableArray *monsters;
@property (nonatomic, readonly) SKNode *world;
@property (nonatomic)DSGHero *hero;


-(void)addChildNode:(SKNode*)node atWorldLayer:(DSGWorldLayer)layer;
-(void)requestAttack;

+(void)loadAssetsWithHandler:(DSGLoadAssesCompleteHandler)callback;

+(void)loadAssets;

@end
