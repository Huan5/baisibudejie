//
//  HYActive.m
//  趣味信息分享
//
//  Created by huanying on 16/10/15.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYActive.h"
#import <UMSocialCore/UMSocialCore.h>


@interface HYActive ()
/*分享的文字*/
@property (nonatomic,strong)NSString *text;
/* block*/
@property (nonatomic,copy)  void(^HandleBlock)(void);
@end

@implementation HYActive
- (nullable NSString *)activityType{
    return @"iFreedom";
}
- (nullable NSString *)activityTitle{
    return @"iFreesom";
}
- (UIImage *)_activityImage {
    
    return [UIImage imageNamed:@"login_sina_icon"];
}
- (void)prepareWithActivityItems:(NSArray *)activityItems;{
            self.text = [NSString stringWithFormat:@"%@ %@%@",activityItems[0],activityItems[1],activityItems[2]];
}
//点击了它
- (void)performActivity{

    [self activityDidFinish:YES];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    __weak typeof(self) mySelf = self;
    self.HandleBlock = ^{
        messageObject.text = mySelf.text;
        //弹出分享界面
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:mySelf completion:^(id data, NSError *error) {
            NSString *message = nil;
            if (!error) {
                message = [NSString stringWithFormat:@"分享成功"];
            } else {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
                
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    };
    self.HandleBlock();

}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    if (activityItems.count > 0) {
        return YES;
    }
    return NO;
}
@end
