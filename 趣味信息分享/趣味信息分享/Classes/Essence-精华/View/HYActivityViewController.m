//
//  HYActivityViewController.m
//  趣味信息分享
//
//  Created by huanying on 16/10/15.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYActivityViewController.h"
#import "HYActive.h"

@interface HYActivityViewController ()

@end

@implementation HYActivityViewController

-(instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities{
    
    NSArray *actives = [self getActive];
    
    if (self = [super initWithActivityItems:activityItems applicationActivities:actives]) {
//        self.excludedActivityTypes = @[UIActivityTypePostToFacebook,
//                                       UIActivityTypePostToTwitter,
//                                       UIActivityTypePostToWeibo,
//                                       UIActivityTypeMail,
//                                       UIActivityTypePrint,
//                                       UIActivityTypeCopyToPasteboard,
//                                       UIActivityTypeAssignToContact,
//                                       UIActivityTypeSaveToCameraRoll,
//                                       UIActivityTypeAddToReadingList,
//                                       UIActivityTypePostToFlickr,
//                                       UIActivityTypePostToVimeo,
//                                       UIActivityTypePostToTencentWeibo,
//                                       UIActivityTypeAirDrop,
//                                       UIActivityTypeOpenInIBooks];
//        
    }
    return self;
}
-(NSArray *)getActive{
    
    HYActive *weibo = [[HYActive alloc]init];
    
    
    return @[weibo];
}
@end
