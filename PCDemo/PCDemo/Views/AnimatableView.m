//
//  AnimatableView.m
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import "AnimatableView.h"

@interface AnimatableView ()

@property (nonatomic) CADisplayLink * displayLink;
@property () NSTimeInterval duration;
@property () NSTimeInterval currentTime;
@property () NSTimeInterval prevTime;
@property () NSTimeInterval startTime;
@property (nonatomic, strong) void (^completion)();

@end

@implementation AnimatableView

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
}


- (void)drawRect:(CGRect)rect {
    _prevTime = _currentTime;
    _currentTime = CACurrentMediaTime() - _startTime;
    float timeline = 0;
    if (_duration > 0) {
        timeline = _currentTime / _duration;
    }
    [self drawCanvas1WithTimeline:timeline width:self.frame.size.width * 0.75f];
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

//// PaintCode Trial Version
//// www.paintcodeapp.com

- (void)drawCanvas1WithTimeline: (CGFloat)timeline width: (CGFloat)width
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Variable Declarations
    CGFloat rotation = timeline * 360;
    UIColor* color = [UIColor colorWithRed: timeline green: 1 - timeline blue: 0 alpha: 1];
    CGFloat radius = width * timeline / 2.0;
    CGFloat position = width / 2.0;
    
    //// Rectangle Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, position / 0.75f, position / 0.75f);
    CGContextRotateCTM(context, -rotation * M_PI / 180);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(-width/2, -width/2, width, width) cornerRadius: radius];
    [color setFill];
    [rectanglePath fill];
    
    CGContextRestoreGState(context);
}

@end
