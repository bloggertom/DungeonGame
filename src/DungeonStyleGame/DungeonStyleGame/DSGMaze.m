//
//  DSGMaze.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGMaze.h"
#import "DSGTile.h"

@interface DSGMaze ()

@end

@implementation DSGMaze

-(id)initWithSize:(CGSize)size{
	self = [super init];
	if(self){
		_size = size;
		_mazeTiles = [[NSMutableArray alloc]initWithCapacity:size.width*size.height];
		[self createMazeTiles];
	}
	return self;
}

-(void)createMazeTiles{
	DSGTile *neighbor;
	for (int y=0; y<_size.height; y++) {
		for (int x=0; x<_size.width; x++) {
			DSGTile *current = [[DSGTile alloc]initWithPosition:CGPointMake(x, y)];
			if (y != 0) {
				neighbor = [_mazeTiles objectAtIndex:x*(y-1)];
				[current.walls replaceObjectAtIndex:DSGMazeDirectionDown withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionUp withObject:current];
				
			}
			if (x != 0){
				neighbor = [_mazeTiles objectAtIndex:(x-1)*y];
				[current.walls replaceObjectAtIndex:DSGMazeDirectionLeft withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionRight withObject:current];
			}
			[_mazeTiles addObject:current];
		}
	}
	
}

@end
