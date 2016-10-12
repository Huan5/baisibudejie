//
//  HYTopicVideoView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/29.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopicVideoView.h"
#import "HYTopic.h"
#import <UIImageView+WebCache.h>
#import "HYShowPictureViewController.h"
#import "HYVociePlayerController.h"



@interface HYTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
/* 播放器*/
@property (nonatomic,strong)HYVociePlayerController *player;


@end
@implementation HYTopicVideoView
-(HYVociePlayerController *)player{
    if (!_player) {
        _player = [[HYVociePlayerController alloc] init];
    }
    return _player;
}
+(instancetype)videoView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    //设置这个view不要自动调整大小
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听器
//    self.imageView.userInteractionEnabled = YES;
//    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}
//- (void)showPicture{
//    HYShowPictureViewController *showPicture = [[HYShowPictureViewController alloc] init];
//    showPicture.topic = self.topic;
//    //获取根控制器来弹出这个图片控制器view
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
//}
-(void)setTopic:(HYTopic *)topic{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    //播放时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}
- (IBAction)playVideo {
    self.player.url = self.topic.videouri;
    self.player.totalTime = self.topic.videotime;
    self.player.playerEnable = YES;
    
    self.player.view.y = self.height - self.player.view.height;
    self.player.view.width = self.width;
    
    self.player.playerLayer.frame = self.bounds;
    
    [self.layer addSublayer:self.player.playerLayer];
    [self addSubview:self.player.view];
}
-(void)reset{
    [self.player.playerLayer removeFromSuperlayer];
    [self.player.view removeFromSuperview];
    [self.player dismiss];
}
@end
