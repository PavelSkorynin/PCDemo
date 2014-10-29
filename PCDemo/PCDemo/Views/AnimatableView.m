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

@property (nonatomic, weak) id animationTarget;
@property (nonatomic, assign) SEL animationSelector;
@property () CGFloat animationValueFrom;
@property () CGFloat animationValueTo;
@property () NSTimeInterval animationDuration;
@property () MTTimingFunction animationTimingFunction;
@property (nonatomic, strong) void (^animationCompletionBlock)();

@property () NSTimeInterval animationStartTime;

@end

@implementation AnimatableView

- (void)animateWithTarget:(id)target
             drawSelector:(SEL)drawSelector
                fromValue:(CGFloat)fromValue
                  toValue:(CGFloat)toValue
                 duration:(NSTimeInterval)duration
           timingFunction:(MTTimingFunction)timingFunction
               completion:(void (^)())completion
{
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _displayLink = nil;
    }

    _animationTarget = target;
    _animationSelector = drawSelector;
    _animationValueFrom = fromValue;
    _animationValueTo = toValue;
    _animationDuration = duration;
    _animationTimingFunction = timingFunction;
    _animationCompletionBlock = completion;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _animationStartTime = CACurrentMediaTime();
    _inAnimation = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_inAnimation) {
        NSTimeInterval currentTime = CACurrentMediaTime() - _animationStartTime;
        CGFloat timeline = 0;
        if (_animationDuration > 0) {
            timeline = currentTime / _animationDuration;
            if (timeline >= 1) {
                _inAnimation = NO;
                if (_animationCompletionBlock != nil) {
                    _animationCompletionBlock();
                }
            }
        }
        if (_animationTimingFunction != NULL) {
            timeline = _animationTimingFunction(timeline * _animationDuration, 0, 1, _animationDuration, 1.70158f);
        }
        timeline = _animationValueFrom + timeline * (_animationValueTo - _animationValueFrom);
        if (_animationTarget != nil && _animationSelector != nil) {
            NSInvocation *anInvocation = [NSInvocation
                                          invocationWithMethodSignature:
                                          [[_animationTarget class] instanceMethodSignatureForSelector:_animationSelector]];
            
            [anInvocation setSelector:_animationSelector];
            [anInvocation setTarget:_animationTarget];
            [anInvocation setArgument:&timeline atIndex:2];
            [anInvocation invoke];
        }
    }
}

- (void)updateDisplayLink:(CADisplayLink *)sender
{
    if (_displayLink == nil) {
        return;
    }
    if (CACurrentMediaTime() - _animationStartTime >= _animationDuration) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    [self setNeedsDisplay];
}


@end
