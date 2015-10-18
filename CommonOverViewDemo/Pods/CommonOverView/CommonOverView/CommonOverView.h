//
//  CommonOverView.h
//  expecting
//
//  Created by verba8888 on 2015/09/20.
//  Copyright (c) 2015年 verba8888. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonOverView : NSObject

+ (CommonOverView*)sharedInstance;

/** 全面インジケータ */
-(void)showIndicator;
/** 指定Viewへのオーバーレイインジケータ */
-(void)showIndicatorWithView:(UIView*)view;
/** インジケータ排除 */
-(void)hideIndicator;

/** フッターダイアログ */
-(void)showBottonDialogWithText:(NSString*)text;

@end
