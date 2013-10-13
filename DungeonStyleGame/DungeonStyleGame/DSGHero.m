//
//  DSGHero.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGHero.h"

@interface DSGHero()


@end

@implementation DSGHero


-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position{
	self = [super initWithTexture:texture atPosition:position];
	if(self){
		
		
	}
	return self;
}



-(void)updateForTimeIntervale:(NSTimeInterval)time{
	[super updateForTimeIntervale:time];
	
}



+(void)loadAssets{
		//overridden
	
}
@end
