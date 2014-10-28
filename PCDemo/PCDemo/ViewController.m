//
//  ViewController.m
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import "ViewController.h"
#import "AnimatableView.h"
#import "AnimateLayerView.h"
#import "AnimateTimerView.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *animatableViews;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self handleButtonClick:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)handleButtonClick:(id)sender {
    UIButton * button = sender;
    
    if (_animatableViews != nil) {
        for (UIView * view in _animatableViews) {
            [view removeFromSuperview];
        }
    }
    
    int N = 100;
    int width = 40;
    int cols = self.view.frame.size.width / width;
    int rows = self.view.frame.size.height / width;
    _animatableViews = [NSMutableArray arrayWithCapacity:N];
    for (int i = 0; i < N && i < (rows * cols); ++i) {
        float x = (i % cols) * width;
        float y = (i / cols) * width;
        UIView * view = nil;
        if (button == nil || button.tag == 0) {
            view = [[AnimatableView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        } else if (button.tag == 1) {
            view = [[AnimateTimerView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        } else if (button.tag == 2) {
            view = [[AnimateLayerView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        }
        
        view.clearsContextBeforeDrawing = YES;
        view.backgroundColor = [UIColor clearColor];
        [_animatableViews addObject:view];
        [self.view addSubview:view];
    }
    [self animateView];
}

- (void)animateView
{
    for (id view in _animatableViews) {
        if (view == _animatableViews.lastObject) {
            [view animateWithDuration:2 WithCompletionBlock:^{
                if ([view superview] == self.view) {
                    [self animateView];
                }
            }];
        } else {
            [view animateWithDuration:2 WithCompletionBlock:nil];
        }
    }
}

@end
