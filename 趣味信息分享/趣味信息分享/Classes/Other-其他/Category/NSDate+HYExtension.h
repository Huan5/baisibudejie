//
//  NSDate+HYExtension.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HYExtension)
/**
 *  比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

@end
