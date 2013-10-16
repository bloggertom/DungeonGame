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
	//@property(nonatomic)CGSize tileSize;
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
	
	CGFloat tWidth = lroundf(size.width / tileSize.width);
	CGFloat tHeight = lroundf(size.height / tileSize.height);
	
	((int)tWidth%2 == 0)? tWidth++ : tWidth;
	((int)tHeight%2 == 0)? tHeight++ : tHeight;
	CGSize tMazeSize = CGSizeMake(tWidth, tHeight);
	
	NSLog(@"Iniciating Maz Generator");
	DSGMaze *maze = [generator generateMazeOfSize:tMazeSize];
	
	

	return [self buildMapFromMaze:maze withTilesOfSize:(CGSize)tileSize];
}

-(NSMutableArray*)buildMapFromMaze:(DSGMaze *)maze withTilesOfSize:(CGSize)tileSize{
		//[NSException raise:@"DSGMethodNotImplemented" format:@"buildMapFromMaze: Method has not been implamented yet"];
	NSMutableArray *mapNodes = [[NSMutableArray alloc]init];
		//DSGTile *currentTile = maze.start;
	SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Debug"];
	NSArray *names = atlas.textureNames;
	NSMutableArray *textures = [[NSMutableArray alloc]init];
	for (NSString *name in names) {
		SKTexture *texture = [atlas textureNamed:name];
		[textures addObject:texture];
	}

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
		
		SKTexture *texture = texture = [[SKTextureAtlas atlasNamed:@"Map"]textureNamed:@"1"];
		SKSpriteNode *mapTile = [SKSpriteNode spriteNodeWithTexture:texture size:tileSize];
		mapTile.position = mapTilePosition;
		
		
		[mapNodes addObject:mapTile];
		
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
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Up"] atPosition:mapPoint];
		CGPoint aPoint= CGPointMake(mapPoint.x, mapPoint.y + size.height);
		CGSize aSize = size;
		
		if ([[tile.walls objectAtIndex:DSGMazeDirectionRight]isKindOfClass:[NSString class]]) {
			aPoint.x += (size.width/2);
			aSize.width *=2;
		}else{// if ([[tile.walls objectAtIndex:DSGMazeDirectionLeft]isKindOfClass:[NSString class]]){
			aPoint.x -= (size.width/2);
			aSize.width *=2;
		}
		wall.position = aPoint;
		wall.size = aSize;
		[walls addObject:wall];
	}
	if ([[tile.walls objectAtIndex:DSGMazeDirectionRight]isKindOfClass:[DSGTile class]]) {
		DSGWall *wall = [[DSGWall alloc]initWithTexture:[[SKTextureAtlas atlasNamed:@"Debug"]textureNamed:@"Right"] atPosition:mapPoint];
		CGPoint aPoint = CGPointMake(mapPoint.x + size.width, mapPoint.y);
		CGSize aSize = size;
		
		if ([[tile.walls objectAtIndex:DSGMazeDirectionUp]isKindOfClass:[NSString class]]) {
			aPoint.y -= (size.height/2);
			aSize.height *=2;
		}else{// if([[tile.walls objectAtIndex:DSGMazeDirectionDown]isKindOfClass:[NSString class]]){
			aPoint.y +=(size.height/2);
			aSize.height *=2;
		}
		wall.position = aPoint;
		wall.size = aSize;
		[walls addObject:wall];
		
	}
	return walls;
}
/*
-(CGPoint)convertMazePointToMapPoint:(CGPoint)mazePoint{
	return [DSGMapBuilder convertMazePoint:mazePoint toMapPointWithTileSize:_tileSize];
}
*/
+(CGPoint)convertMazePoint:(CGPoint)mazePoint toMapPointWithTileSize:(CGSize)size{
	CGPoint newPoint = CGPointMake((mazePoint.x*2)+1, (mazePoint.y*2)+1);
	CGPoint thePoint = CGPointMake((newPoint.x*size.width)-(size.width/2),(newPoint.y*size.height)-(size.height/2));
	return thePoint;
}

@end
