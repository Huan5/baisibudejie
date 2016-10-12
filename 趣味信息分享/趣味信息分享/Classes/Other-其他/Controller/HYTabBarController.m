//
//  HYTabBarController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTabBarController.h"
#import "HYNewViewController.h"
#import "HYFriendTrendsViewController.h"
#import "HYMeViewController.h"
#import "HYEssenceViewController.h"
#import "HYTabBar.h"
#import "HYNavigationController.h"

#import "HYTopWindow.h"
@interface HYTabBarController ()

@end

@implementation HYTabBarController
+(void)initialize{
    
    //通过appearance统一设置所有UITabBarItem的文字属性
    //后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控件
    [self setupChildVc:[[HYEssenceViewController alloc] init]title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[HYNewViewController alloc] init]title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[HYFriendTrendsViewController alloc] init]title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    HYMeViewController *me = [[HYMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setupChildVc:me title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    //设置当前被选择的控制器
    //self.selectedViewController = me.navigationController;
    
    
    //更换tabBar
    //self.tabBar = [[HYTabBar alloc] init];
    [self setValue:[[HYTabBar alloc] init] forKey:@"tabBar"];
    
    //去掉蓝色渲染第一种方法
//    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    vc01.tabBarItem.selectedImage = image;

//    [vc01.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
//    [vc01.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
}
/*
 *初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置文字和图片
    vc.tabBarItem.title = title;
    vc.navigationItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//    vc.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0  blue:223/255.0  alpha:223/255.0 ];
    //包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];

    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
