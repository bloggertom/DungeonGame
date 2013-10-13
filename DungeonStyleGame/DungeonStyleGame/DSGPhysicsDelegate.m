//
//  DSGPhysicsDelegate.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGPhysicsDelegate.h"
#import "DSGCharacter.h"

@implementation DSGPhysicsDelegate 

-(id)init{
	self=[super init];
	if (self) {
		NSLog(@"physics inited");
	}
	return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
	if (contact.bodyA.categoryBitMask & DSGCollitionCategoryProjectile || contact.bodyB.categoryBitMask & DSGCollitionCategoryProjectile) {
		SKNode *projectile = (contact.bodyA.categoryBitMask & DSGCollitionCategoryProjectile) ? contact.bodyA.node: contact.bodyB.node;
		[projectile removeFromParent];
		
		if (contact.bodyA.categoryBitMask & DSGCollitionCategoryEnemy || contact.bodyB.categoryBitMask & DSGCollitionCategoryEnemy) {
			SKNode *enemy = (contact.bodyA.categoryBitMask & DSGCollitionCategoryEnemy) ? contact.bodyA.node : contact.bodyB.node;
			[enemy removeFromParent];
		}
	}
}

-(void)didEndContact:(SKPhysicsContact *)contact{
	NSLog(@"contact Ended");
}

@end
