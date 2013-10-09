//
//  DSGMyScene.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGLevel.h"
#import "DSGHero.h"
#import "GameCon"
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
        
		_world = [[SKNode alloc]init];
		[_world setName:@"world"];
		
		_layers = [[NSMutableArray alloc]init];
		for(int i=0; i< kWorldLayerCount; i++){
			SKNode *layer = [[SKNode alloc]init];
			layer.zPosition = i - kWorldLayerCount;
			NSLog(@"adding layer at z index %d", kWorldLayerCount-i);
			[_world addChild:layer];
			[_layers addObject:layer];
		}
		_monsters = [[NSMutableArray alloc]init];

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
	

	NSTimeInterval timeSinceLast = currentTime - self.lastTimeUpdate;
	self.lastTimeUpdate = currentTime;
	[self updateForTimeIntervale:timeSinceLast];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if(self.hero.movementRequested){
			[self.hero moveTowardsTargetLocationForTimeIntervale:timeSinceLast];//Moved to here as	physics simulartion moves hero slightly FOR NO REASON!.
			if (CGPointEqualToPoint(self.hero.position, self.hero.targetLocation)){
				self.hero.movementRequested = NO;
				self.hero.requestedAnimation = DSGAnimationStateIdle;
			}
		
		}
	}else{
		if (self.hero.movementRequested) {
			CGPoint direction = self.hero.targetDirection;
			if(!CGPointEqualToPoint(direction, CGPointZero)){
				NSLog(@"MOVE");
				[self.hero moveInDirection:direction withTimeInterval:timeSinceLast];
				self.hero.requestedAnimation = DSGAnimationStateWalking;
			}else if(!self.hero.attackRequested){
				self.hero.movementRequested = NO;
				self.hero.requestedAnimation = DSGAnimationStateIdle;
			}
		}
	}
	if (self.hero.attackRequested) {
		self.hero.attackRequested = NO;
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
}
#pragma mark - Controls
#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		//NSLog(@"Touch Detected");
    
	if([touches count] == 1 && ![self.hero targetTouch]){
		UITouch *touch = [touches anyObject];
		CGPoint position = [touch locationInNode:self];
		[self.hero setTargetLocation:position];
		NSLog(@"Target X %f, Target Y %f", position.x, position.y);
		[self.hero setTargetTouch:touch];
		[self.hero requestMovement:YES];
		
		
		/*
		SKNode *nodeAtTouch = [self nodeAtPoint:position];
		
		if([nodeAtTouch isKindOfClass:DSGEnemy]){
				//attack
		}
		 */
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches containsObject:self.hero.targetTouch]){
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
	SKNode *layerNode = [_layers objectAtIndex:layer];
	[layerNode addChild:node];
}
/*
 * Static methods
 */
#pragma mark - Static Methods
#pragma mark - Load Assests
+(void)loadAssetsWithHandler:(DSGLoadAssesCompleteHandler)callback{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) , ^{
				//load game assests
			
			[self loadAssets];
			
			if(!callback){
				return;
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
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
