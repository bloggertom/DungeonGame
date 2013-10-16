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
		
		_physicsDelegate = [[DSGPhysicsDelegate alloc]init];
		self.physicsWorld.contactDelegate = _physicsDelegate;
		self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
		_worldSize = 3000;
		_tileSize = 500;
		[self addBackground];
	}
	return self;
}
-(void)didBeginContact:(SKPhysicsContact *)contact{
	NSLog(@"contact");
}
-(void)startLevel{
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
	
	[self.hero updateForTimeIntervale:time];
}

#pragma mark - Building Map
-(void)addBackground{
	int count = 0;
		//SKLabelNode *label;
	SKShapeNode *square = [[SKShapeNode alloc]init];
	square.strokeColor = [SKColor blueColor];
	square.path = CGPathCreateWithRect(CGRectMake(0, 0, 500, 500),nil);
	[self addChildNode:square atWorldLayer:DSGWorldLayerGround];
	for (SKNode *node in sBackgroundTiles) {
		/*label = [[SKLabelNode alloc]initWithFontNamed:@"AmericanTypewriter"];
		label.text = [NSString stringWithFormat:@"%d",count];
		label.position = node.position;
		label.fontColor = [SKColor greenColor];*/
		[self addChildNode:node atWorldLayer:DSGWorldLayerGround];
			//[self addChildNode:label atWorldLayer:DSGDebugLayer];
		
		count++;
	}
	
}

#pragma mark - Static Methods
#pragma mark - Load Assets

+(void)loadAssets{
	[self loadBackgroundTiles];
	
	[DSGWizard loadAssets];
}

+(void)loadBackgroundTiles{
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
	DSGMapBuilder *builder = [[DSGMapBuilder alloc]initWithFloorTextures:floor andWallTextures:walls];
	
	sBackgroundTiles = [builder buildMapOfSize:CGSizeMake(300, 300) forTilesOfSize:CGSizeMake(32, 32)];
	NSLog(@"Background tiles loaded %lu", (unsigned long)sBackgroundTiles.count);
	
}

+ (void)releaseLevelAssets{
	sBackgroundTiles = nil;
	sLevelDataImage = nil;
	
}
#pragma mark - Assets Declaration
static NSMutableArray *sBackgroundTiles;
static UIImage *sLevelDataImage;

@end
