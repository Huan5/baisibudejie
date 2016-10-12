//
//  HYTopicCell.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYTopic;
@class HYTopicCell;


@protocol HYTopicCellDelegate <NSObject>
-(void)commentClick:(HYTopicCell *)cell;
-(void)shareClick:(HYTopicCell *)cell;
@end


@interface HYTopicCell : UITableViewCell
/**帖子数据*/
@property(nonatomic,strong)HYTopic *topic;
/**代理属性*/
@property(nonatomic,assign)id< HYTopicCellDelegate > delegate;
+(instancetype)cell;
@end
