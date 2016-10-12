//
//  HYVerticalButton.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYVerticalButton.h"

@implementation HYVerticalButton
-(void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(void)awakeFromNib{
    [self setup];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.height;
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
