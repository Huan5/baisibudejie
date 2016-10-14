//
//  HYEssenceViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYEssenceViewController.h"
#import "HYRecommendTagsViewController.h"
#import "HYTopicViewController.h"
#import <SVProgressHUD.h>

@interface HYEssenceViewController () <UIScrollViewDelegate>
/**标签栏底部红色指示器*/
@property(nonatomic,weak)UIView *indicatorView;
/**当前选中的按钮*/
@property(nonatomic,weak)UIButton *selectedButton;
/**标签的view*/
@property(nonatomic,weak)UIView *titlesView;
/**底部的所有内容*/
@property(nonatomic,weak)UIScrollView *contentView;
@end

@implementation HYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setupNav];
    
    //初始化scrollView的子控制器
    [self setupChildVces];
    
    //设置顶部的标签栏
    [self setupTitlesView];
    
    //底部的scrollView
    [self setupContenView];
    

}
/**
 *  初始化scrollView的子控制器
 */
-(void)setupChildVces{
    HYTopicViewController *all = [[HYTopicViewController alloc]init];
    all.title = @"全部";
    all.type = HYTopicTypeAll;
    [self addChildViewController:all];
    
    HYTopicViewController *voice = [[HYTopicViewController alloc]init];
    voice.title = @"声音";
    voice.type = HYTopicTypeVoice;
    [self addChildViewController:voice];
    
    HYTopicViewController *video = [[HYTopicViewController alloc]init];
    video.title = @"视频";
    video.type = HYTopicTypeVideo;
    [self addChildViewController:video];
    
    HYTopicViewController *picture = [[HYTopicViewController alloc]init];
    picture.title = @"图片";
    picture.type = HYTopicTypePicture;
    [self addChildViewController:picture];
    
    HYTopicViewController *word = [[HYTopicViewController alloc]init];
    word.title = @"段子";
    word.type = HYTopicTypeWord;
    [self addChildViewController:word];
}
/**
 *  设置顶部的标签栏
 */
-(void)setupTitlesView{
    
    //标签栏
    UIView *titleView = [[UIView alloc]init];
    //让背景半透明
    //titleView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleView.width = self.view.width;
    titleView.height = HYTitlesViewH;
    titleView.y = HYTitlesViewY;
    [self.view addSubview:titleView];
    self.titlesView = titleView;
    
    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y= titleView.height - indicatorView.height;
    
    self.indicatorView = indicatorView;
    
    //内部的子标签
    NSInteger count = self.childViewControllers.count;
    CGFloat height = titleView.height;
    CGFloat width = titleView.width/count;
    for (NSInteger i = 0; i<count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i ;
        button.height = height;
        button.width = width;
        button.x = i*width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        //[button layoutIfNeeded];//强制布局（强制更新子控件的frame）
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClik:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        //默认点击了第一个按钮
        if (i == 0) {
            self.selectedButton = button;
            //让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titleView addSubview:indicatorView];

}
-(void)titleClik:(UIButton *)button{
    //修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = self.selectedButton.titleLabel.width;
        self.indicatorView.centerX = self.selectedButton.centerX;
    }];
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}
/**
 *  底部的scrollView
 */
-(void)setupContenView{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    contentView.pagingEnabled = YES;
    self.contentView = contentView;
    
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

/**
 *  设置导航栏
 */
-(void)setupNav{
    [SVProgressHUD setMinimumDismissTimeInterval:HYShowMessageDismissTimeInterval];
    //设置导航栏的标题
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //设置导航栏的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    //设置导航栏的背景色
    self.view.backgroundColor = HYGlobalBg;
}

-(void)tagClick{
    HYRecommendTagsViewController *tags  = [[HYRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:tags animated:YES];
}

#pragma mark - UIScrollViewDelegate
//代码设置offset的时候调用 手势拖动不调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    //添加子控制器的view
    
    //当前的索引
   NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;//设置控制器view的y值为0（默认是20）
    vc.view.height = scrollView.height;//设置控制器view的height的值为整个屏幕的高度（默认是比屏幕高度少了20）


    [scrollView addSubview:vc.view];
}
//手势拖动的时候调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    NSInteger index = scrollView.contentOffset.x /scrollView.width;
    [self titleClik:self.titlesView.subviews[index]];
}



@end
