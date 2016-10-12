//
//  HYMeCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/4.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYMeCell.h"

@implementation HYMeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        
    }
    return self;
}
-(void)layoutSubviews{
    
    
    if (self.imageView.image != nil) {
        self.imageView.width = 30;
        self.imageView.height = self.imageView.width;
        self.imageView.centerY = self.contentView.height * 0.5;
    }
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + HYTopicCellMargin;
    
    [super layoutSubviews];
}
//-(void)setFrame:(CGRect)frame{
//    frame.origin.y -= (35 - HYTopicCellMargin);
//    [super setFrame:frame];
//}
@end
