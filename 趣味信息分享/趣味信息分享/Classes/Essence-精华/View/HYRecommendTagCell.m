//
//  HYRecommendTagCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYRecommendTagCell.h"
#include "HYRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface HYRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendTabButton;

@end

@implementation HYRecommendTagCell
-(void)prepareForReuse{
    self.recommendTabButton.selected = NO;
}
-(void)setRecommendTag:(HYRecommendTag *)recommendTag{
    _recommendTag = recommendTag;
    
    [self.imageListImageView setCircleHeader:recommendTag.image_list];
    
    
    self.themeNameLabel.text = recommendTag.theme_name;
    
    NSString *subNumber = nil;
    if (recommendTag.sub_number<10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number/10000.0];
    }
    self.subNumberLabel.text = subNumber;
    //设置订阅按钮
    if (self.recommendTag.isRecommendTag) {
        self.recommendTabButton.selected = YES;
    }
}
//只要有改cell的frame就会拦截再设置再传给父类
//可以固定大小  不让别人修改再重写setBounds方法
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
}
- (IBAction)recommendTagBtnClick {
    if (self.recommendTabButton.selected) {
        self.recommendTabButton.selected = NO;
        self.recommendTag.recommendTag = NO;
    }else{
        self.recommendTabButton.selected = YES;
        self.recommendTag.recommendTag = YES;
    }
}

@end
