//
//  DSGGrub.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGGrub.h"

@implementation DSGGrub

-(id)initAtPosition:(CGPoint)position{
	
	SKTextureAtlas *atlas= [SKTextureAtlas atlasNamed:@"Grub_Idle"];
	SKTexture *texture = [atlas textureNamed:@"Grub_idle_1"];
	self = [super initWithTexture:texture atPosition:position];
	
	return self;
}

-(void)configurePhysics{
		//needs to be overridden again due to grub not filling picture.
	
	SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	physicsBody.contactTestBitMask = DSGCollitionCategoryHero | DSGCollitionCategoryProjectile;
	physicsBody.categoryBitMask = DSGCollitionCategoryEnemy;
	physicsBody.collisionBitMask = 0;
	self.physicsBody = physicsBody;
}

+(void)loadAssets{
	[super loadAssets];
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
			//idle frames
		sIdleFrames = [[NSMutableArray alloc]init];
		SKTextureAtlas *idleAtlas = [SKTextureAtlas atlasNamed:@"Grub_Idle"];
		SKTexture *idle1 = [idleAtlas textureNamed:@"Grub_idle_1"];
		[sIdleFrames addObject:idle1];
	});
}
static NSMutableArray *sIdleFrames;
-(NSArray *)idleFrames{
	return sIdleFrames;
}
@end
