//
//  DSGMapBuilder.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 09/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGMapBuilder.h"
#import "DSGMazeGenerator.h"
#import "DSGMaze.h"

@interface DSGMapBuilder ()
	//@property(nonatomic, strong)DSGMazeGenerator *mazeGenerator;
@end

@implementation DSGMapBuilder

-(NSArray*)buildMapOfSize:(CGSize)size{
	NSMutableArray *mapNodes = [[NSMutableArray alloc]init];
	DSGMaze *maze = [DSGMazeGenerator generateMazeOfSize:size];
	
	
	
	
	return (NSArray*)mapNodes;
}


@end
