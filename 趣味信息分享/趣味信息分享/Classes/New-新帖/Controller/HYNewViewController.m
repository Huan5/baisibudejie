//
//  HYNewViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYNewViewController.h"
#import "HYRecommendTagsViewController.h"

@interface HYNewViewController ()

@end

@implementation HYNewViewController
-(instancetype)init{
    if (self = [super init]) {
        self.tabBarItem.badgeValue = @"+66";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.badgeValue = nil;
    //设置导航栏的内容
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick" target:self action:@selector(newClick)];
    //设置导航栏的背景色
    self.view.backgroundColor = HYGlobalBg;
}
-(void)newClick{
    HYRecommendTagsViewController *tags  = [[HYRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:tags animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
