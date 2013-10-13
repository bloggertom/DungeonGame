//
//  DSGTile.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: uint8_t{
	DSGMazeDirectionUp = 1,
	DSGMazeDirectionDown,
	DSGMazeDirectionLeft,
	DSGMazeDirectionRight
} DSGMazeDirection;
typedef enum: uint8_t{
	DSGTilePathDirectionForward = 1,
	DSGTilePathDirectionBackward
}DSGTilePathDirection;
@interface DSGTile : NSObject

@property(nonatomic, readonly)CGPoint position;
@property(nonatomic)BOOL visited;

@property(nonatomic)NSMutableArray *walls;
@property(nonatomic)NSMutableArray *paths;

-(id)initWithPosition:(CGPoint)position;
@end
