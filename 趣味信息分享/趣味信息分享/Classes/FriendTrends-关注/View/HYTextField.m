//
//  HYTextField.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/22.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTextField.h"
#import <objc/runtime.h>

static NSString * const HYPlaceholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation HYTextField

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setValue:_placeholderColor forKeyPath:HYPlaceholderColorKeyPath];
}

/**
 *运行时（Runtime）:
 *能做很多底层操作（比如访问隐藏的一些成员变量\成员方法）
 */
//+(void)initialize{
//    unsigned int count = 0;
//    //拷贝出所有的成员变量列表
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    for (int i = 0; i<count; i++) {
//        //取出成员变量
//        Ivar ivar = *(ivars +i);
        
//        //打印成员变量名字
//        HYLog(@"@%s",ivar_getName(ivar));
//    }
//    //释放
//    free(ivars);
//}
- (void)awakeFromNib{
//    //修改占位文字颜色
//    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //修改光标颜色各文字颜色一致
    self.tintColor = self.textColor;
    
    //不成为第一响应者
    [self resignFirstResponder];
}
/**
 *当前文本框聚焦时就会调用
 */
-(BOOL)becomeFirstResponder{
    //修改占位文字颜色
    [self setValue:self.textColor forKeyPath:HYPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}
/**
 *当前文本框失去焦点时就会调用
 */
-(BOOL)resignFirstResponder{
    //修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:HYPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}
//-(void)setHighlighted:(BOOL)highlighted{
//    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
//}

@end
