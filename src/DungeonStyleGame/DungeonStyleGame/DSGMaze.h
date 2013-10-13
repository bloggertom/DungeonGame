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


@property(nonatomic, readonly)CGSize size;
@property(nonatomic, strong)NSMutableArray *mazeTiles;
@property(nonatomic, strong)DSGTile *start;

-(id)initWithSize:(CGSize)size;

@end
