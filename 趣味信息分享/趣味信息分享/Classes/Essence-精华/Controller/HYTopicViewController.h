//
//  HYTopicViewController.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
// 最基本的帖子控制器

#import <UIKit/UIKit.h>

@interface HYTopicViewController : UITableViewController
/**帖子的类型(交给子类去实现)*/
@property(nonatomic,assign)HYTopicType type;
@end
