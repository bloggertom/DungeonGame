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
			//Are we sitting comfortably? good, then let us begin.
		_size = size;
		_mazeTiles = [[NSMutableArray alloc]initWithCapacity:size.width*size.height];
		_path = [[NSMutableArray alloc]initWithCapacity:size.width*size.height];
			//init maze tiles/graph
		[self createMazeTiles];
	}
	return self;
}

-(void)createMazeTiles{
		//love thy neighbor
	DSGTile *neighbor;
	NSLog(@"Creating Maze Tiles");
		//for every row
	for (int y=0; y<_size.height; y++) {
			//and every tile in that row
		for (int x=0; x<_size.width; x++) {
				//create a tile
			DSGTile *current = [[DSGTile alloc]initWithPosition:CGPointMake(x, y)];
				//if y is zero we're at the bottom and there is no neighbor below to get
			if (y != 0) {
					//otherwise get thy neighbor
				neighbor = [_mazeTiles objectAtIndex:((y-1)*_size.width)+x];
				if (!neighbor) {
					NSLog(@"nilling");
				}
					//create strong connection. giggadi.
				[current.walls replaceObjectAtIndex:DSGMazeDirectionDown withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionUp withObject:current];
				
			}
				//if x is zero we're on the right edge and there is no neighbor to the left.
			if (x != 0){
					//else get the neighbor
				neighbor = [_mazeTiles lastObject];
				if (!neighbor) {
					NSLog(@"nilling");
				}
					//create strong connection. goo.
				[current.walls replaceObjectAtIndex:DSGMazeDirectionLeft withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionRight withObject:current];
			}
				//add tile to maze/graph
			[_mazeTiles addObject:current];
		}
	}
	NSLog(@"Maze Tiles Created");
	
}

@end
