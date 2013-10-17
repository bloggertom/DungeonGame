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
		//detirmin number of tiles in map
	CGFloat tWidth = lroundf(size.width / tileSize.width);
	CGFloat tHeight = lroundf(size.height / tileSize.height);
		//ensure it's an odd number.
	((int)tWidth%2 == 0)? tWidth++ : tWidth;
	((int)tHeight%2 == 0)? tHeight++ : tHeight;
	CGSize tMazeSize = CGSizeMake(tWidth, tHeight);
	
	NSLog(@"Iniciating Maz Generator");
	
		//use maze generator to create 'perfect' maze.
	DSGMaze *maze = [generator generateMazeOfSize:tMazeSize];
	
	
		//build map from maze and return
	return [self buildMapFromMaze:maze withTilesOfSize:(CGSize)tileSize];
}

-(NSMutableArray*)buildMapFromMaze:(DSGMaze *)maze withTilesOfSize:(CGSize)tileSize{
	NSMutableArray *mapNodes = [[NSMutableArray alloc]init];

		//loop through maze tiles to create map.
	NSLog(@"Building Map array");
	for(DSGTile *currentTile in maze.path) {
		currentTile.size = tileSize;
		DSGTile *next = nil;
		DSGTile *previous = nil;
		
			//get next and previous tiles.
		if ([maze.path indexOfObject:currentTile] != maze.path.count-1) {
			next = [maze.path objectAtIndex:[maze.path indexOfObject:currentTile]+1];
		}
		if ([maze.path indexOfObject:currentTile] != 0) {
			previous = [maze.path objectAtIndex:[maze.path indexOfObject:currentTile]-1];
		}
		
		
			//get direction of travel
		DSGMazeDirection direction;
		if (next) {
			direction = [DSGTile mazeDirectionFromTilePosition:currentTile.position toPosition:next.position];
			NSLog(@"Next Used");
		}
			//if dead end use previous tile instead.
		if (next == nil || direction == DSGMazeDirectionUnknown) {
			NSLog(@"Previous used %d", direction);
			direction = [DSGTile mazeDirectionFromTilePosition:currentTile.position toPosition:previous.position];
		}
			//get position in tiles for map
		CGPoint mapTilePosition = [DSGMapBuilder convertMazePoint:currentTile.position toMapPointWithTileSize:tileSize];
		
		
			//get a random texture and use it to create floor tile
			//SKTexture *texture = [_floorTextures objectAtIndex:arc4random_uniform((int)_floorTextures.count)];
			//SKSpriteNode *mapTile = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
		TWTiledSpriteNode *mapTile = [[TWTiledSpriteNode alloc]initWithTextures:_floorTextures andSize:tileSize];
		mapTile.position = mapTilePosition;
		
			//add floor tile to mapNodes array
		[mapNodes addObject:mapTile];
		
		
			//Join maze tiles together to form complete maze
		if ([[currentTile.walls objectAtIndex:DSGMazeDirectionRight] isKindOfClass:[NSString class]] && currentTile.position.x != (maze.size.width-1)) {
				//SKSpriteNode *pathRightNode = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
			TWTiledSpriteNode *pathRightNode = [[TWTiledSpriteNode alloc]initWithTextures:_floorTextures andSize:tileSize];
			pathRightNode.position = CGPointMake((mapTilePosition.x + mapTile.size.width), mapTilePosition.y);
			[mapNodes addObject:pathRightNode];
		}
		if ([[currentTile.walls objectAtIndex:DSGMazeDirectionDown]isKindOfClass:[NSString class]] && currentTile.position.y != 0) {
				//SKSpriteNode *pathDownNode = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
			TWTiledSpriteNode *pathDownNode = [[TWTiledSpriteNode alloc]initWithTextures:_floorTextures andSize:tileSize];
			pathDownNode.position = CGPointMake(mapTilePosition.x, mapTilePosition.y-mapTile.size.height);
			[mapNodes addObject:pathDownNode];
		}
		
			//surround inner maze with walls for collitions
			[mapNodes addObjectsFromArray:[self generateWallsForMazeTile:currentTile ofSize:tileSize]];
	}
	NSLog(@"Map Array built");
	
	
	return mapNodes;
	
}

-(NSArray *)generateWallsForMazeTile:(DSGTile*)tile ofSize:(CGSize)size{
	NSMutableArray *walls = [[NSMutableArray alloc]init];
	CGPoint mapPoint = [DSGMapBuilder convertMazePoint:tile.position toMapPointWithTileSize:size];
		//check walls array for direction of walls
		//all walls are 3 times the length of standard tile to make up for difference in space
		//between a maze tile and a map tile.
	
		//up
	if ([[tile.walls objectAtIndex:DSGMazeDirectionUp]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Up"] atPosition:CGPointMake(mapPoint.x, mapPoint.y + size.height)];
		wall.size = CGSizeMake(size.width*3, size.height);
		[walls addObject:wall];
	}
		//right
	if ([[tile.walls objectAtIndex:DSGMazeDirectionRight]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Right"] atPosition:CGPointMake(mapPoint.x + size.width, mapPoint.y)];
		wall.size = CGSizeMake(size.width, size.height*3);
		[walls addObject:wall];
		
	}
		//left
	if ([[tile.walls objectAtIndex:DSGMazeDirectionLeft]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Left"] atPosition:CGPointMake(mapPoint.x - size.width, mapPoint.y)];
		wall.size = CGSizeMake(size.width, size.height*3);
		[walls addObject:wall];
		
	}
		//down
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
