//
//  DSGJoyPadView.m
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGJoyPadView.h"
#import "DSGGamePadViewController.h"
@interface DSGJoyPadView ()
@property (nonatomic)CGPoint originPosition;
@property (nonatomic, strong)UITouch *currentTouch;
@property (nonatomic)CGPoint currentPosition;

@end

@implementation DSGJoyPadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self sharedInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if(self){
		[self sharedInit];
		
		
	}
	return self;
}
-(void)sharedInit{
		//set up subviews
	_stickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
	_stickView.alpha = 0;
	
	_actionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 200, 80)];
	_actionButton.backgroundColor = [UIColor redColor];
		//_actionButton.titleLabel.text = @"Action";
	[_actionButton setTitle:@"Action" forState:UIControlStateNormal];
	[_actionButton addTarget:_delegate action:@selector(actionButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_stickView];
	[self addSubview:_actionButton];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
		//handle touch events
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:self];
	if ([_stickView pointInside:location withEvent:event]) {
			//move joy stick to touch location
		_originPosition = location;
		_currentPosition = location;
		_currentTouch = touch;
		[self setNeedsDisplay];
	}
	
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	for (UITouch *touch in touches) {
		if (touch == _currentTouch) {
			
				//find out which direction the touch moved in.
			_currentPosition = [touch locationInView:self];
			CGPoint direction;
			CGFloat x = _currentPosition.x - _originPosition.x;
			CGFloat y = _originPosition.y - _currentPosition.y;
			
			CGFloat length = hypotf(x, y);
			if (length > 0.0) {
				CGFloat invLength = 1.0/length;
				direction = CGPointMake(x*invLength, y*invLength);
			}else{
				direction = CGPointZero;
			}
				//tell the delegate (view controller)
			[_delegate joypadMovedInDirection:direction];
			[self setNeedsDisplay];
		}
	}
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
		//hand touch ending
	
		//reset perameters
	if([touches containsObject:_currentTouch]){
		_currentTouch = nil;
		_currentPosition = _stickView.center;
		[_delegate joypadMovedInDirection:CGPointZero];
		[self setNeedsDisplay];
	}
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
		//check for a current touch
	if (_currentTouch) {
			//if so draw the thumb stick
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(context, 255, 255, 255, 1);
		CGContextFillRect(context, CGRectMake(_currentPosition.x-THUMB_STICK_RADIUS, _currentPosition.y-THUMB_STICK_RADIUS, THUMB_STICK_RADIUS*2, THUMB_STICK_RADIUS*2));
	}
	
}


@end
