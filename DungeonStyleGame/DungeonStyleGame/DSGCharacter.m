//
//  DSGCharacter.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGCharacter.h"



@interface DSGCharacter()
@property (nonatomic)double movementSpeed;
@end

@implementation DSGCharacter

-(id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position{
	self = [super initWithTexture:texture atPosition:position];
	if(self){
		self.position = position;
		_movementSpeed = defaultSpeed;
		_attackingQueue = 0;
		_dispatchAttackingQueue = dispatch_queue_create("com.dungeon.attack", NULL);
	}
	return self;
}
#pragma mark - Character update loop
-(void)updateForTimeIntervale:(NSTimeInterval)time{
		//NSLog(@"Update hero");
	if (_isAnimated) {
			//if isAnimation animate god damn it!
		
			[self processAnimationRequest];
		
		
	}
	
}

#pragma mark - Animation process

-(void)processAnimationRequest{
		//check animation which needs to be run
	switch (_requestedAnimation) {
		case DSGAnimationStateWalking:
			NSLog(@"Running walking animation");
			[self fireWalkAnimation];
			break;
		case DSGAnimationStateIdle:
				//NSLog(@"Running idle");
			[self idle];
			break;
		case DSGAnimationStateStartAttack:
			[self startAttackingAnimation];
			break;
		case DSGAnimationStateAttacking:
				[self processAttackingQueue];
			break;
		case DSGAnimationStateEndAttack:
			[self endAttackingAnimation];
			break;
		default:
			break;
	}
		
}

-(void)fireWalkAnimation{
		//check direction to walk
	switch (_facing) {
		case DSGCharacterFacingRight:
			[self fireAnimation:[self walkingRightFrames] forKey:@"walk_right" forState:(DSGAnimationState)DSGAnimationStateWalking];
			break;
		case DSGCharacterFacingLeft:
			[self fireAnimation:[self walkingLeftFrames] forKey:@"walk_left" forState:(DSGAnimationState)DSGAnimationStateWalking];
			break;
		case DSGCharacterFacingUp:
			[self fireAnimation:[self walkingUpFrames] forKey:@"walking_up" forState:(DSGAnimationState)DSGAnimationStateWalking];
			break;
		case DSGCharacterFacingDown:
			[self fireAnimation:[self walkingDownFrames] forKey:@"walk_down" forState:(DSGAnimationState)DSGAnimationStateWalking];
			break;
		default:
			[self fireAnimation:[self walkingRightFrames] forKey:@"walk_right" forState:(DSGAnimationState)DSGAnimationStateWalking];
	}
}

-(void)fireAttackingAnimation{
		//Overridden
}
-(void)startAttackingAnimation{
		//Overridden
}
-(void)processAttackingQueue{
		//Overridden
}
-(void)endAttackingAnimation{
		//Overridden
}
-(void)fireAnimation:(NSArray *)frames forKey:(NSString *)key forState:(DSGAnimationState)state{
		//check if action is already being run
	SKAction *action = [self actionForKey:key];
	if (action) {
		return;
	}
		//build animation SKAction
	SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:1.0/animationSpeed resize:YES restore:NO];
	SKAction *completion = [SKAction runBlock:^{
			//let people know it's finished
			[self animationHasFinished:(DSGAnimationState)state];
		
	}];
		//build animation sqence and run it.
	SKAction *squence = [SKAction sequence:@[animation, completion]];
	[self runAction:squence withKey:key];
}
-(void)idle{
		//this is what we do when we idle
	SKTexture *n =[[self idleFrames]objectAtIndex:_facing];//facing corresponds to the index of the needed idle frame
	NSMutableArray *frames = [[NSMutableArray alloc]init];
		//for some reason sprite jitters to walking animation sometimes dispite restore being set to NO
	for(int i=0; i<4; i++){
		[frames addObject:n];
	}
	[self fireAnimation:frames forKey:[NSString stringWithFormat:@"Idelframe_%d",_facing]forState:(DSGAnimationState)DSGAnimationStateIdle];
}

-(void)animationHasFinished:(DSGAnimationState)animationState{
		//NSLog(@"animation has finished");
	[self animationDidFinish:(DSGAnimationState)animationState];
}

