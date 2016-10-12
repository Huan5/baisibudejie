//
//  HYRecommendUser.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/21.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYRecommendUser : NSObject
/**头像*/
@property(nonatomic,copy)NSString *header;
/**粉丝数（有多少人关注这个用户）*/
@property(nonatomic,assign)NSInteger fans_count;
/**昵称*/
@property(nonatomic,copy)NSString *screen_name;
/**是否被关注*/
@property(nonatomic,assign,getter=isRecommend)BOOL recommend;
@end
