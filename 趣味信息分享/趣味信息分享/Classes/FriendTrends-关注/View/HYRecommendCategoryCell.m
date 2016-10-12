//
//  HYRecommendCategoryCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/20.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYRecommendCategoryCell.h"
#import "HYRecommendCategory.h"

@interface HYRecommendCategoryCell()
/**选中时显示的控件*/
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end
@implementation HYRecommendCategoryCell

- (void)awakeFromNib {
    self.backgroundColor = HYRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = HYRGBColor(219, 21, 26);
    //self.textLabel.textColor = HYRGBColor(78, 78, 78);
    //self.textLabel.highlightedTextColor = HYRGBColor(219, 21, 26);
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = bg;
}

-(void)setCategory:(HYRecommendCategory *)category{
    _category = category;
    self.textLabel.text = category.name;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}
//选中与不被选中调用
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    //HYLog(@"---%d",selected);
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected?self.selectedIndicator.backgroundColor:HYRGBColor(78, 78, 78);;
}

@end
