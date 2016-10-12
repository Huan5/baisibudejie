//
//  HYComment.m
//  趣味信息分享
//
//  Created by Huanying on 16/5/1.
//  Copyright © 2016年 huanying. All rights reserved.
//  评论

#import "HYComment.h"
#import <MJExtension.h>
@implementation HYComment
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             
             };
}

@end
