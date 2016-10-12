//
//  HYRecommendTagCell.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYRecommendTag;

@interface HYRecommendTagCell : UITableViewCell
/**模型数据*/
@property(nonatomic,strong) HYRecommendTag *recommendTag;
@end
