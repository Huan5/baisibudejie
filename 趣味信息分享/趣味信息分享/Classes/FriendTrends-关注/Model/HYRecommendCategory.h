//
//  HYRecommendCategory.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/20.
//  Copyright © 2016年 huanying. All rights reserved.
//推荐关注左边的数据模型

#import <Foundation/Foundation.h>

@interface HYRecommendCategory : NSObject
/**id*/
@property(nonatomic,assign)NSInteger ID;
/**总数*/
@property(nonatomic,assign)NSInteger count;
/**名字*/
@property(nonatomic,copy)NSString *name;


/**这类别对应的用户数据*/
@property(nonatomic,copy)NSMutableArray *users;
/**总数*/
@property(nonatomic,assign)NSInteger total;
/**当前页码*/
@property(nonatomic,assign)NSInteger currentpage;
@end
