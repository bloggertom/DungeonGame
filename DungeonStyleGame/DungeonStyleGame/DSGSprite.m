//
//  DSGSprite.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 13/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGSprite.h"

@implementation DSGSprite

-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position{
	self = [super initWithTexture:texture];
	if (self) {
		self.position = position;
		
			//ask everyone to configure their own damn physics.
		[self configurePhysics];
			//ain't nobody got time for that.
	}
	return self;
}

-(void)configurePhysics{
		//overridden
	
}

@end
