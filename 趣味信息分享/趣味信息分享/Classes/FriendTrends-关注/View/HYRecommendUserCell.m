//
//  HYRecommendUserCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/21.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYRecommendUserCell.h"
#import "HYRecommendUser.h"
#import <UIImageView+WebCache.h>

@interface HYRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@end
@implementation HYRecommendUserCell

- (void)awakeFromNib {
    
}
-(void)prepareForReuse{
    
    self.recommendButton.selected = NO;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUser:(HYRecommendUser *)user{
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    if (user.fans_count < 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }else{
        self.fansCountLabel.text = [NSString stringWithFormat:@"%0.1f万人关注",user.fans_count/10000.0];
    }
    //设置头像
    [self.headerImageView setCircleHeader:user.header];
    //设置关注
    if (self.user.recommend == YES) {
        self.recommendButton.selected = YES;
    }else{
        self.recommendButton.selected = NO;
    }
    
}
- (IBAction)recommendBtnClick {
    if (self.recommendButton.selected == YES) {
        self.recommendButton.selected = NO;
        self.user.recommend = NO;
    }else{
        self.recommendButton.selected = YES;
        self.user.recommend = YES;
    }
}
@end
