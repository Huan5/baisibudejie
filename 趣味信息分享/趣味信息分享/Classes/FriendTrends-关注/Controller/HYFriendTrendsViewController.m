//
//  HYFriendTrendsViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYFriendTrendsViewController.h"
#import "HYRecommendViewController.h"
#import "HYLoginRegisterViewController.h"

@interface HYFriendTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *userLoginView;
@property (weak, nonatomic) IBOutlet UIButton *userName;

@end

@implementation HYFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" hightImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    //设置导航栏的背景色
    self.view.backgroundColor = HYGlobalBg;
    //监听login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:HYLogingSuccessNotfication object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  监听到登录就执行
 */
-(void)login:(NSNotification *)sender{
    self.userLoginView.hidden = NO;
    HYLog(@"%@",[sender userInfo][@"name"]);
    [self.userName setTitle:[sender userInfo][@"name"] forState:UIControlStateNormal];
    [self.userName setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
-(void)friendsClick{
    HYRecommendViewController *vc = [[HYRecommendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginRegister {
    HYLoginRegisterViewController *login = [[HYLoginRegisterViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}
- (IBAction)logoutClick:(id)sender {
    [self.userName setTitle:@" " forState:UIControlStateNormal];
    self.userLoginView.hidden = YES;
}


@end
