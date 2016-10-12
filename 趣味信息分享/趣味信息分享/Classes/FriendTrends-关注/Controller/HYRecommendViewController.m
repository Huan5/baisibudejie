//
//  HYRecommendViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/20.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "HYRecommendCategoryCell.h"
#import <MJExtension.h>
#import "HYRecommendCategory.h"
#import "HYRecommendUserCell.h"
#import "HYRecommendUser.h"
#import <MJRefresh.h>

#define HYSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface HYRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>

/**左边的类别表格*/
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/**右边的用户表格*/
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/**左边的类别数据*/
@property(nonatomic,strong)NSArray *categories;

/**请求参数*/
@property(nonatomic,strong) NSMutableDictionary *params;
/**AFN请求管理者*/
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation HYRecommendViewController
static NSString *HYCategoryID = @"category";
static NSString *HYUserID = @"user";

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化控件
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
    
    //加载左侧的类别数据
    [self loadCategories];
}
/**
 *加载左侧的类别数据
 */
- (void) loadCategories{
    //显示指示器
    [SVProgressHUD show];
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe ";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏指示器
        [SVProgressHUD dismiss];
        //服务器返回的JSON数据
        self.categories = [HYRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.categoryTableView reloadData];
        //默认选中首先
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        //让用户表格进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败！"];
        
    }];
}
/**
 *控件初始化
 */
-(void)setupTableView{
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:HYCategoryID];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:HYUserID];
    //设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset =  UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 60;
    //设置背景与标题
    self.title = @"推荐关注";
    self.view.backgroundColor = HYGlobalBg;
}
 /**
  *添加刷新控件
  */
-(void)setupRefresh{
    
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden = YES;
}
#pragma mark - 加载用户数据
-(void) loadNewUsers
{
    HYRecommendCategory *rc = HYSelectedCategory;
    
    //设置当前页码为1
    rc.currentpage = 1;
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe ";
    params[@"category_id"] = @(rc.ID);
    params[@"page"] = @(rc.currentpage);
    self.params = params;
    
    //发送请求给服务器，加载右侧的数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //字典数组 ->模型数组
        NSArray *users = [HYRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //清除所有旧数据
        [rc.users removeAllObjects];
        //添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        //设置总数
        rc.total = [responseObject[@"total"] integerValue];
        
        //不是最后一次请求
        if(self.params != params) return ;
        
        //刷新右边表格
        [self.userTableView reloadData];
        
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
        //检测footer的状态
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.params != params) return ;
        
        //提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreUsers{
    HYRecommendCategory *category = HYSelectedCategory;
    
    //发送请求给服务器，加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe ";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentpage);
    self.params = params;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(self.params != params) return ;
        
        //字典数组 ->模型数组
        NSArray *users = [HYRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        //不是最后一次请求
        if(self.params != params) return ;
        
        //刷新右边表格
        [self.userTableView reloadData];
        //检测footer的状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(self.params != params) return ;
        
        //提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        [self.userTableView.mj_footer endRefreshing];
    }];
}
/**
 *时刻检测footer的状态
 */
- (void)checkFooterState{
    HYRecommendCategory *rc = HYSelectedCategory;
    
    //每次刷新右边数据时，都控制footer的显示也隐藏
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    //让底部控件结束刷新
    if (rc.users.count == rc.total) {//全部加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.userTableView.mj_footer endRefreshing];
    }
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //左边的类别表格
    if (tableView == self.categoryTableView) return self.categories.count;
    //检测footer的状态
    [self checkFooterState];
    //右边用户表格
    return  [HYSelectedCategory users].count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {//左边类别表格
        HYRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HYCategoryID];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{//右边用户表格
        HYRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:HYUserID];

        cell.user = [HYSelectedCategory users][indexPath.row];
        return cell;
    }
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    HYRecommendCategory *c = self.categories[indexPath.row];
    
    [self.userTableView.mj_footer endRefreshing];
    
    if (c.users.count) {
        //显示曾经的数据
        [self.userTableView reloadData];
    }else{
        //赶紧刷新表格，目的是：马上显示当前category的用户数据,不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
        
        //进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    }
}
#pragma mark - 控制器的销毁
- (void)dealloc{
    //停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}
@end
