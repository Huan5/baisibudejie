//
//  HYCollectTableViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/16.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYCollectTableViewController.h"
#import "HYTopicCell.h"
#import "HYTopic.h"
#import "HYCommentViewController.h"

@interface HYCollectTableViewController ()

@end

@implementation HYCollectTableViewController

static NSString * const cellID = @"topic";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    HYLog(@"%@",self.collects);
}
-(void)setCollects:(NSMutableArray *)collects{
    _collects = collects;
    [self.tableView reloadData];
}
-(void)setupTableView{
    //设置导航栏的背景色
    self.tableView.backgroundColor = HYGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYTopicCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
}
-(void)setupNav{
    self.title = @"收藏";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.topic = self.collects[indexPath.row];
    
    return cell;
}
#pragma mark - Tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出帖子模型
    HYTopic *topic = self.collects[indexPath.row];
    
    //返回cell的高度
    return topic.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCommentViewController *commentVC = [[HYCommentViewController alloc]init];
    HYTopic *topic = self.collects[indexPath.row];
    commentVC.topic = topic;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
//左滑的时候显示删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"不要了";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.collects removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
@end
