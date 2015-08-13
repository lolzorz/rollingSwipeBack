//
//  ViewControllerManager.m
//  RollingView
//
//  Created by lolzorz on 8/14/15.
//  Copyright (c) 2015 lolzorz.me. All rights reserved.
//

#import "ViewControllerManager.h"

@implementation ViewControllerManager

+ (ViewControllerManager *)sharedInstance {
    static ViewControllerManager *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[ViewControllerManager alloc] init];
    });
    return instance;
}

@end
