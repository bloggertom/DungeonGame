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
	_mazeSize = CGSizeMake((size.width-1)/2, (size.height-1)/2);
	_currentMaze = [[DSGMaze alloc]initWithSize:_mazeSize];
	
	[self createPath];
	
	
	return _currentMaze;
}

-(void)createPath{
	NSLog(@"Creating Maz path");
	NSUInteger x = arc4random_uniform(_mazeSize.width);
	NSUInteger y = arc4random_uniform(_mazeSize.height-1);
	y *= _mazeSize.width-1;
	NSMutableArray *stack = [[NSMutableArray alloc]init];
	int visitedCount = 1;
	_currentTile = [_currentMaze.mazeTiles objectAtIndex:x+y];
	_currentMaze.start = _currentTile;
	[_currentMaze.path addObject:_currentTile];
	_currentTile.visited = YES;
	
	while (visitedCount < [_currentMaze.mazeTiles count]) {
		NSArray *array = [_currentTile.walls filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			if([evaluatedObject isKindOfClass:[DSGTile class]]){
				DSGTile *ob = (DSGTile *)evaluatedObject;
				return (!ob.visited);
			}
			return NO;
		}]];
			//NSLog(@"While1");
		if ([array count]) {
			int index = arc4random_uniform((int)[array count]);
			[stack push:_currentTile];
			DSGTile *temp = (DSGTile*)[array objectAtIndex:index];
			[_currentTile.walls replaceObjectAtIndex:[_currentTile.walls indexOfObject:temp] withObject:@"0"];
			[temp.walls replaceObjectAtIndex:[temp.walls indexOfObject:_currentTile] withObject:@"0"];
			if (CGPointEqualToPoint(temp.position, _currentTile.position)) {
				NSLog(@"stop");
			}
			
			_currentTile = temp;
			_currentTile.visited = YES;
			[_currentMaze.path addObject:_currentTile];
			visitedCount ++;
			
		}else if([stack count]){
			DSGTile *temp = [stack pop];
			_currentTile = temp;
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
