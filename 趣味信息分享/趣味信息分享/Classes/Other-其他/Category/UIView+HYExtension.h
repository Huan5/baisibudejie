//
//  UIView+HYExtension.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/19.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HYExtension)
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
/**
 *  判断一个控件是否真正显示在主窗口上（用户能看见 ）
 */
-(BOOL)isShowingOnKeyWindow;

/**在分类中声明@property,只会生成方法的声明，不会生成方法的实现和带有_下划线的成员变量*/
@end
