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
@interface DSGTestLevel()
@property (nonatomic, strong)DSGPhysicsDelegate *physicsDelegate;

@end

@implementation DSGTestLevel

-(id)initWithSize:(CGSize)size{
	self = [super initWithSize:size];
	
	if(self){
		
		_physicsDelegate = [[DSGPhysicsDelegate alloc]init];
		if(_physicsDelegate){
			NSLog(@"physics delegate");
		}
		
		self.physicsWorld.contactDelegate = _physicsDelegate;
		self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
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
	for (SKNode *node in sBackgroundTiles) {
		[self addChildNode:node atWorldLayer:DSGWorldLayerGround];
	}
	
}

#pragma mark - Static Methods
#pragma mark - Load Assets

+(void)loadAssets{
	[self loadBackgroundTiles];
	
	[DSGWizard loadAssets];
}

+(void)loadBackgroundTiles{
	SKTextureAtlas *backgroundTiles = [SKTextureAtlas atlasNamed:@"Map"];
	
	sBackgroundTiles = [[NSMutableArray alloc]initWithCapacity:kBackgroundTileDevisor];
	
	for (int y=0; y < kBackgroundTileDevisor; y++) {
		for (int x=0; x < kBackgroundTileDevisor; x++) {
			int ran = arc4random() % kNumTilesTextures+1;
				//NSLog(@"Random Number = %d", ran);
			SKTexture *texture = [backgroundTiles textureNamed:[NSString stringWithFormat:@"%d",ran]];
			CGPoint position = CGPointMake((x * kGroundTileSize) - kWorldCenter,
										   (kWorldSize - (y * kGroundTileSize)) - kWorldCenter);
			SKSpriteNode *tile = [[SKSpriteNode alloc]initWithTexture:texture];
			tile.position = position;
			[sBackgroundTiles addObject:tile];
			
		}
	}
}

+ (void)releaseLevelAssets{
	sBackgroundTiles = nil;
	sLevelDataImage = nil;
	
}
#pragma mark - Assets Declaration
static NSMutableArray *sBackgroundTiles;
static UIImage *sLevelDataImage;

@end
