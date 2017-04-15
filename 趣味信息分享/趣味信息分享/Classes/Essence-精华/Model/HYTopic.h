//
//  HYTopic.h
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYComment;


@interface HYTopic : NSObject<NSCoding>

/**帖子的id*/
@property(nonatomic,copy)NSString *ID;
/**名称*/
@property(nonatomic,copy)NSString *name;
/**头像的URL*/
@property(nonatomic,copy)NSString *profile_image;
/**发帖时间*/
@property(nonatomic,copy)NSString *create_time;
/**文字内容*/
@property(nonatomic,copy)NSString *text;
/**顶*/
@property(nonatomic,assign)NSInteger ding;
/**踩*/
@property(nonatomic,assign)NSInteger cai;
/**转发*/
@property(nonatomic,assign)NSInteger repost;
/**评论的数量*/
@property(nonatomic,assign)NSInteger comment;
/**是否为新浪的加V用户*/
@property(nonatomic,assign,getter=isSina_v)BOOL sina_v;
/**图片的宽度*/
@property(nonatomic,assign)CGFloat width;
/**图片的高度*/
@property(nonatomic,assign)CGFloat height;
/**小图片的URL*/
@property(nonatomic,copy)NSString *small_image;
/**大图片的URL*/
@property(nonatomic,copy)NSString *large_image;
/**中图片的URL*/
@property(nonatomic,copy)NSString *middle_image;
/**帖子的类型*/
@property(nonatomic,assign)HYTopicType type;
/**声音的时长*/
@property(nonatomic,assign)NSInteger voicetime;
/**音频的URL*/
@property(nonatomic,copy)NSString *voiceuri;
/**视频的时长*/
@property(nonatomic,assign)NSInteger videotime;
/**视频的URL*/
@property(nonatomic,copy)NSString *videouri;
/**播放次数*/
@property(nonatomic,assign)NSInteger playcount;
/**最热评论*/
@property(nonatomic,strong)HYComment *top_cmt;

/****** 额外的辅助属性 ******/

/**cell的高度*/
@property(nonatomic,assign,readonly)CGFloat cellHeight;
/**图片控件的frame*/
@property(nonatomic,assign,readonly)CGRect pictureF;
/**图片是否太大*/
@property(nonatomic,assign,getter=isBigPicture)BOOL bigPicture;
/**图片下载进度*/
@property(nonatomic,assign)CGFloat pictureProgress;
/**是否顶*/
@property(nonatomic,assign,getter=isDing)BOOL topicDing;
/**是否分享*/
@property(nonatomic,assign,getter=isShare)BOOL topicShare;
/**是否踩*/
@property(nonatomic,assign,getter=isCai)BOOL topicCai;



/**声音控件的frame*/
@property(nonatomic,assign,readonly)CGRect voiceF;
/**视频控件的frame*/
@property(nonatomic,assign,readonly)CGRect videoF;

@end
