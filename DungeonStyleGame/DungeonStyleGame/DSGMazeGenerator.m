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
	NSLog(@"Generate map");
	_mapSize = size;
	
		//determin maze size (in tiles)
	_mazeSize = CGSizeMake((size.width-1)/2, (size.height-1)/2);//ensures all tiles lie inside the
																//map tiles so walls could be placed around the edge
	//init maze (4x4 strongly connected graph of DSGTiles)
	_currentMaze = [[DSGMaze alloc]initWithSize:_mazeSize];
	
		//create maze path
	[self createPath];
	
	
	return _currentMaze;
}

-(void)createPath{
	NSLog(@"Creating Maz path");
		//choose a random starting possition
	NSUInteger x = arc4random_uniform(_mazeSize.width);
	NSUInteger y = arc4random_uniform(_mazeSize.height-1);
		//-1 so as to not count last row.
	y *= _mazeSize.width-1;
		//stack for backtracking
	NSMutableArray *stack = [[NSMutableArray alloc]init];
	
		//select current tile, set it as visited
	int visitedCount = 1;
	_currentTile = [_currentMaze.mazeTiles objectAtIndex:x+y];
	
		//keep recored of starting location for convenience.
	_currentMaze.start = _currentTile;
	
		//add current tile to path before starting
	[_currentMaze.path addObject:_currentTile];
	_currentTile.visited = YES;
	
		//while there are still tiles to be visited
	while (visitedCount < [_currentMaze.mazeTiles count]) {
		
			//get unvisited neighbors of current tile.
		NSArray *array = [_currentTile.walls filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			if([evaluatedObject isKindOfClass:[DSGTile class]]){
				DSGTile *ob = (DSGTile *)evaluatedObject;
				return (!ob.visited);
			}
			return NO;
		}]];
			//if there are unvisited neighbors
		if ([array count]) {
				//select a random one
			int index = arc4random_uniform((int)[array count]);
			[stack push:_currentTile];
			DSGTile *temp = (DSGTile*)[array objectAtIndex:index];
			
				//remove the wall between them
			[_currentTile.walls replaceObjectAtIndex:[_currentTile.walls indexOfObject:temp] withObject:@"0"];
			[temp.walls replaceObjectAtIndex:[temp.walls indexOfObject:_currentTile] withObject:@"0"];
			
				//set neighbor as current tile
			_currentTile = temp;
				//set it to visited
			_currentTile.visited = YES;
				//add it to maze path
			[_currentMaze.path addObject:_currentTile];
				//increment visited count
			visitedCount ++;
			
				//if all neighbors visited pop stack (backtrack)
		}else if([stack count]){
			DSGTile *temp = [stack pop];
			_currentTile = temp;
			
				//if all else fails pick a random tile and go from there (never called, currently legacy code)
		}else{
			NSArray *unvisited = [_currentMaze.mazeTiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"visited == NO"]];
			int index = arc4random_uniform((int)[unvisited count]);
			_currentTile = [unvisited objectAtIndex:index];
			_currentTile.visited = YES;
			visitedCount ++;
			NSLog(@"random");
		}
	}
	NSLog(@"Maz path created");
}

-(CGSize)mapSize{
	return _mapSize;
}

@end
