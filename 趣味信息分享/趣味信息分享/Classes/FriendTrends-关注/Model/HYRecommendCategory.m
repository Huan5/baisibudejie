//
//  HYRecommendCategory.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/20.
//  Copyright © 2016年 huanying. All rights reserved.
// 推荐关注左边的数据模型

#import "HYRecommendCategory.h"
#import <MJExtension.h>

@implementation HYRecommendCategory

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}
- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
