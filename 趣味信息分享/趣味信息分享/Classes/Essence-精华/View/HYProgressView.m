//
//  HYProgressView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/27.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYProgressView.h"

@implementation HYProgressView
-(void)awakeFromNib{
    //设置进度条的圆角与中间文字颜色
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.userInteractionEnabled = NO;
    
}
-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
}
@end
