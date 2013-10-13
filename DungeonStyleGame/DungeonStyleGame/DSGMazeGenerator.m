//
//  DSGMazeGenerator.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGMazeGenerator.h"
#import "DSGMaze.h"
#import "DSGTile.h"
@interface DSGMazeGenerator ()
@property(nonatomic, strong)DSGTile *currentTile;
@property(nonatomic)CGSize mazeSize;
@property(nonatomic)CGSize mapSize;
@property (nonatomic, strong)DSGMaze *currentMaze;
@end

@implementation DSGMazeGenerator

+(DSGMaze *)generateMazeOfSize:(CGSize)size{
	DSGMazeGenerator *generator = [[DSGMazeGenerator alloc]init];
	return [generator generateMazeOfSize:size];
}

-(DSGMaze*)generateMazeOfSize:(CGSize)size{
	_currentMaze = [[DSGMaze alloc]initWithSize:size];
	_mapSize = CGSizeMake((size.width*2)+1, (size.height*2)+1);
	_mazeSize = size;
	
	[self createPath];
	
	
	return _currentMaze;
}

-(void)createPath{
	NSUInteger x = arc4random_uniform(_mazeSize.width);
	NSUInteger y = arc4random_uniform(_mazeSize.height);
	NSMutableArray *stack = [[NSMutableArray alloc]init];
	int visitedCount = 1;
	_currentTile = [_currentMaze.mazeTiles objectAtIndex:x*y];
	_currentMaze.start = _currentTile;
	_currentTile.visited = YES;
	
	while (visitedCount < [_currentMaze.mazeTiles count]) {
		NSArray *array = [_currentTile.walls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"visited == TRUE"]];
		if ([array count]) {
			int index = arc4random_uniform((int)[array count]);
			[stack push:_currentTile];
			DSGTile *temp = [_currentTile.walls objectAtIndex:index];
			[_currentTile.walls removeObject:temp];
			[_currentTile.paths replaceObjectAtIndex:DSGTilePathDirectionForward withObject:temp];
			[temp.walls removeObject:_currentTile];
			[temp.paths replaceObjectAtIndex:DSGTilePathDirectionBackward withObject:_currentTile];
			_currentTile = temp;
			_currentTile.visited = YES;
			visitedCount ++;
		}else if([stack count]){
			_currentTile = [stack pop];
		}else{
			NSArray *unvisited = [_currentMaze.mazeTiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"visited == NO"]];
			int index = arc4random_uniform((int)[unvisited count]);
			_currentTile = [unvisited objectAtIndex:index];
			_currentTile.visited = YES;
			visitedCount ++;
		}
	}
}

@end
