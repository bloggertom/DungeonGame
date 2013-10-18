//
//  DSGMyScene.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//


#import "DSGLevel.h"
#import "DSGHero.h"
	//#import "GameCon"
@interface DSGLevel()
@property (nonatomic) NSMutableArray *layers;
@property (nonatomic)SKNode *world;
@property (nonatomic)NSTimeInterval lastTimeUpdate;
@property (nonatomic)SKNode *dbugOverlay;
@end

@implementation DSGLevel

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
			//create a world
		_world = [[SKNode alloc]init];
		[_world setName:@"world"];
		
			//create lighting effect
		SKEffectNode *blur = [[SKEffectNode alloc]init];
		CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
		[filter setDefaults];
		[filter setValue:[NSNumber numberWithFloat:30.0] forKey:@"inputRadius"];
		blur.filter = filter;
		
		
			//create node to hold shadow
		SKShapeNode *shadow = [[SKShapeNode alloc]init];
		CGRect frame = CGRectInset(self.frame, -50, -50);
			//create shape paths
		UIBezierPath *blurpath = [UIBezierPath bezierPathWithRect:frame];
		blurpath.usesEvenOddFillRule = YES;
		UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:frame];
			//remove inner circle
		[blurpath appendPath:circle];
		shadow.path = blurpath.CGPath;
		shadow.strokeColor = [UIColor blackColor];
		shadow.fillColor = [UIColor blackColor];
		shadow.lineWidth = 1;
		shadow.alpha = 0.7;
		
		
			//add a border
		UIBezierPath *solidPath = [UIBezierPath bezierPathWithRect:self.frame];
		SKShapeNode *border = [[SKShapeNode alloc]init];
		border.path = solidPath.CGPath;
		border.strokeColor = [UIColor blackColor];
		border.lineWidth = 1;
		border.alpha = 0.7;
		border.glowWidth = 5;
		
			
		
			//effects.
		[blur addChild:shadow];
		[self addChild:blur];
		[self addChild:border];
		
		blur.shouldEnableEffects =YES;
		blur.shouldRasterize = YES;
			//give it layers
		_layers = [[NSMutableArray alloc]init];
		for(int i=0; i< kWorldLayerCount; i++){
			SKNode *layer = [[SKNode alloc]init];
			layer.zPosition = i - kWorldLayerCount;
			NSLog(@"adding layer at z index %d", kWorldLayerCount-i);
			[_world addChild:layer];
			[_layers addObject:layer];
		}
			//get ready for mosters
		_monsters = [[NSMutableArray alloc]init];
			//show the world
		[self addChild:_world];
#if DEBUG_COLLISIONS
		_dbugOverlay = [SKNode node];
		[self addChildNode:_dbugOverlay atWorldLayer:DSGDebugLayer];
#endif
    }
    return self;
}


#pragma mark - Animation Cycle
-(void)update:(NSTimeInterval)currentTime{
#if DEBUG_COLLISIONS
	[self.dbugOverlay removeFromParent];
	[self.dbugOverlay removeAllChildren];
#endif
	
		//work out time since last update
	NSTimeInterval timeSinceLast = currentTime - self.lastTimeUpdate;
	self.lastTimeUpdate = currentTime;
		//let everyone know about it
	[self updateForTimeIntervale:timeSinceLast];
		//if it's an iPad begin use
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			//check for movement
		if(self.hero.movementRequested){
				//if movement requested tell hero to update
			[self.hero moveTowardsTargetLocationForTimeIntervale:timeSinceLast];
				//if the hero is now in it's target location
			if (CGPointEqualToPoint(self.hero.position, self.hero.targetLocation)){
					//no more movement is needed
				self.hero.movementRequested = NO;
				self.hero.requestedAnimation = DSGAnimationStateIdle;
			}
		
		}
			//must be using the iPhone controller
	}else{
			//if movement requested
		if (self.hero.movementRequested) {
				//get the target direction
			CGPoint direction = self.hero.targetDirection;
				//check it's not nothing first
			if(!CGPointEqualToPoint(direction, CGPointZero)){
					//then move the character.
				[self.hero moveInDirection:direction withTimeInterval:timeSinceLast];
					//ask him to animate walking
				self.hero.requestedAnimation = DSGAnimationStateWalking;
			}else if(!self.hero.attackRequested){
					//check if attacking
				self.hero.movementRequested = NO;
				self.hero.requestedAnimation = DSGAnimationStateIdle;
			}
		}
	}
		//if player want to attack
	if (self.hero.attackRequested) {
			//reset boolean
		self.hero.attackRequested = NO;
			//animate attacking.
		self.hero.requestedAnimation = DSGAnimationStateAttacking;
	}

}


