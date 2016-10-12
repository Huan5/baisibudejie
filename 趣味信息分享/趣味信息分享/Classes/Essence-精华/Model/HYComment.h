//
//  HYComment.h
//  趣味信息分享
//
//  Created by Huanying on 16/5/1.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYUser;

@interface HYComment : NSObject
/**音频文件的时长*/
@property(nonatomic,assign)NSInteger voicetime;
/**音频文件的路径*/
@property(nonatomic,copy)NSString *voiceuri;
/**评论的文字内容*/
@property(nonatomic,copy)NSString *content;
/**被点赞的数量*/
@property(nonatomic,assign)NSInteger like_count;
/**用户模型*/
@property(nonatomic,strong)HYUser *user;
/**帖子的id*/
@property(nonatomic,copy)NSString *ID;

@end