-(void)animationDidFinish:(DSGAnimationState)animationState{
		//overridden
}

#pragma mark - Location Processing
-(void)turnToFacePosition:(CGPoint)position{
	CGFloat rad = [self calculateAngleBetweenPoint:position andPoint:self.position];
	[self turnToFaceRadion:rad];
}
-(void)turnToFaceRadion:(CGFloat)radions{
	double degrees = RADIANS_TO_DEGREES(radions);
		//set direction to face
	if (degrees <= 45 && degrees > -45) {
		NSLog(@"Facing Up");
		_facing = DSGCharacterFacingUp;
	}else if (degrees <=135 && degrees > 45 ){
		_facing = DSGCharacterFacingRight;
	}else if (degrees <= -45 && degrees > -135){
		_facing = DSGCharacterFacingLeft;
	}else if (degrees <= -135 || degrees >135 ){
		NSLog(@"Facing Down");
		_facing = DSGCharacterFacingDown;
	}
	NSLog(@"Facing %d, degrees %f", _facing, degrees);
}
	//helper function
-(CGFloat)calculateAngleBetweenPoint:(CGPoint)first andPoint:(CGPoint)second{
	CGFloat deltaX = first.x - second.x;
	CGFloat deltaY = first.y - second.y;
	CGFloat ang = atan2f(deltaX, deltaY);
	return ang;
}

-(void)moveTowardsTargetLocationForTimeIntervale:(NSTimeInterval)timeInterval{
	CGPoint currentLocation = self.position;
		//THis is triganomitry... i know that much
	CGFloat deltaX = self.targetLocation.x - currentLocation.x;
	CGFloat deltaY = self.targetLocation.y - currentLocation.y;
	CGFloat deltaT = self.movementSpeed * timeInterval;
	
	CGFloat ang = atan2f(deltaX, deltaY);
	CGFloat newX = currentLocation.x + sinf(ang)*deltaT;
	CGFloat newY = currentLocation.y + cosf(ang)*deltaT;
	
	double distanceRemaining = hypotf(deltaX, deltaY);
		
	if(distanceRemaining < deltaT){
		self.position = self.targetLocation;
	}else{
		self.position = CGPointMake(newX, newY);
		
	}
		//request walking animation
	self.requestedAnimation = DSGAnimationStateWalking;
}

-(void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval{
		//Used for iphone joystick
	CGPoint currentLocation = self.position;
	CGFloat deltaX = self.movementSpeed * direction.x;
	CGFloat deltaY = self.movementSpeed * direction.y;
	CGFloat deltaT = self.movementSpeed * timeInterval;
	
	CGPoint targetPosition = CGPointMake(currentLocation.x - deltaX, currentLocation.y - deltaY);
	CGFloat ang = atan2f(deltaX, deltaY);
	CGFloat distanceRemaining = hypotf(deltaX, deltaY);
	[self turnToFaceRadion:ang];
	if (distanceRemaining < deltaT) {
		self.position = targetPosition;
	}else{
		self.position = CGPointMake(currentLocation.x + sinf(ang)*deltaT, currentLocation.y + cosf(ang)*deltaT);
	}
		//reqest walking animation
	self.requestedAnimation = DSGAnimationStateWalking;
}

-(void)setTargetLocation:(CGPoint)targetLocation{
	[self turnToFacePosition:targetLocation];
	_targetLocation = targetLocation;
	NSLog(@"Setting target location");
	
}

-(void)requestMovement:(BOOL)movementRequested{
	_movementRequested = movementRequested;
}

-(void)requestAttack:(BOOL)attackRequested{
	_attackRequested = attackRequested;
}

-(DSGCharacterFacingDirection)isFacing{

	return _facing;
}

+(void)loadAssets{
		//overridden
}
-(NSArray *)idleFrames{
	return nil;
}
-(NSArray *)walkingUpFrames{
	return nil;
}
-(NSArray *)walkingDownFrames{
	return nil;
}
-(NSArray *)walkingRightFrames{
	return nil;
}
-(NSArray *)walkingLeftFrames{
	return nil;
}
@end
