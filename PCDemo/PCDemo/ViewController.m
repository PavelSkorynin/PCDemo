//
//  ViewController.m
//  PCDemo
//
//  Created by Pavel Skorynin on 28/10/14.
//  Copyright (c) 2014 A&P Media. All rights reserved.
//

#import "ViewController.h"
#import "AnimatableView.h"
#import "NeoSwitch.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *animatableViews;
@property (weak, nonatomic) IBOutlet NeoSwitch *neoSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

/*
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
        UIView * view = [[AnimatableView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        
        view.clearsContextBeforeDrawing = YES;
        view.backgroundColor = [UIColor clearColor];
        [_animatableViews addObject:view];
        [self.view addSubview:view];
    }
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



@end
