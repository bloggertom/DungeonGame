//
//  DSGWizard.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGWizard.h"
#import "DSGLevel.h"

#define kNIdelFrames 4
#define kNWalkingRightFrames 8
#define kNWalkingLeftFrames 8
#define kNWalkingUpFrames 8
#define kNWalkingDownFrames 8
#define kNFiringRightFrames 8
#define kNFiringLeftFrames 8

#define kMagicMissileFrames 4
#define kMagicMissileDistance 1000
@implementation DSGWizard

-(id)initAtPosition:(CGPoint)position{
	SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Wizard_Idle"];
	SKTexture *texture = [atlas textureNamed:@"Idle_right"];
	
	self = [super initWithTexture:texture atPosition:position];
	
	if (self) {
			//self.collisionBox = self.frame;//CGRectMake(0,0, texture.size.width, texture.size.height);
		NSString *emitterpath = [[NSBundle mainBundle]pathForResource:@"MagicMissileEmitter" ofType:@"sks"];
		_magicEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterpath];
		
		
	}
	
	return self;
}

-(void)configurePhysics{
		//set up phyics body, called by DSGSprite's init
	self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
	self.physicsBody.categoryBitMask = DSGCollitionCategoryHero;
	self.physicsBody.contactTestBitMask = DSGCollitionCategoryEnemy;
	self.physicsBody.collisionBitMask = DSGCollitionCategoryWall;
	self.physicsBody.allowsRotation = NO;
		

		
}

-(void)fireAttackingAnimation{
		//check direction we're facing.
	switch (self.isFacing) {
		case DSGCharacterFacingRight:
			[self fireMagicMissileWithAnimationFrames:[self firingRightFrames]];
			break;
		case DSGCharacterFacingLeft:
			[self fireMagicMissileWithAnimationFrames:[self firingLeftFrames]];
			break;
		default:
			break;
	}
	
}

-(void)animationDidFinish:(DSGAnimationState)animationState{
		//once we're done killing just hang out.
	switch (animationState) {
		case DSGAnimationStateAttacking:
			if (!self.attackRequested) {
				self.requestedAnimation = DSGAnimationStateIdle;
			}
			break;
			
		default:
			break;
	}
}
-(void)fireMagicMissileWithAnimationFrames:(NSArray*)frames{
	
		//fast and small needs exact collision precision
	self.physicsBody.usesPreciseCollisionDetection = YES;
		//check we're not already doing it.
	SKAction *action = [self actionForKey:@"firing"];
	if (action) {
		return;
	}
	
		//build animation squence
	SKAction *animation = [SKAction runBlock:^{
		[self fireAnimation:frames forKey:@"firing" forState:DSGAnimationStateAttacking];
	}];
		//fire projectile half way through animation 0.4 seconds in.
	SKAction *pause = [SKAction waitForDuration:0.4];
	SKAction *fire = [SKAction runBlock:^{
		[self fireMagicMissile];//FIRE ZEE MISSILE!
	}];
	
		//build squence
	SKAction *fireSequence = [SKAction sequence:@[pause,fire]];
		//build group to run simaltaniously.
	SKAction *group = [SKAction group:@[animation, fireSequence]];
	
		//run them
	[self runAction:group withKey:@"missile"];
	self.physicsBody.usesPreciseCollisionDetection = NO;
}
-(void)fireMagicMissile{
		//retrieve scene
	DSGLevel *scene = (DSGLevel *)[self scene];
	
		//create magic missile
	SKSpriteNode *magicMissile = [SKSpriteNode spriteNodeWithTexture:[[self magicMissileRightFrames]firstObject]];
	
		//configure physics
	magicMissile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:magicMissile.frame.size];
	magicMissile.physicsBody.categoryBitMask = DSGCollitionCategoryProjectile;
	magicMissile.physicsBody.contactTestBitMask = DSGCollitionCategoryEnemy;
	magicMissile.physicsBody.collisionBitMask = 0;
	
		//configure emitter
	SKEmitterNode *emitter = [[self magicEmitter]copy];
		//set root node for partical referance
	emitter.targetNode = [self.scene childNodeWithName:@"world"];
		//add to missile
	[magicMissile addChild:emitter];
	
		//build animation
	SKAction *animation = [SKAction animateWithTextures:[self magicMissileRightFrames] timePerFrame:0.2 resize:YES restore:NO];
		//repeat it forever
	SKAction *repeater = [SKAction repeatActionForever:animation];
	
		//get position of character
	CGPoint p = self.position;
	
		//change firing direction and rotation depending on direction self is facing
	CGFloat x = 0;
	CGFloat y = 0;
	switch (self.isFacing) {
		case DSGCharacterFacingRight:
			x = kMagicMissileDistance;
			p.x += 20;
			
			break;
		case DSGCharacterFacingLeft:
			x = -kMagicMissileDistance;
			p.x -=20;
			magicMissile.zRotation = DEGREES_TO_RADIANS(180);
			break;
		case DSGCharacterFacingDown:
			y = -kMagicMissileDistance;
			break;
		case DSGCharacterFacingUp:
			y = kMagicMissileDistance;
			break;
			
		default:
			break;
	}
	
		//set position
	magicMissile.position = p;
		//run firing animation
	[magicMissile runAction:repeater];
		//add missile to world
	[scene addChildNode:magicMissile atWorldLayer:DSGCharacterLayer];
	
		//animate it moving across screen
	SKAction *movement = [SKAction moveByX:x y:y duration:1];
	SKAction *removal = [SKAction removeFromParent];
	[magicMissile runAction:[SKAction sequence:@[movement, removal]]];
	
}

