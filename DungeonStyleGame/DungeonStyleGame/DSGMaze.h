//
//  DSGMaze.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSGTile;

@interface DSGMaze : NSObject


@property(nonatomic, readonly)CGSize size;//size in tiles
@property(nonatomic, strong)NSMutableArray *mazeTiles;//tiles or graph
@property(nonatomic, strong)DSGTile *start;//where does the maze start
@property(nonatomic, strong)NSMutableArray *path;//the path through the maze.

-(id)initWithSize:(CGSize)size;

@end
