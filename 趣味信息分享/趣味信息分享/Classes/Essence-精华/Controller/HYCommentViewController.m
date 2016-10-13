//
//  HYCommentViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/1.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYCommentViewController.h"
#import "HYTopicCell.h"
#import "HYTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "HYComment.h"
#import "HYUser.h"
#import <MJExtension.h>
#import "HYCommentCell.h"
#import <SVProgressHUD.h>

static NSInteger const HYHeaderLabeltag = 99;
static NSString * const HYCommetnId = @"comment";

@interface HYCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 底部工具条的间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 评论的内容*/
@property (weak, nonatomic) IBOutlet UITextField *commentLabel;

/**最热评论*/
@property(nonatomic,strong) NSArray *hotComments;
/**最新评论*/
@property(nonatomic,strong)NSMutableArray *latestComments;
/**保存帖子的top_cmt*/
@property(nonatomic,strong)HYComment *save_top_cmt;
/**保存当前的页码*/
@property(nonatomic,assign)NSInteger page;

/**管理者*/
@property(nonatomic,strong)AFHTTPSessionManager *manager;


@end

@implementation HYCommentViewController

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc]init];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];

}
-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)loadMoreComments{
    //结束之前的所有请求(会进入failure)
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSInteger page = self.page + 1;
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"datalist";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    HYComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    //发送请求给服务器
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //如果不是个字典说明服务器上没有评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        //最新评论
        NSArray *newComments = [HYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        //页码
        self.page = page;
        
        [self.tableView reloadData];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)loadNewComments{
    //结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"datalist";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    //发送请求给服务器
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //如果不是个字典说明服务器上有评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        //最热评论
        self.hotComments = [HYComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        //最新评论
        self.latestComments = [HYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //写入文件
        [responseObject writeToFile:@"/Users/huanying/Desktop/comments.plist" atomically:YES];
        //页码
        self.page = 1;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}
-(void)setupHeader{
    UIView *header = [[UIView alloc]init];
    //清空top_cmt
    if (self.topic.top_cmt) {
        self.save_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    HYTopicCell *cell= [HYTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(HYScreenW, self.topic.cellHeight);
    //添加cell
    [header addSubview:cell];
    header.height = self.topic.cellHeight + HYTopicCellMargin;
    self.tableView.tableHeaderView = header;
}

- (void)setupBasic{
    self.title = @"查看评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" hightImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //cell的高度设置(ios8后才支持的功能)
    //1.先设置子控件与cell底部的约束
    //2.先有估算的高度
    //3.设置自动设置高度（缺一不可）
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = HYGlobalBg;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HYCommentCell class]) bundle:nil] forCellReuseIdentifier:HYCommetnId];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, HYTopicCellMargin, 0);
    
}
-(void)keyboardWillChangeFrame:(NSNotification *)note{
    
    //键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部的约束
    self.buttonSapce.constant = HYScreenH - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //恢复帖子的top_cmt
    if (self.save_top_cmt) {
        self.topic.top_cmt = self.save_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    //取消所有的任务
    [self.manager invalidateSessionCancelingTasks:YES];
}
/**
 *  返回第section组的所有评论数组
 */
-(NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments:self.latestComments;
    }
    return self.latestComments;
}
/**
 * 返回IndexPath位置的评论
 */
-(HYComment *)commentsInIndexPath:(NSIndexPath *)indexPath{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (hotCount) return 2;
    if(latestCount ) return 1;
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount:latestCount;
    }
    
    return latestCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:HYCommetnId];
    
    cell.comment = [self commentsInIndexPath:indexPath];
    
    return cell;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论":@"最新评论";
//    }
//    return @"最新评论";
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //创建头部
//    UIView *header = [[UIView alloc]init];
//    header.backgroundColor = HYGlobalBg;
//    //创建Label
//    UILabel *label = [[UILabel alloc]init];
//    label.textColor = HYRGBColor(67, 67, 67);
//    label.x = HYTopicCellMargin;
//    label.width = 200;
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [header addSubview:label];
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论":@"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return header;
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"header";
    //先从缓存池中找header
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    UILabel *label = nil;
    
    if (!header) {//缓存池中没有就创建headerlabel
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
        header.contentView.backgroundColor = HYGlobalBg;
        //创建Label
        label = [[UILabel alloc]init];
        label.textColor = HYRGBColor(67, 67, 67);
        label.x = HYTopicCellMargin;
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.tag = HYHeaderLabeltag;
        [header.contentView addSubview:label];
    }else{//缓存池中有
        label = (UILabel *)[header viewWithTag:HYHeaderLabeltag];
    }
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        label.text = hotCount ? @"最热评论":@"最新评论";
    }else{
        label.text = @"最新评论";
    }
    return header;
}
#pragma mark - UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark -UIMenuController处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //显示MenuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
        return;
    }
    //被点击的cell
    HYCommentCell *cell = (HYCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    //出现一个第一响应者
    [cell becomeFirstResponder];
    
    //自定义MenuController
    UIMenuItem *ding = [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(report:)];
    menu.menuItems = @[ding,replay,report];
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width *0.5, 0);
    [menu setTargetRect:rect inView:cell];
    [menu setMenuVisible:YES animated:YES];
}
-(void)ding:(UIMenuController *)menu{
    HYLogFunc;
//    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
//    NSLog(@"%@",[self commentsInIndexPath:selected].content);
}
-(void)replay:(UIMenuController *)menu{
    HYLogFunc;
}
-(void)report:(UIMenuController *)menu{
    HYLogFunc;
}
- (IBAction)commentBtnClick {
    if ([self.commentLabel.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论信息!"];
        return;
    }
    HYComment *comment = [[HYComment alloc]init];
    HYUser *user = [[HYUser alloc]init];
    user.profile_image = @"http://qzapp.qlogo.cn/qzapp/100336987/14AEE323D8BE6F24DACD12C2DE412360/100";
    user.username = @"幻影";
    user.sex = @"m";
    comment.user = user;
    comment.content = self.commentLabel.text;
    [self.latestComments addObject:comment];
    [self.tableView reloadData];
}


@end
