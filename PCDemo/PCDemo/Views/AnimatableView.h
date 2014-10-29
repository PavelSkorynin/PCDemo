//
//  AnimatableView.h
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTimingFunctions.h"

@interface AnimatableView : UIView

@property (readonly) BOOL inAnimation;

- (void)animateWithTarget:(id)target
             drawSelector:(SEL)drawSelector
                fromValue:(CGFloat)fromValue
                  toValue:(CGFloat)toValue
                 duration:(NSTimeInterval)duration
           timingFunction:(MTTimingFunction)timingFunction
               completion:(void(^)())completion;

@end
