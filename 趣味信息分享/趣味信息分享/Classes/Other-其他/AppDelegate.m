//
//  AppDelegate.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "AppDelegate.h"
#import "HYTabBarController.h"
#import "HYPushGuideView.h"
#import "HYTopWindow.h"
#import <UMSocial.h>
#import <UMSocialSinaSSOHandler.h>

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
    
    //设置我的友盟Appkey各sina的appkey secret
    [UMSocialData setAppKey:HYUmAppKey];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2688982123" secret:@"0c6fbb9f1eb1a60c29b78d22fe3ed279" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    return YES;
}
//sina回调方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
//#pragma mark -<UITabBarControllerDelegate>
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    //发出一个通知
//    [[NSNotificationCenter defaultCenter]postNotificationName:HYTabBarDidSelectNotfication object:nil userInfo:nil];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
