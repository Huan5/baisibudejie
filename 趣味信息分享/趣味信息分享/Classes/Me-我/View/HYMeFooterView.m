//
//  HYMeFooterView.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/4.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYMeFooterView.h"
#import <AFNetworking.h>
#import "HYSquare.h"
#import <MJExtension.h>
#import "HYSquareButton.h"
#import "HYWebViewController.h"

@implementation HYMeFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        //发送请求给服务器，加载段子
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *squares = [HYSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            [self createSquares:squares];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}
/**
 *  创建方块
 */
-(void)createSquares:(NSArray *)squares{
    //一行最多4列
    int maxCols = 4;
    //宽度和高度
    CGFloat buttonW = HYScreenW /maxCols;
    CGFloat buttonH = buttonW;
    self.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<squares.count; i++) {
        //创建按钮
        HYSquareButton *button = [HYSquareButton buttonWithType:UIButtonTypeCustom];
        //监听点击
        [button addTarget:self action:@selector(squareClike:) forControlEvents:UIControlEventTouchUpInside];
        //传递模型
        button.square = squares[i];
        
        [self addSubview:button];
        //计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    }
    //总行数
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;
    
    CGFloat height = rows * buttonH;
    self.height = 390;
    self.contentSize = CGSizeMake(0, height);
    //重绘
    [self setNeedsDisplay];
}
-(void)squareClike:(HYSquareButton *)button{
    
    HYWebViewController *web = [[HYWebViewController alloc]init];
    if (![button.square.url hasPrefix:@"http"]) {
        web.url = @"http://web.kugou.com";
    }else{
        web.url = button.square.url;
    }
    web.title = button.square.name;
    //取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}
//设置背景图片（画上去的）
-(void)drawRect:(CGRect)rect{
    //[[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
}
@end
