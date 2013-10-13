//
//  DSGSprite.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 13/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint32_t {
	DSGCollitionCategoryProjectile = 0x1 << 0,
	DSGCollitionCategoryEnemy = 0x1 << 1,
	DSGCollitionCategoryHero = 0x1 << 2,
	DSGCollitionCategoryWall = 0x1 << 3
}DSGCollitionCategory;

@interface DSGSprite : SKSpriteNode

-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

-(void)configurePhysics;

@end
