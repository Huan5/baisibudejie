//
//  HYCommentCell.h
//  趣味信息分享
//
//  Created by Huanying on 16/5/2.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYComment;

@interface HYCommentCell : UITableViewCell
/**评论*/
@property(nonatomic,strong)HYComment *comment;
@end
