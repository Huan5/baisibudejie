//
//  HYTopicViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/25.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopicViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "HYTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "HYTopicCell.h"
#import "HYCommentViewController.h"
#import "HYNewViewController.h"

#import "HYActivityViewController.h"

#import <UMSocialCore/UMSocialCore.h>

@interface HYTopicViewController ()<HYTopicCellDelegate>
/**帖子数据*/
@property(nonatomic,strong)NSMutableArray *topics;
/**当前页码*/
@property(nonatomic,assign)NSInteger page;
/**当前页的maxTime*/
@property(nonatomic,copy)NSString *maxtime;
/**上一次请求参数*/
@property(nonatomic,strong)NSDictionary *params;
/**上次选中的索引*/
@property(nonatomic,assign)NSInteger lastSelectedIndex;

@end

@implementation HYTopicViewController
static NSString * const HYTopicCellId = @"topic";
-(NSMutableArray *)topics{
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化表格(同时处理通知)
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
    //添加监听者
    [self getNotification];
    
    
}
/**
 * a参数
 */
-(NSString *)a{
    return [self.parentViewController isKindOfClass:[HYNewViewController class]] ? @"newlist" : @"list";
}
/**
 *  初始化表格
 */
-(void)setupTableView{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = HYTitlesViewY + HYTitlesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    //去掉背景色
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册cell的xib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYTopicCell class]) bundle:nil] forCellReuseIdentifier:HYTopicCellId];
}
- (void)getNotification{
    //监听tabBar的选中事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:HYTabBarDidSelectNotfication object:nil];
}
/**
 *  在页面出现的时候调用
 */
//- (void)viewDidAppear:(BOOL)animated{
//}
/**
 *  在页面消失的时候调用
 */
//-(void)viewDidDisappear:(BOOL)animated{
//}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HYTabBarDidSelectNotfication object:nil];
}
-(void)tabBarSelect{
    //如果是连续选中2次，直接刷新
    if (self.tabBarController.selectedIndex == self.lastSelectedIndex && self.view.isShowingOnKeyWindow){
        HYLogFunc;
        [self.tableView.mj_header beginRefreshing];
    }
    //记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}
-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动改变透明度（越往下拉就越明显）
    self.tableView.mj_header.automaticallyChangeAlpha= YES;
    //一进来就刷新
    [self.tableView.mj_header beginRefreshing];
    //设置上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}
/**
 *  加载更多的帖子数据
 */
-(void)loadMoreTopics{
    //结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(++self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    //发送请求给服务器，加载段子
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.params != params) return ;
        
        //存储maxTime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典转模型
        NSArray *newTopics = [HYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return ;
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //恢复页码
        self.page-- ;
    }];
}
/**
 *  加载新的帖子数据
 */
-(void)loadNewTopics{
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    //发送请求给服务器，加载段子
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.params != params) return ;
        
        //存储maxTime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典转模型
        self.topics = [HYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [responseObject writeToFile:@"/Users/huanying/Desktop/list.plist" atomically:YES];
        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //清空页码
        self.page = 0 ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return ;
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:HYTopicCellId];
    if (cell == nil) {
        cell = [[HYTopicCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HYTopicCellId];
    }
    
    cell.delegate = self;
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}
#pragma mark - 代理方法
/**
 *返回每一行cell的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出帖子模型
    HYTopic *topic = self.topics[indexPath.row];
    
    //返回cell的高度
    return topic.cellHeight;
}
/**
 *当选中哪一个cell时调用
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYCommentViewController *commentVc = [[HYCommentViewController alloc]init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}
#pragma mark - HYTopicCellDelegate
/**
 *  评论
 */
-(void)commentClick:(HYTopicCell *)cell{
    HYTopic *topic = cell.topic;
    HYCommentViewController *commentVC = [[HYCommentViewController alloc]init];
    commentVC.topic = topic;
    [self.navigationController pushViewController:commentVC animated:YES];
}
/**
 *  分享
 */
-(void)shareClick:(HYTopicCell *)cell{
    HYTopic *topic = cell.topic;
    
    NSString *textToShare = @"要分享的文本内容";
    
    NSURL *imageToShare = [NSURL URLWithString:topic.large_image];
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSArray *activityItems = @[textToShare,imageToShare,urlToShare];
    
    
    
    HYActivityViewController *activityVC = [[HYActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    //回调函数
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        NSLog(@"activityType :%@", activityType);
        
        if (completed)  {
            
            NSLog(@"completed");
        }
        else  {
            NSLog(@"cancel");
        }
    };
        //completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
        
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
}
@end
