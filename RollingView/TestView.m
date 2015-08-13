//
//  TestView.m
//  RollingView
//
//  Created by lolzorz on 8/14/15.
//  Copyright (c) 2015 lolzorz.me. All rights reserved.
//

#import "TestView.h"
#import "ViewControllerManager.h"
#import "ViewController.h"

@implementation TestView {
    NSString *_text;
}

- (instancetype)init {
    if(self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        CGRect rect = self.frame;
        rect.size.height = 40;
        rect.origin.y = 60;
        UILabel *lb = [[UILabel alloc] initWithFrame:rect];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor blackColor];
        lb.text = [NSString stringWithFormat:@"%@", @([ViewControllerManager sharedInstance].index++)];
        [self addSubview:lb];
        _text = lb.text;
        
        rect.origin.y += 50;
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        [btn setTitle:@"PUSH" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addView {
    [[ViewControllerManager sharedInstance].vc addView:[[TestView alloc] init]];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", _text);
}

@end
