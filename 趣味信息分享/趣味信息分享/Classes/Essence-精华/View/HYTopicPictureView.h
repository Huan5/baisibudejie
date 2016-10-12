//
//  HYTopicPictureView.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/27.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTopic.h"

@interface HYTopicPictureView : UIView

/**帖子数据*/
@property(nonatomic,strong)HYTopic *topic;

+ (instancetype)pictureView;
@end
