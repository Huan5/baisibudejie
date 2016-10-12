//
//  HYTopicVideoView.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/29.
//  Copyright © 2016年 huanying. All rights reserved.
//视频帖子中间的内容

#import <UIKit/UIKit.h>
@class HYTopic;
@interface HYTopicVideoView : UIView
/**帖子数据*/
@property(nonatomic,strong)HYTopic *topic;
+ (instancetype)videoView;
-(void)reset;
@end
