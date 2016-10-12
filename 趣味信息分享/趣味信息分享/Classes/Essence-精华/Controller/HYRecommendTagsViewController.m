//
//  HYRecommendTagsViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/21.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYRecommendTagsViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "HYRecommendTag.h"
#import <MJExtension.h>
#import "HYRecommendTagCell.h"

@interface HYRecommendTagsViewController ()
/**标签数据*/
@property(nonatomic,strong)NSArray *tags;
@end

static NSString * const HYTagsID = @"tag";

@implementation HYRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self loadTags];
    


}
/**
 *加载Tags
 */
- (void)loadTags{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"c"] = @"topic";
    params[@"action"] = @"sub";
    
    //发送请求
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tags = [HYRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签失败!"];
    }];
}
/**
 *TableView初始化
 */
- (void)setupTableView{
    self.title = @"推荐标签";
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:HYTagsID];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HYGlobalBg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:HYTagsID];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}

@end
