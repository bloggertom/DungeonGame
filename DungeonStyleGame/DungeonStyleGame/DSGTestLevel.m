//
//  DSGTestLevel.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGTestLevel.h"
#import "DSGWizard.h"
#import "DSGPhysicsDelegate.h"
#import "DSGGrub.h"
#import "DSGMapBuilder.h"


@interface DSGTestLevel()
@property (nonatomic, strong)DSGPhysicsDelegate *physicsDelegate;
@property (nonatomic)CGFloat worldSize;
@property (nonatomic)CGFloat tileSize;
@end

@implementation DSGTestLevel

-(id)initWithSize:(CGSize)size{
	self = [super initWithSize:size];
	
	if(self){
			//set up world physics
		_physicsDelegate = [[DSGPhysicsDelegate alloc]init];
		self.physicsWorld.contactDelegate = _physicsDelegate;
		self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
			//world sizes
		_worldSize = 3000;
		_tileSize = 500;
		
			//add background nodes
		[self addBackground];
	}
	return self;
}

-(void)startLevel{
		//let the games begin
	DSGWizard *hero = [[DSGWizard alloc]initAtPosition:CGPointMake(200,200)];
	NSLog(@"Width %f, Height %f", hero.size.width, hero.size.height);
	DSGGrub *grub = [[DSGGrub alloc]initAtPosition:CGPointMake(300, 300)];
	[self.monsters addObject:grub];
	self.hero = hero;
	[self addChildNode:hero atWorldLayer:DSGCharacterLayer];
	[self addChildNode:grub atWorldLayer:DSGCharacterLayer];
	self.hero.isAnimated = YES;
}

#pragma mark - Update Cycle

-(void)updateForTimeIntervale:(NSTimeInterval)time{
		//update hero
	[self.hero updateForTimeIntervale:time];
}

#pragma mark - Building Map
-(void)addBackground{
	int count = 0;
		//SKLabelNode *label;
		//SKShapeNode *square = [[SKShapeNode alloc]init];
		//square.strokeColor = [SKColor blueColor];
		//square.path = CGPathCreateWithRect(CGRectMake(0, 0, 500, 500),nil);
		//[self addChildNode:square atWorldLayer:DSGWorldLayerGround];
	for (SKNode *node in sBackgroundTiles) {
		
		[self addChildNode:node atWorldLayer:DSGWorldLayerGround];

		
		count++;
	}
	
}

#pragma mark - Static Methods
#pragma mark - Load Assets

+(void)loadAssets{
		//load background tiles
	[self loadBackgroundTiles];
		//ask wizard to load assets
	[DSGWizard loadAssets];
}

+(void)loadBackgroundTiles{
		//load textures for background and walls
	SKTextureAtlas *backgroundTextures = [SKTextureAtlas atlasNamed:@"Map"];
	SKTextureAtlas *wallTextures = [SKTextureAtlas atlasNamed:@"Debug"];
	NSLog(@"Load background tiles");
	NSMutableArray *floor = [[NSMutableArray alloc]init];
	for (NSString *name in backgroundTextures.textureNames) {
		[floor addObject:[backgroundTextures textureNamed:name]];
	}
	NSMutableArray *walls = [[NSMutableArray alloc]init];
	for (NSString *name in wallTextures.textureNames) {
		[walls addObject:[wallTextures textureNamed:name]];
	}
	
		//create builder from textures
	DSGMapBuilder *builder = [[DSGMapBuilder alloc]initWithFloorTextures:floor andWallTextures:walls];
		//build map into sBackgroundTiles (floor and walls)
	sBackgroundTiles = [builder buildMapOfSize:CGSizeMake(kWorldSize, kWorldSize) forTilesOfSize:CGSizeMake(300, 300)];
	NSLog(@"Background tiles loaded %lu", (unsigned long)sBackgroundTiles.count);
	
}

+ (void)releaseLevelAssets{
		//release static stuff
	sBackgroundTiles = nil;
	sLevelDataImage = nil;
	
}
#pragma mark - Assets Declaration
static NSMutableArray *sBackgroundTiles;
static UIImage *sLevelDataImage;

@end
