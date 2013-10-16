//
//  DSGMazeGenerator.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

-(void)push:(id)item;
-(id)pop;
-(id)peek;
@end

@implementation NSMutableArray (Stack)

-(void)push:(id)item{
	[self addObject:item];
}
-(id)pop{
	id item = [self lastObject];
	[self removeObject:item];
	
	return item;
}
-(id)peek{
	return [self lastObject];
}
@end

@class DSGMaze;

@interface DSGMazeGenerator : NSObject

-(DSGMaze*)generateMazeOfSize:(CGSize)size;
+(DSGMaze *)generateMazeOfSize:(CGSize)size;

-(CGSize)mapSize;

@end
