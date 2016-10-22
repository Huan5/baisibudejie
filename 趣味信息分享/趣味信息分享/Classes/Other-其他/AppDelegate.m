//
//  AppDelegate.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//
#include <dlfcn.h>

#import "AppDelegate.h"
#import "HYTabBarController.h"
#import "HYPushGuideView.h"
#import "HYTopWindow.h"
#import <UMSocialCore/UMSocialCore.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    //创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    //设置窗口的根控制器
    UITabBarController *tabBarController = [[HYTabBarController alloc] init];
    //tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    //弹出引导窗口
    [HYPushGuideView show];
    //弹出TopWindow
    [HYTopWindow show];
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:HYUmAppKey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2688982123"  appSecret:@"0c6fbb9f1eb1a60c29b78d22fe3ed279" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end
