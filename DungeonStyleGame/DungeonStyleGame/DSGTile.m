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
		_visited = NO;
		
			//if it's @"0" stand for no wall here...
		for (int i = 0; i<4; i++) {
			[_walls addObject:@"0"];
			
		}
	}
	return self;
}

+(DSGMazeDirection)mazeDirectionFromTilePosition:(CGPoint)one toPosition:(CGPoint)two{
	CGFloat deltaX = one.x - two.x;
	CGFloat deltaY = one.y - two.y;
	
	DSGMazeDirection direction = 0;
	
	if (deltaX > 0 && deltaY == 0) {
		direction = DSGMazeDirectionLeft;
	}else if (deltaX < 0 && deltaY == 0) {
		direction = DSGMazeDirectionRight;
	}else if (deltaY > 0 && deltaX == 0){
		direction = DSGMazeDirectionDown;
	}else if (deltaY < 0 && deltaX == 0){
		direction = DSGMazeDirectionUp;
	}else{
		direction = DSGMazeDirectionUnknown;
	}
	return direction;
}

@end
