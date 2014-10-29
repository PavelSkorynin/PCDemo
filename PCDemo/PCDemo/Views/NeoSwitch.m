//
//  NeoSwitch.m
//  PCDemo
//
//  Created by Pavel Skorynin on 29/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import "NeoSwitch.h"
#import "StyleKit.h"

#define DURATION 0.4
#define ANIMATION_FUNCTION MTTimingFunctionEaseInOutQuad

@interface NeoSwitch()

@property () CGFloat currentTimeline;

@end

@implementation NeoSwitch

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _isOn = NO;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setIsOn:(BOOL)isOn
{
    if (_isOn != isOn) {
        _isOn = isOn;
        
        if (_isOn) {
            [self animateWithTarget:self drawSelector:@selector(drawSwitchAnimated:) fromValue:_currentTimeline toValue:1 duration:DURATION * (1 - _currentTimeline) timingFunction:ANIMATION_FUNCTION completion:nil];
        } else {
            [self animateWithTarget:self drawSelector:@selector(drawSwitchAnimated:) fromValue:_currentTimeline toValue:0 duration:DURATION * _currentTimeline timingFunction:ANIMATION_FUNCTION completion:nil];
        }
    }
}

// private
- (void)handleTap:(id)sender
{
    self.isOn = ![self isOn];
}

- (void)drawSwitchAnimated:(CGFloat)timeline
{
    _currentTimeline = timeline;
    [StyleKit drawNeoSwitchWithAnimation:timeline];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (![self inAnimation]) {
        [self drawSwitchAnimated:0];
    }
}

@end
