//
//  HYPublishView.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/28.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPublishView : UIView

/* 这个IBInspectable可以用来将这个属性放到视图上面设置，可以动态的改变自定义的View，得重写set方法*/
@property (nonatomic,strong)IBInspectable UIColor *layerColor;
/* layer圆角*/
@property (nonatomic,assign)IBInspectable CGFloat f;
+ (instancetype)publishView;
/**
 *  显示
 */
+ (void)show;
@end
