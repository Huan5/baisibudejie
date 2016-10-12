//
//  HYCommentViewController.h
//  趣味信息分享
//
//  Created by Huanying on 16/5/1.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYTopic;

@interface HYCommentViewController : UIViewController
/**帖子模型*/
@property(nonatomic,strong)HYTopic *topic;

@end
