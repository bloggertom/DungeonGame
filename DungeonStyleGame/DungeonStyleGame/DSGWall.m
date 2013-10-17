//
//  DSGWall.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 13/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGWall.h"

@implementation DSGWall

-(void)configurePhysics{
	
		//configure physics
	self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	self.physicsBody.categoryBitMask = DSGCollitionCategoryWall;
	self.physicsBody.collisionBitMask = 0;
	self.physicsBody.contactTestBitMask = DSGCollitionCategoryEnemy | DSGCollitionCategoryHero | DSGCollitionCategoryProjectile;
	
}

@end
