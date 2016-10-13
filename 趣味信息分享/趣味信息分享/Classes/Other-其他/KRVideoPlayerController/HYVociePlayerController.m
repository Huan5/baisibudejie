//
//  HYVociePlayerController.m
//  XFBaiSiBuDeJie
//
//  Created by Fay on 16/3/15.
//  Copyright © 2016年 谢飞. All rights reserved.
//

#import "HYVociePlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+XFTime.h"
#import <AVKit/AVKit.h>

@interface HYVociePlayerController ()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UISlider *progress;

/* 音乐视频控制器*/
@property (nonatomic,strong)AVPlayer *playerAV;


/** 进度的Timer */
@property (nonatomic, strong) NSTimer *progressTimer;
//slider 事件处理
- (IBAction)startSlide;
- (IBAction)sliderValueChange;
- (IBAction)endSlide;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;
//暂停
- (IBAction)pause;
@end


@implementation HYVociePlayerController

-(void)viewDidLoad {
    [self.progress setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
    [self startPlayingMusic];
    //self.playTime.text = [NSString stringWithTime:self.totalTime];
    AVPlayer *player = [[AVPlayer alloc] init];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    _playerAV = player;
    _playerLayer = playerLayer;
    
    
}
//view将要显示
-(void)viewWillAppear:(BOOL)animated{
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.playerAV replaceCurrentItemWithPlayerItem:playerItem];
    if (self.playerEnable) {
        [self.playerAV play];
        [self startPlayingMusic];
        self.playBtn.selected = NO;
    }
}
//view已经隐藏
-(void)viewWillDisappear:(BOOL)animated{
    [self.playerAV pause];
    self.playBtn.selected = YES;
    [self removeProgressTimer];
    self.playerEnable = NO;
}
//开始播放音乐
- (void)startPlayingMusic {
    
    [self removeProgressTimer];
    [self addProgressTimer];

}

//添加定时器
- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    //self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 更新进度的界面
- (void)updateProgressInfo
{
    // 1.设置当前的播放时间
    
    self.restTime.text = [NSString stringWithTime:CMTimeGetSeconds(self.playerAV.currentTime)];
    self.playTime.text = [NSString stringWithTime:(CMTimeGetSeconds(self.playerAV.currentItem.duration) - CMTimeGetSeconds(self.playerAV.currentTime))];
    
    // 2.更新滑块的位置
    self.progress.value = CMTimeGetSeconds(self.playerAV.currentTime) / CMTimeGetSeconds(self.playerAV.currentItem.duration);
    //3.判断是否播放完了
    if (CMTimeGetSeconds(self.playerAV.currentTime)==CMTimeGetSeconds(self.playerAV.currentItem.duration)) {
        HYLog(@"hh");
        [self pause];
        
        [self.playerAV seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC)];
    }
//    if (![self.view isShowingOnKeyWindow]) {
//        
//        HYLog(@"我来了%@",[NSThread currentThread]);
//        [self.playerAV pause];
//        self.playBtn.selected = YES;
//        [self removeProgressTimer];
//        self.playerEnable = NO;
//    }
}

#pragma mark - Slider的事件处理
- (IBAction)startSlide {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    // 设置当前播放的时间Label
    self.restTime.text = [NSString stringWithTime:self.totalTime * self.progress.value];
}

- (IBAction)endSlide {
    // 1.设置歌曲的播放时间
    [self.playerAV seekToTime:CMTimeMakeWithSeconds(self.progress.value * CMTimeGetSeconds(self.playerAV.currentItem.duration), NSEC_PER_SEC)];
    [self.playerAV play];
    
    // 2.添加定时器
    [self addProgressTimer];
}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    // 1.获取点击的位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.获取点击的在slider长度中占据的比例
    CGFloat ratio = point.x / self.progress.bounds.size.width;
    
    // 3.改变歌曲播放的时间
    NSTimeInterval totalTime = CMTimeGetSeconds(self.playerAV.currentItem.duration);
    [self.playerAV seekToTime:CMTimeMakeWithSeconds((ratio * totalTime), NSEC_PER_SEC)];
    [self.playerAV play];
    
    // 4.更新进度信息
    [self updateProgressInfo];
}
//暂停
- (IBAction)pause {
    self.playBtn.selected = !self.playBtn.selected;
    
    if (self.playBtn.selected) {
        [self.playerAV pause];
        
        [self removeProgressTimer];
        
        } else {
        [self.playerAV play];
        
        [self addProgressTimer];
            
    }
}

//移除定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)dismiss {
    [self removeProgressTimer];
    [self.playerAV pause];
}
@end
