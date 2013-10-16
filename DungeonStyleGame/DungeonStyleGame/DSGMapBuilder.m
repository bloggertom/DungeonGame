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
#import "DSGTile.h"
#import "TWTiledSpriteNode.h"
#import "DSGWall.h"

@interface DSGMapBuilder ()
@property(nonatomic)CGSize tileSize;
@property(nonatomic)CGSize mazeSize;
@property (nonatomic)CGSize mapSize;
@end


@implementation DSGMapBuilder

-(id)initWithFloorTexture:(SKTexture *)floorTexture andWallTexture:(SKTexture *)wallTexture{
	NSArray *floorArray = @[floorTexture];
	NSArray *wallArray = @[wallTexture];
	return [self initWithFloorTextures:floorArray andWallTextures:wallArray];
}

-(id)initWithFloorTextures:(NSArray *)floorTextures andWallTextures:(NSArray *)wallTextures{
	self = [super init];
	if (self) {
		self.wallTexture = wallTextures;
		self.floorTextures = floorTextures;
	}
	return self;
}

-(NSMutableArray*)buildMapOfSize:(CGSize)size forTilesOfSize:(CGSize)tileSize{
	DSGMazeGenerator *generator = [[DSGMazeGenerator alloc]init];
	_mapSize = size;
	_tileSize = size;
	CGFloat tWidth = lroundf(size.width / tileSize.width);
	CGFloat tHeight = lroundf(size.height / tileSize.height);
	
	((int)tWidth%2 == 0)? tWidth++ : tWidth;
	((int)tHeight%2 == 0)? tHeight++ : tHeight;
	CGSize tMazeSize = CGSizeMake(tWidth, tHeight);
	_mazeSize = tMazeSize;
	NSLog(@"Iniciating Maz Generator");
	DSGMaze *maze = [generator generateMazeOfSize:tMazeSize];
	
	

	return [self buildMapFromMaze:maze withTilesOfSize:(CGSize)tileSize];
}

-(NSMutableArray*)buildMapFromMaze:(DSGMaze *)maze withTilesOfSize:(CGSize)tileSize{
	NSMutableArray *mapNodes = [[NSMutableArray alloc]init];

	NSLog(@"Building Map array");
	for(DSGTile *currentTile in maze.path) {
			//NSLog(@"While 2");
		currentTile.size = tileSize;
		DSGTile *next = nil;
		DSGTile *previous = nil;
		if ([maze.path indexOfObject:currentTile] != maze.path.count-1) {
			next = [maze.path objectAtIndex:[maze.path indexOfObject:currentTile]+1];
		}
		if ([maze.path indexOfObject:currentTile] != 0) {
			previous = [maze.path objectAtIndex:[maze.path indexOfObject:currentTile]-1];
		}
		
		DSGMazeDirection direction;
		
		if (next) {
			direction = [DSGTile mazeDirectionFromTilePosition:currentTile.position toPosition:next.position];
			NSLog(@"Next Used");
		}
		if (next == nil || direction == DSGMazeDirectionUnknown) {
			NSLog(@"Previous used %d", direction);
			direction = [DSGTile mazeDirectionFromTilePosition:currentTile.position toPosition:previous.position];
		}
		
		CGPoint mapTilePosition = [DSGMapBuilder convertMazePoint:currentTile.position toMapPointWithTileSize:tileSize];
		
		SKTexture *texture = [_floorTextures objectAtIndex:arc4random_uniform((int)_floorTextures.count)];
		SKSpriteNode *mapTile = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
		mapTile.position = mapTilePosition;
		
		
		[mapNodes addObject:mapTile];
			//extend paths across to next maze tile.
		if ([[currentTile.walls objectAtIndex:DSGMazeDirectionRight] isKindOfClass:[NSString class]] && currentTile.position.x != (maze.size.width-1)) {
			SKSpriteNode *pathRightNode = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
			pathRightNode.position = CGPointMake((mapTilePosition.x + mapTile.size.width), mapTilePosition.y);
			[mapNodes addObject:pathRightNode];
		}
		if ([[currentTile.walls objectAtIndex:DSGMazeDirectionDown]isKindOfClass:[NSString class]] && currentTile.position.y != 0) {
			SKSpriteNode *pathDownNode = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
			pathDownNode.position = CGPointMake(mapTilePosition.x, mapTilePosition.y-mapTile.size.height);
			[mapNodes addObject:pathDownNode];
		}
			[mapNodes addObjectsFromArray:[self generateWallsForMazeTile:currentTile ofSize:tileSize]];
	}
	NSLog(@"Map Array built");
	
	
	return mapNodes;
	
}

-(NSArray *)generateWallsForMazeTile:(DSGTile*)tile ofSize:(CGSize)size{
	NSMutableArray *walls = [[NSMutableArray alloc]init];
	CGPoint mapPoint = [DSGMapBuilder convertMazePoint:tile.position toMapPointWithTileSize:size];
	
	if ([[tile.walls objectAtIndex:DSGMazeDirectionUp]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Up"] atPosition:CGPointMake(mapPoint.x, mapPoint.y + size.height)];
		wall.size = CGSizeMake(size.width*3, size.height);
		[walls addObject:wall];
	}
	if ([[tile.walls objectAtIndex:DSGMazeDirectionRight]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Right"] atPosition:CGPointMake(mapPoint.x + size.width, mapPoint.y)];
		wall.size = CGSizeMake(size.width, size.height*3);
		[walls addObject:wall];
		
	}
	if ([[tile.walls objectAtIndex:DSGMazeDirectionLeft]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Left"] atPosition:CGPointMake(mapPoint.x - size.width, mapPoint.y)];
		wall.size = CGSizeMake(size.width, size.height*3);
		[walls addObject:wall];
		
	}
	if ([[tile.walls objectAtIndex:DSGMazeDirectionDown]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Down"] atPosition:CGPointMake(mapPoint.x, mapPoint.y - size.height)];
		wall.size = CGSizeMake(size.width*3, size.height);
		[walls addObject:wall];
	}
	
	return walls;
}

+(CGPoint)convertMazePoint:(CGPoint)mazePoint toMapPointWithTileSize:(CGSize)size{
	CGPoint newPoint = CGPointMake((mazePoint.x*2)+1, (mazePoint.y*2)+1);
	CGPoint thePoint = CGPointMake((newPoint.x*size.width)-(size.width/2),(newPoint.y*size.height)-(size.height/2));
	return thePoint;
}

@end
