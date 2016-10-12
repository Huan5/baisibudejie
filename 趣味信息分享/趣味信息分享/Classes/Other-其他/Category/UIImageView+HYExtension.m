//
//  UIImageView+HYExtension.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/4.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "UIImageView+HYExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (HYExtension)
-(void)setCircleHeader:(NSString *)url{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
