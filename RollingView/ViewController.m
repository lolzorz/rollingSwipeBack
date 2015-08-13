//
//  ViewController.m
//  RollingView
//
//  Created by lolzorz on 8/13/15.
//  Copyright (c) 2015 lolzorz.me. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerManager.h"
#import "TestView.h"

#define ANIM_TIME 0.3
#define START_MIN_X 40

@interface ViewController () {
    UIView *_currentView;
    UIView *_lastView;
    CGPoint _startPoint;
    NSMutableArray *_allViews;
    UIView *_rootView;
    BOOL _shouldMove;
}

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ViewControllerManager sharedInstance].vc = self;
    _allViews = [[NSMutableArray alloc] init];
    
    TestView *tv = [[TestView alloc] init];
    [self.view addSubview:tv];
    [_allViews addObject:tv];
    _rootView = tv;
    _currentView = tv;
    _lastView = nil;
    [self refreshButton];
}

- (void)refreshButton {
    if(_lastView) {
        _btnBack.hidden = NO;
        _btnCancel.hidden = NO;
        [self.view bringSubviewToFront:_btnBack];
        [self.view bringSubviewToFront:_btnCancel];
    } else {
        [self hiddenButton];
    }
}

- (void)hiddenButton {
    _btnBack.hidden = YES;
    _btnCancel.hidden = YES;
}

- (void)pressBack:(id)sender {
    [self gotoLastView];
}

- (void)pressCancel:(id)sender {
    [self backToRootView];
}

#pragma mark - refresh view status
- (void)updateCurrentView:(UIView *)currentView lastView:(UIView *)lastView {
    _lastView = lastView;
    _currentView = currentView;
    if(![_allViews containsObject:currentView]) {
        [_allViews addObject:currentView];
    }
}

- (void)updateCurrentView:(UIView *)currentView nextView:(UIView *)nextView {
    _currentView = currentView;
    
    [_allViews removeLastObject];
    [nextView removeFromSuperview];
    if(_allViews.count > 1) {
        _lastView = _allViews[_allViews.count - 2];
    } else {
        _lastView = nil;
    }
}

- (void)addView:(UIView *)view {
    [self hiddenButton];
    [self.view addSubview:view];
    view.hidden = YES;
    [self setRightView:view andRate:0];
    [UIView animateWithDuration:ANIM_TIME
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setLeftView:_currentView andRate:0];
                     }
                     completion:^(BOOL finish) {
                         _currentView.hidden = YES;
                         view.hidden = NO;
                         [UIView animateWithDuration:ANIM_TIME
                                          animations:^{
                                              [self setFontView:view];
                                          }
                                          completion:^(BOOL finish) {
                                              [self updateCurrentView:view lastView:_currentView];
                                              [self refreshButton];
                                          }];
                     }];
}

- (void)gotoLastView {
    if(_lastView) {
        [self hiddenButton];
        _lastView.hidden = YES;
        [self setLeftView:_lastView andRate:0];
        [UIView animateWithDuration:ANIM_TIME
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self setRightView:_currentView andRate:0];
                         }
                         completion:^(BOOL finish) {
                             _currentView.hidden = YES;
                             _lastView.hidden = NO;
                             [UIView animateWithDuration:ANIM_TIME
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  [self setFontView:_lastView];
                                              }
                                              completion:^(BOOL finish) {
                                                  [self updateCurrentView:_lastView nextView:_currentView];
                                                  [self refreshButton];
                                              }];
                         }];
    }
}

- (void)backToRootView {
    if(_allViews.count < 2) {
        return;
    }
    for(NSInteger i = 1; i < _allViews.count - 1; i++) {
        UIView *view = _allViews[i];
        [view removeFromSuperview];
    }
    [_allViews removeAllObjects];
    [_allViews addObject:_rootView];
    [_allViews addObject:_currentView];
    _lastView = _rootView;
    [self gotoLastView];
}

#pragma mark - transform
- (void)setFontView:(UIView *)view {
    CALayer *layer = view.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -700;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0 * M_PI / 180.0f, 0.0f, -1.0f, 0.0f);
    layer.transform = rotationAndPerspectiveTransform;
}

- (void)setLeftView:(UIView *)view andRate:(CGFloat)rate {
    CGFloat angle = rate * 90;
    angle = 90 - angle;
    CALayer *layer = view.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -700;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180.0f, 0.0f, -1.0f, 0.0f);
    layer.transform = rotationAndPerspectiveTransform;
}

- (void)setRightView:(UIView *)view andRate:(CGFloat)rate {
    CGFloat angle = rate * 90;
    angle = 90 - angle;
    CALayer *layer = view.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -700;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    layer.transform = rotationAndPerspectiveTransform;
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[[event allTouches] allObjects] firstObject];
    CGPoint point = [touch locationInView:self.view];
    if(point.x < START_MIN_X) {
        _shouldMove = YES;
        _startPoint = point;
    }
    if(_shouldMove) {
        [self hiddenButton];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[[event allTouches] allObjects] firstObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat moveDistance = point.x - _startPoint.x;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width / 2;
    if(_shouldMove) {
        if(_lastView) {
            if(moveDistance <= 0) {
                [self setFontView:_currentView];
            } else {
                if(moveDistance < screenWidth) {
                    _currentView.hidden = NO;
                    _lastView.hidden = YES;
                    CGFloat rate = (screenWidth - moveDistance) / screenWidth;
                    [self setRightView:_currentView andRate:rate];
                } else {
                    _currentView.hidden = YES;
                    _lastView.hidden = NO;
                    moveDistance -= screenWidth;
                    CGFloat rate = moveDistance / screenWidth;
                    [self setLeftView:_lastView andRate:rate];
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[[event allTouches] allObjects] firstObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat moveDistance = point.x - _startPoint.x;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width / 2;
    if(_shouldMove) {
        if(_lastView) {
            if(moveDistance <= screenWidth) {
                _lastView.hidden = YES;
                _currentView.hidden = NO;
                [UIView animateWithDuration:ANIM_TIME
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self setFontView:_currentView];
                                 }
                                 completion:^(BOOL finish) {
                                     [self refreshButton];
                                 }];
            } else {
                _currentView.hidden = YES;
                _lastView.hidden = NO;
                [UIView animateWithDuration:ANIM_TIME
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self setFontView:_lastView];
                                 }
                                 completion:^(BOOL finish) {
                                     [self updateCurrentView:_lastView nextView:_currentView];
                                     [self refreshButton];
                                 }];
            }
        }
    }
    _shouldMove = NO;
}

@end
