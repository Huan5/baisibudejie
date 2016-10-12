//
//  HYVociePlayerController.h
//  XFBaiSiBuDeJie
//
//  Created by Fay on 16/3/15.
//  Copyright © 2016年 谢飞. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface HYVociePlayerController : UIViewController
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) NSInteger totalTime;
/* 是否播放*/
@property (nonatomic,assign)BOOL playerEnable;
/* 播放器的layer*/
@property (nonatomic,strong)AVPlayerLayer *playerLayer;


-(void)dismiss;
@end
