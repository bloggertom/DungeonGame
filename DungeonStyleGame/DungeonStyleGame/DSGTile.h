//
//  DSGTile.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: uint8_t{
	DSGMazeDirectionUp,
	DSGMazeDirectionDown,
	DSGMazeDirectionLeft,
	DSGMazeDirectionRight,
	DSGMazeDirectionUnknown
	
} DSGMazeDirection;

@interface DSGTile : NSObject

@property(nonatomic, readonly)CGPoint position;
@property(nonatomic)BOOL visited;

@property(nonatomic)NSMutableArray *walls;


@property(nonatomic)CGSize size;

-(id)initWithPosition:(CGPoint)position;

+(DSGMazeDirection)mazeDirectionFromTilePosition:(CGPoint)one toPosition:(CGPoint)two;
@end
