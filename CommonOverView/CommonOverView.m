//
//  CommonOverView.m
//  expecting
//
//  Created by verba8888 on 2015/09/20.
//  Copyright (c) 2015年 verba8888. All rights reserved.
//

#import "CommonOverView.h"

#define BOTTOM_H (44)
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MAIN_COLOR          RGB(129, 216, 208)
#define MAIN_COLOR_DARKGRAY     RGB(100, 100, 100)
#define FONT(Size) [UIFont fontWithName:@"HiraKakuProN-W3" size:(Size)]
#define FONT_B(Size) [UIFont fontWithName:@"HiraKakuProN-W6" size:(Size)]

@interface CommonOverView()

//dialog
@property(nonatomic)UIView *bottomDialogView;
@property(nonatomic)UILabel *bottomLabel;

//indicator
@property(nonatomic)UIView *indicatorView;
@property(nonatomic)UIImageView *indicatorImageView;

//rect
@property(nonatomic)CGRect startRect;
@property(nonatomic)CGRect afterRect;

//state
@property(nonatomic)BOOL isAnimation;

@end

@implementation CommonOverView

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self initialize];
    
    return self;
}

-(void) initialize
{
    
    
    
}

#pragma mark -

-(UIView*)getTopMostView
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController.view;
}

-(void)createViewWithText:(NSString*)text
{
    if (_bottomDialogView) {
        [_bottomDialogView removeFromSuperview];
    }else{
        _bottomDialogView = [UIView new];
        _bottomDialogView.backgroundColor = MAIN_COLOR;
        
        _bottomLabel = [UILabel new];
        _bottomLabel.textColor = MAIN_COLOR_DARKGRAY;
        _bottomLabel.font = FONT_B(12);
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomDialogView addSubview:_bottomLabel];
    }
    
    if (_indicatorView) {
        [_indicatorView removeFromSuperview];
    }
    
    UIView *showView = [self getTopMostView];
    _startRect = CGRectMake(0, CGRectGetHeight(showView.frame), CGRectGetWidth(showView.frame), BOTTOM_H);
    _afterRect = CGRectMake(CGRectGetMinX(_startRect), CGRectGetHeight(showView.frame) - BOTTOM_H, CGRectGetWidth(_startRect),CGRectGetHeight(_startRect));
    
    _bottomDialogView.frame = _startRect;
    _bottomLabel.frame = _bottomDialogView.bounds;
    _bottomLabel.text = text;
    
    [showView addSubview:_bottomDialogView];
    [showView bringSubviewToFront:_bottomDialogView];
    
}

-(void)createIndicator
{
    
    if (_indicatorView) {
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    }
    
    _indicatorView = [UIView new];
    _indicatorView.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    _indicatorImageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"loading_L"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _indicatorImageView.tintColor = MAIN_COLOR;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI / 180) * 360];
    rotationAnimation.duration = 1.5;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_indicatorImageView.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    [_indicatorView addSubview:_indicatorImageView];
    
    if (_bottomDialogView) {
        [_bottomDialogView removeFromSuperview];
    }
    
}

/** 全面インジケータ */
-(void)showIndicator
{
    [self createIndicator];
    
    UIView *showView = [self getTopMostView];
    _indicatorView.frame = showView.bounds;
    _indicatorImageView.center = CGPointMake(CGRectGetWidth(_indicatorView.frame)/2, CGRectGetHeight(_indicatorView.frame)/2);
    
    [showView addSubview:_indicatorView];
    [showView bringSubviewToFront:_indicatorView];
}

-(void)showIndicatorWithView:(UIView*)view
{
    [self createIndicator];
    
    _indicatorView.frame = view.bounds;
    _indicatorImageView.center = CGPointMake(CGRectGetWidth(_indicatorView.frame)/2, CGRectGetHeight(_indicatorView.frame)/2);
    
    [view addSubview:_indicatorView];
    [view bringSubviewToFront:_indicatorView];
}

-(void)hideIndicator
{
    [_indicatorView removeFromSuperview];
}


/** フッターダイアログ */
-(void)showBottonDialogWithText:(NSString*)text
{
    if (!_isAnimation) {
        _isAnimation = YES;
        [self createViewWithText:text];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _bottomDialogView.frame = _afterRect;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.3f
                                                   delay:2
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  _bottomDialogView.frame = _startRect;
                                              } completion:^(BOOL finished) {
                                                  [_bottomDialogView removeFromSuperview];
                                                  _isAnimation = NO;
                                              }];
                         }];
    }
}

@end
