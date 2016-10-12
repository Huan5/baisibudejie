//
//  HYMeViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYMeViewController.h"
#import "HYTopic.h"
#import "HYMeCell.h"
#import "HYMeFooterView.h"
#import "HYLoginRegisterViewController.h"
#import "HYCollectTableViewController.h"
#import "HYSetingViewController.h"

@interface HYMeViewController ()
/**帖子*/
@property(nonatomic,strong)NSMutableArray *topics;
@end

@implementation HYMeViewController


static NSString *HYMeID = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupTableView];

}
-(NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
-(void)setupTableView{
    //设置导航栏的背景色
    self.tableView.backgroundColor = HYGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    [self.tableView registerClass:[HYMeCell class] forCellReuseIdentifier:HYMeID];
    
    //调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = HYTopicCellMargin;
    
    //调整inset
    self.tableView.contentInset = UIEdgeInsetsMake(HYTopicCellMargin - 35, 0, 0, 0);
    
    //设置footerView
    self.tableView.tableFooterView = [[HYMeFooterView alloc]init];
    
}
-(void)setupNav{
    //设置导航栏标题
    self.navigationItem.title = @"我的";
    //设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" hightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" hightImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    //监听collect
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collect:) name:@"collect" object:nil];
}
/**
 *  监听到通知就执行
 */
-(void)collect:(NSNotification *)sender{
    
    HYTopic *topic = sender.userInfo[@"collectTopic"];
    //HYLog(@"%@",topic);
    [self.topics addObject:topic];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  设置
 */
-(void)settingClick{
    HYSetingViewController *setingVC = [[HYSetingViewController alloc]init];
    [self.navigationController pushViewController:setingVC animated:YES];
}
/**
 *  夜间模式
 */
-(void)nightModeClick{
    HYLogFunc;
}
#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYMeCell *cell = [tableView dequeueReusableCellWithIdentifier:HYMeID];
    

        cell.textLabel.text = @"收藏";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    HYCollectTableViewController *collectVC = [[HYCollectTableViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
    collectVC.collects = self.topics;

}
@end