-(void)updateForTimeIntervale:(NSTimeInterval)time{
		//overridden
	

}

-(void)didEvaluateActions{
		//NSLog(@"after actions \ntarget x=%f y=%f, position x=%f y=%f", self.hero.targetLocation.x,self.hero.targetLocation.y, self.hero.position.x, self.hero.position.y);
}
-(void)didSimulatePhysics{
	//NSLog(@"after physics \ntarget x=%f y=%f, position x=%f y=%f", self.hero.targetLocation.x,self.hero.targetLocation.y, self.hero.position.x, self.hero.position.y);
#if DEBUG_COLLISIONS
	
	SKShapeNode *heroBox = [[SKShapeNode alloc]init];
	heroBox.path = CGPathCreateWithRect(_hero.frame, NULL);
	[_dbugOverlay addChild:heroBox];
	
	
	for (SKNode *node in _monsters) {
		SKShapeNode *monsterBox = [[SKShapeNode alloc]init];
		monsterBox.path = CGPathCreateWithRect(node.frame, NULL);
		[_dbugOverlay addChild:monsterBox];
	}
	
	
	
	[self addChildNode:_dbugOverlay atWorldLayer:DSGDebugLayer];
#endif
	
	
	
	if (self.hero) {
		CGPoint pos = self.world.position;
		CGPoint heroPos = self.hero.position;
		
		if (heroPos.x > CGRectGetMidX(self.frame) && heroPos.x < (kMazeSize - CGRectGetMidX(self.frame))) {
			pos.x = (-(self.hero.position.x)+CGRectGetMidX(self.frame));
		}
		if (heroPos.y > CGRectGetMidY(self.frame) && heroPos.y < (kMazeSize - CGRectGetMidY(self.frame))){
			pos.y = (-(self.hero.position.y)+CGRectGetMidY(self.frame));
		}
		self.world.position = pos;
	}
	
}
#pragma mark - Controls
#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		//NSLog(@"Touch Detected");
    
	if([touches count] == 1 && ![self.hero targetTouch]){
			//set heros target location to location of touch.
		UITouch *touch = [touches anyObject];
		CGPoint position = [touch locationInNode:self.world];
		[self.hero setTargetLocation:position];
		NSLog(@"Target X %f, Target Y %f", position.x, position.y);
		[self.hero setTargetTouch:touch];//needed if player drags finger
		[self.hero requestMovement:YES];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches containsObject:self.hero.targetTouch]){
			//no more touching
		self.hero.targetTouch = nil;
	}
}

-(void)requestAttack{
	[self.hero requestAttack:YES];
}


/*
 * Adding Node
 */
#pragma mark - Adding Nodes

-(void)addChildNode:(SKNode*)node atWorldLayer:(DSGWorldLayer)layer{
		//add child node to specific layer.
	SKNode *layerNode = [_layers objectAtIndex:layer];
	[layerNode addChild:node];
}
/*
 * Static methods
 */
#pragma mark - Static Methods
#pragma mark - Load Assests
+(void)loadAssetsWithHandler:(DSGLoadAssesCompleteHandler)callback{
		//dispatched in background
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , ^{
				//load game assests
			[self loadAssets];
			if(!callback){
					//just return if no callback
				return;
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
					//run call back on main queue
				callback();
			});
		});

}

+(void)loadAssets{
		//overridden
}

-(UIImage*)levelDataMap{
	return nil;//overriddin
}
@end
