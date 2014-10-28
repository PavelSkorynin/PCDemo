//
//  AnimateTimerView.h
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimateTimerView : UIView

- (void)animateWithDuration:(NSTimeInterval)duration WithCompletionBlock:(void(^)())completion;

@end
