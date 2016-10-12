//
//  UIBarButtonItem+HYExtension.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HYExtension)
+ (instancetype)itemWithImage:(NSString *)image hightImage:(NSString *)hightImage target:(id)target action:(SEL)action;
@end
