//
//  HYShowPictureViewController.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/27.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYShowPictureViewController.h"
#import "HYTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "HYProgressView.h"

@interface HYShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HYProgressView *progressView;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation HYShowPictureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加imageView
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    
    //图片尺寸
    CGFloat pictureW = HYScreenW;
    CGFloat pictureH = pictureW * self.topic.height /self.topic.width;
    
    if (pictureH > HYScreenH) {//图片显示高度超过一个屏幕
        //需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
        
    }else{
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.center = CGPointMake(HYScreenW * 0.5, HYScreenH * 0.5);
        
    }
    
    //马上显示当前图片的下载进度的值
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    //下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]];
    [imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)save{
    if (self.imageView.image == nil) {
        [SVProgressHUD showSuccessWithStatus:@"图片没有下载完毕!"];
        return;
    }
    //将图片写入相册（用这个方法必须接收参数：使用官方的）
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showSuccessWithStatus:@"保存失败!"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self back];
}
@end
