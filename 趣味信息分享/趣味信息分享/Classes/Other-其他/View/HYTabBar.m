//
//  HYTabBar.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTabBar.h"
#import "HYPublishView.h"

@interface HYTabBar()
@property(nonatomic,weak) UIButton *publishButton;
@end
@implementation HYTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置背景
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        //设置发布按钮
        UIButton *publishButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        //添加响应
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
-(void)publishClick{
    [HYPublishView show];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //标记按钮是否已经添加过监听器
    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    //设置发布按钮的frame

    self.publishButton.center = CGPointMake(width * 0.5,height * 0.5);
    //设置其他UITabBarButton的frame
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    CGFloat buttonY = 0;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if(![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;

        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index ++;
        if (added == NO) {
            //监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    added = YES;
}
-(void)buttonClick{
    //发出一个通知
    [[NSNotificationCenter defaultCenter]postNotificationName:HYTabBarDidSelectNotfication object:nil userInfo:nil];
}
@end
