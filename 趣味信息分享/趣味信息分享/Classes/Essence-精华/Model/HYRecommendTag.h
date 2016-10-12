//
//  HYRecommendTag.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYRecommendTag : NSObject
/**图片*/
@property(nonatomic,copy)NSString *image_list;
/**名字*/
@property(nonatomic,copy)NSString *theme_name;
/**订阅数*/
@property(nonatomic,assign)NSInteger sub_number;
/**是否被订阅*/
@property(nonatomic,assign,getter=isRecommendTag)BOOL recommendTag;
@end