+(void)loadAssets{
	[super loadAssets];
		//load assets only once
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
			//NSLog(@"Boo");
			//idle frames
		sIdleFrames = [[NSMutableArray alloc]initWithCapacity:kNIdelFrames];
		SKTextureAtlas *idle = [SKTextureAtlas atlasNamed:@"Wizard_Idle"];
		SKTexture *idleRight = [idle textureNamed:@"Idle_right"];
		SKTexture *idleUp = [idle textureNamed:@"Idle_up"];
		SKTexture *idleDown = [idle textureNamed:@"Idle_down"];
		SKTexture *idleLeft = [idle textureNamed:@"Idle_left"];
		[sIdleFrames insertObject:idleUp atIndex:DSGCharacterFacingUp];
		[sIdleFrames insertObject:idleRight atIndex:DSGCharacterFacingRight];
		[sIdleFrames insertObject:idleDown atIndex:DSGCharacterFacingDown];
		[sIdleFrames insertObject:idleLeft atIndex:DSGCharacterFacingLeft];
		
			//walking right frames
		sWalkingRightFrames = [[NSMutableArray alloc]initWithCapacity:kNWalkingRightFrames];
		SKTextureAtlas *wRight = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Right"];
		for (int i=1; i<kNWalkingRightFrames; i++) {
			SKTexture *frame = [wRight textureNamed:[NSString stringWithFormat:@"Walking_right_%d",i]];
			[sWalkingRightFrames addObject:frame];
		}
		
			//walking left frames
		sWalkingLeftFrames = [[NSMutableArray alloc]initWithCapacity:kNWalkingLeftFrames];
		SKTextureAtlas *wLeft = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Left"];
		for (int i=1; i<kNWalkingLeftFrames; i++) {
			SKTexture *frame = [wLeft textureNamed:[NSString stringWithFormat:@"Walking_left_%d",i]];
			[sWalkingLeftFrames addObject:frame];
		}
		
		
			//walking up frames
		sWalkingUpFrames = [[NSMutableArray alloc]initWithCapacity:kNWalkingUpFrames];
		SKTextureAtlas *wUp = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Up"];
		for (int i=1; i<kNWalkingUpFrames; i++) {
			SKTexture *frame = [wUp textureNamed:[NSString stringWithFormat:@"Walking_up_%d",i]];
			[sWalkingUpFrames addObject:frame];
		}
		
			//walking down frames
		sWalkingDownFrames = [[NSMutableArray alloc]initWithCapacity:kNWalkingDownFrames];
		SKTextureAtlas *wDown = [SKTextureAtlas atlasNamed:@"Wizard_Walking_Down"];
		for (int i=1; i<kNWalkingDownFrames; i++) {
			SKTexture *frame = [wDown textureNamed:[NSString stringWithFormat:@"Walking_down_%d",i]];
			[sWalkingDownFrames addObject:frame];
		}
		
			//firing right frames
			//NSLog(@"Boo");
		sFiringRightFrames = [[NSMutableArray alloc]initWithCapacity:kNFiringRightFrames];
		SKTextureAtlas *fRight = [SKTextureAtlas atlasNamed:@"Wizard_Firing_Right"];
		for (int i = 1; i<kNFiringRightFrames; i++) {
			SKTexture *frame = [fRight textureNamed:[NSString stringWithFormat:@"Firing_right_%d",i]];
			[sFiringRightFrames addObject:frame];
		}
		
			//firing left frames
		sFiringLeftFrames = [[NSMutableArray alloc]initWithCapacity:kNFiringLeftFrames];
		SKTextureAtlas *fLeft = [SKTextureAtlas atlasNamed:@"Wizard_Firing_Left"];
		for (int i = 1; i<kNFiringLeftFrames; i++) {
			SKTexture *frame = [fLeft textureNamed:[NSString stringWithFormat:@"Firing_left_%d",i]];
			[sFiringLeftFrames addObject:frame];
			NSLog(@"Loading firing left frame %d",i);
		}
			//Missile Frames
		sMagicMissileRightFrames = [[NSMutableArray alloc]initWithCapacity:kMagicMissileFrames];
		SKTextureAtlas *fMM = [SKTextureAtlas atlasNamed:@"Magic_Missile_Right"];
		for (int i=1; i<kMagicMissileFrames; i++) {
			SKTexture *frame = [fMM textureNamed:[NSString stringWithFormat:@"Magic_missile3_%d", i]];
			[sMagicMissileRightFrames addObject:frame];
		}
		
	});
	
}

static NSMutableArray *sIdleFrames;
-(NSArray *)idleFrames{
	return sIdleFrames;
}
static NSMutableArray *sWalkingRightFrames;
-(NSArray *)walkingRightFrames{
	return sWalkingRightFrames;
}
static NSMutableArray *sWalkingLeftFrames;
-(NSArray *)walkingLeftFrames{
	return sWalkingLeftFrames;
}
static NSMutableArray *sWalkingUpFrames;
-(NSArray *)walkingUpFrames{
	return sWalkingUpFrames;
}
static NSMutableArray *sWalkingDownFrames;
-(NSArray *)walkingDownFrames{
	return sWalkingDownFrames;
}

static NSMutableArray *sFiringRightFrames;
-(NSArray *)firingRightFrames{
	return sFiringRightFrames;
}
static NSMutableArray *sFiringLeftFrames;
-(NSArray *)firingLeftFrames{
	return sFiringLeftFrames;
}
static NSMutableArray *sFiringUpFrames;
static NSMutableArray *sFiringDownFrames;

static NSMutableArray *sMagicMissileRightFrames;
-(NSArray *)magicMissileRightFrames{
	return sMagicMissileRightFrames;
}
@end
