//
//  DSGCharacter.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DSGSprite.h"
#import "DSGControllable.h"
#define defaultSpeed 200
#define animationSpeed 10
#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180
#define RADIANS_TO_DEGREES(radians) radians * 180 / M_PI



typedef enum : uint8_t{
	DSGCharacterFacingUp = 0,
	DSGCharacterFacingRight,
	DSGCharacterFacingDown,
	DSGCharacterFacingLeft
} DSGCharacterFacingDirection;

typedef enum : uint8_t{
	DSGAnimationStateIdle=0,
	DSGAnimationStateWalking,
	DSGAnimationStateStartAttack,
	DSGAnimationStateAttacking,
	DSGAnimationStateEndAttack,
	DSGAnimationStateDieing
}DSGAnimationState;

@interface DSGCharacter : DSGSprite <DSGControllable>

@property (nonatomic)NSString *name;
@property (nonatomic)NSInteger health;
@property (nonatomic)NSInteger mana;
@property (nonatomic)UITouch *targetTouch;
@property (nonatomic, getter = isFacing)DSGCharacterFacingDirection facing;
@property (nonatomic)DSGAnimationState requestedAnimation;
@property (nonatomic)CGPoint targetLocation;
@property (nonatomic)CGPoint targetDirection;
@property (nonatomic, setter = requestMovement:)BOOL movementRequested;
@property (nonatomic, setter = requestAttack:)BOOL attackRequested;
@property (nonatomic)NSInteger attackingQueue;
@property (nonatomic)BOOL isAnimated;
@property (nonatomic)dispatch_queue_t dispatchAttackingQueue;
	//@property (nonatomic)CGRect collisionBox;


-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;
-(void)turnToFacePosition:(CGPoint)position;
-(void)moveTowardsTargetLocationForTimeIntervale:(NSTimeInterval)timeInterval;
-(void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
-(void)updateForTimeIntervale:(NSTimeInterval)time;

-(void)startAttackingAnimation;
-(void)processAttackingQueue;
-(void)endAttackingAnimation;
-(void)fireAnimation:(NSArray *)frames forKey:(NSString *)key forState:(DSGAnimationState)state;
-(void)animationDidFinish:(DSGAnimationState)animationState;


+(void)loadAssets;

-(NSArray *)idleFrames;
-(NSArray *)walkingRightFrames;
-(NSArray *)walkingLeftFrames;
-(NSArray *)walkingUpFrames;
-(NSArray *)walkingDownFrames;

@end
