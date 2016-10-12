//
//  HYTopicCell.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopicCell.h"
#import <UIImageView+WebCache.h>
#import "HYTopic.h"
#import "HYTopicPictureView.h"
#import "HYTopicVoiceView.h"
#import "HYTopicVideoView.h"
#import "HYComment.h"
#import "HYUser.h"


@interface HYTopicCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;

/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;

/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/**新浪的加V用户*/
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/**帖子的文字内容*/
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
/**图片帖子中间的内容*/
@property(nonatomic,weak)HYTopicPictureView *pictureView;
/**声音帖子中间的内容*/
@property(nonatomic,weak)HYTopicVoiceView *voiceView;
/**视频帖子中间的内容*/
@property(nonatomic,weak)HYTopicVideoView *videoView;
/**最热评论的内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/**最热评论的整体*/
@property (weak, nonatomic) IBOutlet UIView *topCmtView;


@end
@implementation HYTopicCell

/**
 *  从缓冲池里面重用时先调用这个
 */
-(void)prepareForReuse{
    [super prepareForReuse];
    [_voiceView reset];
    [_videoView reset];
    //恢复顶、分享、踩
    self.dingButton.selected = NO;
    self.caiButton.selected = NO;
    self.shareButton.selected = NO;
    
}

+(instancetype)cell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}
-(HYTopicPictureView *)pictureView{
    if (!_pictureView) {
        HYTopicPictureView *pictureView = [HYTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

-(HYTopicVoiceView *)voiceView{
    if (!_voiceView) {
        HYTopicVoiceView *voiceView = [HYTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

-(HYTopicVideoView *)videoView{
    if (!_videoView) {
        HYTopicVideoView *videoView = [HYTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

-(void)awakeFromNib{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}
-(void)setTopic:(HYTopic *)topic{
    _topic = topic;
    
    //是否为新浪的加V用户
    self.sinaVView.hidden = !topic.isSina_v;
    
    //设置头像
    [self.profileImageView setCircleHeader:topic.profile_image];
    
    //设置名字
    self.nameLabel.text = topic.name;
    
    //设置帖子的创建时间
    self.createTimeLabel.text = topic.create_time;
    
    //设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];

    //设置帖子的文字
    self.text_Label.text = topic.text;
    
    //根据模型类型（帖子类型）添加对应的内容到cell的中间
    if (topic.type == HYTopicTypePicture) {//图片帖子
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        
    }else if (topic.type == HYTopicTypeVoice) {//声音帖子
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        self.videoView.hidden= YES;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
    }else if (topic.type == HYTopicTypeVideo) {//视频帖子
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
    }else if (topic.type == HYTopicTypeWord) {//段子帖子

        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden= YES;
        
    }
    //最热评论
    if (topic.top_cmt) {
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",topic.top_cmt.user.username,topic.top_cmt.content];
        self.topCmtView.hidden = NO;
    }else{
        self.topCmtView.hidden = YES;
    }
    //判断是否显示顶、踩、分享按钮
    if (self.topic.topicDing) {
        self.dingButton.selected = YES;
    }
    if (self.topic.topicCai) {
        self.caiButton.selected = YES;
    }
    if (self.topic.topicShare) {
        self.shareButton.selected = YES;
    }
}

- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    NSString *title = nil;
    if (count == 0) {
        title = placeholder;
    }else if(count > 10000){
        title = [NSString stringWithFormat:@"%.1f万",count/10000.0];
    }else{
        title = [NSString stringWithFormat:@"%zd",count];
    }
    [button setTitle:title forState:UIControlStateNormal];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x = HYTopicCellMargin;
    frame.size.width = HYScreenW - 2 * HYTopicCellMargin;
    //frame.size.height -= HYTopicCellMargin;
    frame.size.height = self.topic.cellHeight - HYTopicCellMargin;
    frame.origin.y += HYTopicCellMargin;
    [super setFrame:frame];
    
}

- (IBAction)more {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //收藏帖子
        //HYLog(@"%@",self.topic);
        NSDictionary *dict = @{@"collectTopic":_topic};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"collect" object:nil userInfo:dict];
    }];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:report];
    [alertController addAction:cancel];
    [alertController addAction:save];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
/**
 *  顶
 */
- (IBAction)dingClick {
    if (self.dingButton.selected) {
        self.dingButton.selected = NO;
        [self setupButtonTitle:self.dingButton count:--self.topic.ding placeholder:@"顶"];
        self.topic.topicDing = NO;
    }else{
        self.dingButton.selected = YES;
        [self setupButtonTitle:self.dingButton count:++self.topic.ding placeholder:@"顶"];
        self.topic.topicDing = YES;
    }
    
}
/**
 *  分享
 */
- (IBAction)shareClick {
    if (self.shareButton.selected) {
        self.shareButton.selected = NO;
        [self setupButtonTitle:self.shareButton count:--self.topic.repost placeholder:@"分享"];
        self.topic.topicShare = NO;
    }else{
        self.shareButton.selected = YES;
        [self setupButtonTitle:self.shareButton count:++self.topic.repost placeholder:@"分享"];
        self.topic.topicShare = YES;
        if ([self.delegate respondsToSelector:@selector(shareClick:)]) {
            [self.delegate shareClick:self];
        }
    }
    
}
/**
 *  评论
 */
- (IBAction)commentClick {
    if ([self.delegate respondsToSelector:@selector(commentClick:)]) {
        [self.delegate commentClick:self];
    }
}

/**
 *  踩
 */
- (IBAction)caiClick {
    if (self.caiButton.selected) {
        self.caiButton.selected = NO;
        [self setupButtonTitle:self.caiButton count:--self.topic.cai placeholder:@"顶"];
        self.topic.topicCai = NO;
    }else{
        self.caiButton.selected = YES;
        [self setupButtonTitle:self.caiButton count:++self.topic.cai placeholder:@"顶"];
        self.topic.topicCai = YES;
    }
}

@end
