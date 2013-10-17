//
//  DSGTile.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

	//directions of neighbors.
typedef enum: uint8_t{
	DSGMazeDirectionUp,
	DSGMazeDirectionDown,
	DSGMazeDirectionLeft,
	DSGMazeDirectionRight,
	DSGMazeDirectionUnknown
	
} DSGMazeDirection;

@interface DSGTile : NSObject

@property(nonatomic, readonly)CGPoint position;//position in grid.
@property(nonatomic)BOOL visited;//has this tile been visited? not really used in the end.
@property(nonatomic)NSMutableArray *walls;//walls array hold neighbors. A tile in here means there is a wall between it and self
@property(nonatomic)CGSize size;//size of tile.

-(id)initWithPosition:(CGPoint)position;

+(DSGMazeDirection)mazeDirectionFromTilePosition:(CGPoint)one toPosition:(CGPoint)two;
@end
