//
//  DSGCharacter.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#define defaultSpeed 200
#define animationSpeed 10

typedef enum : uint8_t{
	DSGCharacterFacingUp = 0,
	DSGCharacterFacingRight,
	DSGCharacterFacingDown,
	DSGCharacterFacingLeft
} DSGCharacterFacingDirection;

typedef enum : uint8_t{
	DSGAnimationStateIdle=0,
	DSGAnimationStateWalking,
	DSGAnimationStateAttacking,
	DSGAnimationStateDieing
}DSGAnimationState;

@interface DSGCharacter : SKSpriteNode

@property (nonatomic)NSString *name;
@property (nonatomic)NSInteger health;
@property (nonatomic)NSInteger mana;
@property (nonatomic)UITouch *targetTouch;
@property (nonatomic, getter = isFacing)DSGCharacterFacingDirection facing;
@property (nonatomic)DSGAnimationState requestedAnimation;
@property (nonatomic)CGPoint targetLocation;
@property (nonatomic, setter = requestMovement:)BOOL movementRequested;
@property (nonatomic, setter = requestAttack:)BOOL attackRequested;
@property (nonatomic)BOOL isAnimated;


-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;
-(void)turnToFacePosition:(CGPoint)position;
-(void)moveTowardsTargetLocationForTimeIntervale:(NSTimeInterval)timeInterval;
-(void)updateForTimeIntervale:(NSTimeInterval)time;

-(void)fireAttackingAnimation;
-(void)fireAnimation:(NSArray *)frames forKey:(NSString *)key forState:(DSGAnimationState)state;
-(void)animationDidFinish:(DSGAnimationState)animationState;

+(void)loadAssets;

-(NSArray *)idleFrames;
-(NSArray *)walkingRightFrames;
-(NSArray *)walkingLeftFrames;
-(NSArray *)walkingUpFrames;
-(NSArray *)walkingDownFrames;

@end
