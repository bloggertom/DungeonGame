//
//  DSGMyScene.h
//  DungeonStyleGame
//

//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kSpriteSize 32
typedef void (^DSGLoadAssesCompleteHandler)(void);

typedef enum : uint8_t {
	DSGWorldLayerGround = 0,
	DSGCharacterLayer,
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

+(void)loadAssetsWithHandler:(DSGLoadAssesCompleteHandler)callback;

+(void)loadAssets;

@end
