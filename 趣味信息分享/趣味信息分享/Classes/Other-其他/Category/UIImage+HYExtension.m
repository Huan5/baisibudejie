//
//  UIImage+HYExtension.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/4.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "UIImage+HYExtension.h"

@implementation UIImage (HYExtension)
-(instancetype)circleImage{
    //开启图形上下文NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个椭圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return image;
}
@end
