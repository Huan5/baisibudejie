 //
//  HYPushGuideView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/25.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYPushGuideView.h"

@implementation HYPushGuideView

+ (instancetype)guideView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+(void)show{
    //弹出提示是否接收通知消息窗口
    NSString *key = @"CFBundleShortVersionString";
    //取出当前的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //取出沙盒中存储的版本号
    NSString * sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion]) {
        //获取当前的window
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        HYPushGuideView *guideView = [HYPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        //马上存储
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (IBAction)close {
    [self removeFromSuperview];
}

@end
