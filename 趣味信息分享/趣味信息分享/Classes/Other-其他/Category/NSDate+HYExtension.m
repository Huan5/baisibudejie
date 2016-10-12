//
//  NSDate+HYExtension.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "NSDate+HYExtension.h"

@implementation NSDate (HYExtension)
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *cmps = [calendar components:unit fromDate:from toDate:self options:0];
    return cmps  ;
}
-(BOOL)isThisYear{
    NSDate *now = [NSDate date];
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:now];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return  nowYear == selfYear;
}
/*
-(BOOL)isToday{
    NSDate *now = [NSDate date];
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return  nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
}*/
-(BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}
-(BOOL)isYesterday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;   
}
@end
