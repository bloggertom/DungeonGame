//
//  DSGTile.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGTile.h"

@interface DSGTile ()


@end


@implementation DSGTile

-(id)initWithPosition:(CGPoint)position{
	self = [super init];
	if(self){
		_position = position;
		_walls = [[NSMutableArray alloc]initWithCapacity:4];
		_paths = [[NSMutableArray alloc]initWithCapacity:4];
		for (int i = 0; i<2; i++) {
			[_paths addObject:0];
			for(int j=0; j<2; i++){
				[_walls addObject:0];
			}
		}
	}
	return self;
}


@end
