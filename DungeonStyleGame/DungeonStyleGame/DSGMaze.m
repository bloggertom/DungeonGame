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
		NSLog(@"%f", size.width*size.height);
		_mazeTiles = [[NSMutableArray alloc]initWithCapacity:size.width*size.height];
		_path = [[NSMutableArray alloc]initWithCapacity:size.width*size.height];
		[self createMazeTiles];
	}
	return self;
}

-(void)createMazeTiles{
	DSGTile *neighbor;
	NSLog(@"Creating Maze Tiles");
	for (int y=0; y<_size.height; y++) {
		for (int x=0; x<_size.width; x++) {
			DSGTile *current = [[DSGTile alloc]initWithPosition:CGPointMake(x, y)];
			if (y != 0) {
				neighbor = [_mazeTiles objectAtIndex:((y-1)*_size.width)+x];
				if (!neighbor) {
					NSLog(@"nilling");
				}
				[current.walls replaceObjectAtIndex:DSGMazeDirectionDown withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionUp withObject:current];
				
			}
			if (x != 0){
				NSLog(@"%d",y);
				neighbor = [_mazeTiles lastObject];
				if (!neighbor) {
					NSLog(@"nilling");
				}
				[current.walls replaceObjectAtIndex:DSGMazeDirectionLeft withObject:neighbor];
				[neighbor.walls replaceObjectAtIndex:DSGMazeDirectionRight withObject:current];
			}
			
			[_mazeTiles addObject:current];
		}
	}
	NSLog(@"Maze Tiles Created");
	
}

@end
