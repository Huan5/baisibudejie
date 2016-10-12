//
//  HYTopicVoiceView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/29.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopicVoiceView.h"
#import "HYTopic.h"
#import <UIImageView+WebCache.h>
#import "HYShowPictureViewController.h"
#import "HYVociePlayerController.h"

@interface HYTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
/**播放控制器*/
@property(nonatomic,strong) HYVociePlayerController *voicePlayer;
@end
@implementation HYTopicVoiceView
-(NSURL *)getNetworkUrl{
    return [NSURL URLWithString:self.topic.voiceuri];
}

-(void)setTopic:(HYTopic *)topic{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    //播放时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}
+(instancetype)voiceView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    //设置这个view不要自动调整大小
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}
- (void)showPicture{
    HYShowPictureViewController *showPicture = [[HYShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    //获取根控制器来弹出这个图片控制器view
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
- (IBAction)playVoice {
    self.playButton.hidden = YES;
    self.voicePlayer = [[HYVociePlayerController alloc]init];
    self.voicePlayer.url = self.topic.voiceuri;
    self.voicePlayer.totalTime = self.topic.voicetime;
    self.voicePlayer.playerEnable = YES;
    
    self.voicePlayer.view.width = self.imageView.width;
    self.voicePlayer.view.y = self.imageView.height - self.voicePlayer.view.height;
    [self addSubview:self.voicePlayer.view];
}
//重置
-(void)reset {
    
    [self.voicePlayer dismiss];
    [self.voicePlayer.view removeFromSuperview];
    self.voicePlayer = nil;
    self.playButton.hidden = NO;
}
-(void)dealloc{
    [self reset];
}
@end
