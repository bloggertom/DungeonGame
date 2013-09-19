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
	self = [super initWithTexture:texture];
	if(self){
		self.position = position;
		_movementSpeed = defaultSpeed;
		
	}
	return self;
}
#pragma mark - Character update loop
-(void)updateForTimeIntervale:(NSTimeInterval)time{
		//NSLog(@"Update hero");
	if (_isAnimated) {
		[self processAnimationRequest];
	}
	
}

#pragma mark - Animation process

-(void)processAnimationRequest{
	
	switch (_requestedAnimation) {
		case DSGAnimationStateWalking:
			[self fireWalkAnimation];
			break;
		case DSGAnimationStateIdle:
			NSLog(@"Running idle");
			[self idle];
			break;
		default:
			break;
	}
		
}

-(void)fireWalkAnimation{
	switch (_facing) {
		case DSGCharacterFacingRight:
			[self fireAnimation:[self walkingRightFrames] forKey:@"walk_right"];
			break;
		case DSGCharacterFacingLeft:
			[self fireAnimation:[self walkingLeftFrames] forKey:@"walk_left"];
			break;
		default:
			[self fireAnimation:[self walkingRightFrames] forKey:@"walk_right"];
	}
}

-(void)fireAnimation:(NSArray *)frames forKey:(NSString *)key{
	SKAction *action = [self actionForKey:key];
	if (action) {
		return;
	}
	
	SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:1.0/animationSpeed];
	/*SKAction *completion = [SKAction runBlock:^{
		if(!self.movementRequested){
			[self idle];
		}
	}];
	SKAction *squence = [SKAction sequence:@[animation, completion]];*/
	[self runAction:animation withKey:key];
}

-(void)idle{
	
	SKTexture *n =[[self idleFrames]objectAtIndex:self.isFacing];
	NSArray *frames = [NSArray arrayWithObject:n];
		//NSLog(@"Firing idel");
	[self fireAnimation:frames forKey:[NSString stringWithFormat:@"Idelframe_%d",self.facing]];
}


#pragma mark - Location Processing
-(void)turnToFacePosition:(CGPoint)position{
	CGFloat rad = [self calculateAngleBetweenPoint:position andPoint:self.position];
	double degrees = rad * 180 /M_PI;
	
	if (degrees <= 45 && degrees > -45) {
		_facing = DSGCharacterFacingUp;
	}else if (degrees <=135 && degrees > 45 ){
		_facing = DSGCharacterFacingRight;
	}else if (degrees <= -135 && degrees >135 ){
		_facing = DSGCharacterFacingDown;
	}else if (degrees <= -45 && degrees > -135){
		_facing = DSGCharacterFacingLeft;
	}
	NSLog(@"%d", _facing);
}

-(CGFloat)calculateAngleBetweenPoint:(CGPoint)first andPoint:(CGPoint)second{
	CGFloat deltaX = first.x - second.x;
	CGFloat deltaY = first.y - second.y;
	
	
	CGFloat ang = atan2f(deltaX, deltaY);
	return ang;
}

-(void)moveTowardsTargetLocationForTimeIntervale:(NSTimeInterval)timeInterval{
	CGPoint currentLocation = self.position;
	CGFloat deltaX = self.targetLocation.x - currentLocation.x;
	CGFloat deltaY = self.targetLocation.y - currentLocation.y;
	CGFloat deltaT = self.movementSpeed * timeInterval;
	
	CGFloat ang = atan2f(deltaX, deltaY);
	
		//	NSLog(@"ang %f", ang);
		//	NSLog(@"sin-ang %f, cosf-ang %f", sinf(ang), cosf(ang));
		//	NSLog(@"deltaT %f", deltaT);
	CGFloat newX = currentLocation.x + sinf(ang)*deltaT;
	CGFloat newY = currentLocation.y + cosf(ang)*deltaT;
	
	NSLog(@"newX %f, newY %f", newX, newY);
	double distanceRemaining = hypotf(deltaX, deltaY);
	if(distanceRemaining < deltaT){
		self.position = self.targetLocation;
	}else{
		self.position = CGPointMake(newX, newY);
		
	}
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
