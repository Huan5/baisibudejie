//
//  HYTopicPictureView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/27.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopicPictureView.h"
#import "HYTopic.h"
#import <UIImageView+WebCache.h>
#import "HYProgressView.h"
#import "HYShowPictureViewController.h"
#import <UIKit/UIKit.h>

@interface HYTopicPictureView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** GIF标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet HYProgressView *progressView;



@end
@implementation HYTopicPictureView

+(instancetype)pictureView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    //设置这个view不要自动调整大小
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}
- (void)showPicture{
    HYShowPictureViewController *showPicture = [[HYShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    //获取根控制器来弹出这个图片控制器view
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
-(void)setTopic:(HYTopic *)topic{
    _topic = topic;
    
    /*
     在不知道图片扩展名的情况下，如何知道图片的真实类型？
     *取出图片数据的第一个字节，就可以判断图片的类型
     */
    
    //立马显示最新的进度值(防止因为网速慢，导致显示的是其他循环利用的cell的图片下载进度)
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {//加载时期调用
        self.progressView.hidden = NO;
        //计算进度值
        topic.pictureProgress = 1.0 * receivedSize /expectedSize;
        //显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {//加载完后调用
        
        self.progressView.hidden = YES;
        
        //如果是大图才进行绘图的处理
        if (topic.isBigPicture == NO) return ;
        
        //开启图形的上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        //将下载完的图片对象绘制到图形上下文中
        CGFloat width = self.topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0,width,height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsEndImageContext();
    }];
    //判断是否为gif
    NSString *extension = topic.large_image.pathExtension;//拿到这个图片的扩展名
    //                                不区分大小写
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    //判断是否显示“点击查看全图”
    if (topic.isBigPicture) {//大图
        self.seeBigButton.hidden = NO;
    }else{//非大图
        self.seeBigButton.hidden = YES;
    }
}
@end
