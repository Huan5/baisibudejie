//
//  HYTopWindow.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/3.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopWindow.h"
#import <UIKit/UIKit.h>

@implementation HYTopWindow

static UIWindow *window_;
+(void)initialize{
    
    window_ = [[UIWindow alloc]init];
    //window_.frame = CGRectMake(0, 0, HYScreenW, 20);
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    
    window_.rootViewController = [[UIViewController alloc] init];
    
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowClick)]];
}
/**
 *  监听窗口点击
 */
+(void)windowClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}
+(void)searchScrollViewInView:(UIView *)superview{
    for (UIScrollView *subView in superview.subviews) {
//        //转换在为屏幕的frmae（可以用来判断该控件用户是不是能看到）
//        //后面默认为屏幕
//        //得到subview在窗口中的frame
//        CGRect newFrame = [subView.superview convertRect:subView.frame toView:nil];
//        //CGRect newFrame = [[UIApplication sharedApplication].keyWindow convertRect:subView.frame fromView:subView.superview];
//        CGRect winBounds = [UIApplication sharedApplication].keyWindow.bounds;
//        //判断这个控件是否在这个屏幕上
//        BOOL isShowingOnWindow = subView.window == [UIApplication sharedApplication].keyWindow && !superview.isHidden && subView.alpha > 0.01 && CGRectIntersectsRect(newFrame, winBounds);//最后一个是判断是否两个控件有交叉
        
        //如果是scrollview，滚动最顶部
        if ([subView isKindOfClass:[UIScrollView class]] && subView.isShowingOnKeyWindow) {
            CGPoint offset = subView.contentOffset;
            offset.y = -subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        //继续查找子控件
        [self searchScrollViewInView:subView];
    }
}
+(void)show{
    window_.hidden = NO;
}
@end
