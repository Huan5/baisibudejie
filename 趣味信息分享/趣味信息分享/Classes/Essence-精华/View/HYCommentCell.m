//
//  HYCommentCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/2.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYCommentCell.h"
#import "HYComment.h"
#import "HYUser.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface HYCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
/**播放控制器*/
@property(nonatomic,strong)AVPlayer *player;


@end
@implementation HYCommentCell

-(void)prepareForReuse{
    if (self.player != nil) {
        self.player = nil;
    }
}
#pragma mark - MenuController处理
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

-(void)setComment:(HYComment *)comment{
    _comment = comment;
    //设置头像
    [self.profileImageView setCircleHeader:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:HYUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceButton.hidden = YES;
    }
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x += HYTopicCellMargin;
    frame.size.width -= 2*HYTopicCellMargin;
    [super setFrame:frame];
}
-(void)awakeFromNib{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}
- (IBAction)voicebtnClick {
    if (self.player != nil) {
        self.player = nil;
    }
    self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:self.comment.voiceuri]];
    [self.player play];
}
- (IBAction)likebtnClick {
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",++self.comment.like_count];
}

@end
