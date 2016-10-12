//
//  UIBarButtonItem+HYExtension.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "UIBarButtonItem+HYExtension.h"

@implementation UIBarButtonItem (HYExtension)
//设置导航控制器的按钮
+(instancetype)itemWithImage:(NSString *)image hightImage:(NSString *)hightImage target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
@end
