//
//  HYPublishView.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/28.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYPublishView.h"
#import "HYVerticalButton.h"
#import <POP.h>



static CGFloat const HYAnimationDelay = 0.15;
static CGFloat const HYSPringFactor = 10;
@interface HYPublishView ()
//@property(nonatomic,copy)void(^block)();
@end

@implementation HYPublishView
//-(void)bloc:(void(^)())blok{
//
//}
+(instancetype)publishView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
static UIWindow *window_;
+(void)show{
    //创建窗口
    window_ = [[UIWindow alloc]init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    window_.hidden = NO;
    //添加发布界面
    HYPublishView *publishView = [HYPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
    
}
- (void)awakeFromNib {
    //让控制器不能被点击
    self.userInteractionEnabled = NO;
    
    //数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    //中间的6个按钮
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStarY = (HYScreenH - buttonH * 2) * 0.5;
    CGFloat buttonStarX = 15;
    int maxCols = 3;
    CGFloat xMargin = (HYScreenW - maxCols * buttonW- 2* buttonStarX)/(maxCols-1);
    for (int i = 0; i < images.count ; i ++) {
        HYVerticalButton *button = [[HYVerticalButton alloc]init];
        [self addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        //计算X/Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStarX + col * (buttonW + xMargin);
        CGFloat buttonEndY = buttonStarY + row * buttonH;
        CGFloat buttonStarY = buttonEndY - HYScreenH;
        
        //按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonStarY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX,buttonEndY
, buttonW, buttonH)];
        anim.springBounciness = HYSPringFactor;
        anim.springSpeed = HYSPringFactor;
        anim.beginTime = CACurrentMediaTime() + HYAnimationDelay * i;
        
        [button pop_addAnimation:anim forKey:nil];
    }
    //添加标语
    UIImageView *sloganView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    //标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = HYScreenW * 0.5;
    CGFloat centerEndY = HYScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - HYScreenH;
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * HYAnimationDelay;
    anim.springBounciness = HYSPringFactor;
    anim.springSpeed = HYSPringFactor;
    [sloganView pop_addAnimation:anim forKey:nil];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //让控制器不能被点击
        self.userInteractionEnabled = YES;
    }];

}
-(void)buttonClick:(UIButton *)button{
    [self canceWithCompletionBlock:^{
        if (button.tag == 0) {
            HYLog(@"发视频");
        }
        else if (button.tag == 1) {
            HYLog(@"发图片");
        }
        else if (button.tag == 2) {
            HYLog(@"发段子");
        }
        else if (button.tag == 3) {
            HYLog(@"发声音");
        }
    }];
}
- (IBAction)cancel {
    [self canceWithCompletionBlock:^{
    }];
}
/**
 pop和Core Animation的区别
 1.Core Animation的动画只能添加到layer上
 2.pop的动画能添加到任何对象
 3.pop的底层并非基于Core Animation，是基于CADisplayLink
 4.Core Animation不会真正改变对象的frame/size的值 
 5.pop的动画会实时修改对象的属性
 */
//控制器点击响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancel];
}
//先执行完退出动画，动画完毕扣执行completionBlock的代码
-(void)canceWithCompletionBlock:(void(^)())completionBlock{
    //让控制器不能被点击
    self.userInteractionEnabled = NO;
    int beginIndex = 1;
    
    for (int i = beginIndex; i<self.subviews.count; i++) {
        UIView *subView = self.subviews[i];
        //使用基本动画退出
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + HYScreenH;
        //动画的执行节奏(一开始很慢，后面很快)
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * HYAnimationDelay;
        [subView pop_addAnimation:anim forKey:nil];
        
        //监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//                [self removeFromSuperview];
                //销毁窗口
                
                window_.hidden = YES;
                window_ = nil;
                //执行传进来的completionBlock参数
                !completionBlock ? :completionBlock();
            }];
        }
    }
}

@end
