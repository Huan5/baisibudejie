//
//  HYUser.h
//  趣味信息分享
//
//  Created by Huanying on 16/5/1.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYUser : NSObject
/**用户名*/
@property(nonatomic,copy)NSString *username;
/**性别*/
@property(nonatomic,copy)NSString *sex;
/**头像*/
@property(nonatomic,copy)NSString *profile_image;
@end
