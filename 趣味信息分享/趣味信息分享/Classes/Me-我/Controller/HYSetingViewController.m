//
//  HYSetingViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/20.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYSetingViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface HYSetingViewController ()

@end

@implementation HYSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.backgroundColor = HYGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(35 - HYTopicCellMargin , 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cacel"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cacel"];
    }
    //图片缓存(字节)
    CGFloat size = [SDImageCache sharedImageCache].getSize/1000.0/1000.0;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(已使用%.2fMB)",size];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[SDImageCache sharedImageCache] clearDisk];
    [SVProgressHUD showErrorWithStatus:@"清除成功"];
    [self.tableView reloadData];
}
@end
