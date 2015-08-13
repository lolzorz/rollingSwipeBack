//
//  ViewControllerManager.h
//  RollingView
//
//  Created by lolzorz on 8/14/15.
//  Copyright (c) 2015 lolzorz.me. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewController;

@interface ViewControllerManager : NSObject

@property (nonatomic, strong) ViewController *vc;
@property (nonatomic, assign) NSInteger index;

+ (ViewControllerManager *)sharedInstance;

@end
