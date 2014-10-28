//
//  AnimateLayerView.m
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import "AnimateLayerView.h"

@interface AnimateLayerView()

@property (nonatomic) CADisplayLink * displayLink;
@property () NSTimeInterval duration;
@property () NSTimeInterval currentTime;
@property () NSTimeInterval prevTime;
@property () NSTimeInterval startTime;
@property (nonatomic, strong) void (^completion)();

@property (nonatomic) CAShapeLayer * shapeLayer;

@end

@implementation AnimateLayerView

- (void)animateWithDuration:(NSTimeInterval)duration WithCompletionBlock:(void(^)())completion {
    _completion = completion;
    _duration = duration;
    _startTime = CACurrentMediaTime();
    _prevTime = CACurrentMediaTime();
    _currentTime = 0;
    
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    CGFloat width = self.frame.size.width * 0.75f;
    CGFloat position = (self.frame.size.width - width) / 2;
    //// Variable Declarations
    UIColor* origColor = [UIColor colorWithRed:0 green:1 blue: 0 alpha: 1];
    UIColor* newColor = [UIColor colorWithRed:1 green:0 blue: 0 alpha: 1];
    CGFloat origRadius = 0;
    CGFloat newRadius = width / 2;
    
    CATransform3D origTransform = CATransform3DIdentity;
    CATransform3D newTransform = CATransform3DConcat(CATransform3DConcat(CATransform3DMakeTranslation(-self.frame.size.width / 2, -self.frame.size.width / 2, 0), CATransform3DMakeRotation(M_PI, 0, 0, 1)), CATransform3DMakeTranslation(self.frame.size.width / 2, self.frame.size.width / 2, 0));
    
    width = self.frame.size.width * 0.75;
    
    [CATransaction begin]; {
        CGPathRef origPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(position, position, width, width) cornerRadius: origRadius].CGPath;
        CGPathRef newPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(position, position, width, width) cornerRadius: newRadius].CGPath;
        CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
        morph.duration = duration;
        morph.fromValue = (__bridge id)origPath;
        morph.toValue = (__bridge id)newPath;
        [_shapeLayer addAnimation:morph forKey:@"path"];
        
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        colorAnimation.duration = duration;
        colorAnimation.fromValue = (__bridge id)origColor.CGColor;
        colorAnimation.toValue = (__bridge id)newColor.CGColor;
        [_shapeLayer addAnimation:colorAnimation forKey:@"fillColor"];
        
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.duration = duration;
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:origTransform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:newTransform];
        [_shapeLayer addAnimation:transformAnimation forKey:@"transform"];
    }
    [CATransaction commit];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        
        CGFloat width = frame.size.width * 0.75;
        CGFloat position = (frame.size.width - width) / 2;
        //// Variable Declarations
        UIColor* color = [UIColor colorWithRed:0 green:1 blue: 0 alpha: 1];
        CGFloat radius = 0;
        
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(position, position, width, width) cornerRadius: radius];
        _shapeLayer.path = rectanglePath.CGPath;
        _shapeLayer.fillColor = color.CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    _prevTime = _currentTime;
    _currentTime = CACurrentMediaTime() - _startTime;
    float timeline = 0;
    if (_duration > 0) {
        timeline = _currentTime / _duration;
    }
    //    [self drawCanvas1WithTimeline:timeline width:self.frame.size.width * 0.75f];
    NSTimeInterval frameDuration = _currentTime - _prevTime;
    [[NSString stringWithFormat:@"%.2f", frameDuration != 0 ? 1.0/frameDuration : 0] drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier New" size:9], NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)updateDisplayLink:(CADisplayLink *)sender
{
    if (CACurrentMediaTime() - _startTime >= _duration) {
        [_displayLink invalidate];
        _displayLink = nil;
        if (_completion != nil) {
            _completion();
        }
    } else {
        [self setNeedsDisplay];
    }
}

@end
