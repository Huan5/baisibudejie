//
//  HYTopic.m
//  趣味信息分享
//
//  Created by Huanying on 16/4/26.
//  Copyright © 2016年 huanying. All rights reserved.
//

#import "HYTopic.h"
#import <MJExtension.h>
#import "HYComment.h"
#import "HYUser.h"

@implementation HYTopic
{
    CGFloat _cellHeight;
}
/**
 *  告诉在转模型的时候（类型名对应了哪个key）
 */
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
    //可以用.语法加载更深一层的值，比如top_cmt[0].user.qzone_id
    //.后面是字典 （这可以避免多写一个模型）
}
/**
 *  告诉在转模型的时候（这个数组放的是什么模型）
 */
/*
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"top_cmt": [HYComment class]};
    //return @{@"top_cmt": @"HYComment"};
}
*/
-(NSString *)create_time{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //设置时期格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //发贴时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) {//今年
        if (create.isToday) {//今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1 ) {//大于1小时
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if(cmps.minute >= 1){//小于1小时
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else{//小于1分钟
                return @"刚刚";
            }
        }else if(create.isYesterday){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        }else{//其它
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    }else{//非今年
        return _create_time;
    }
    
}

-(CGFloat)cellHeight{
    if (!_cellHeight) {
        //文字最大的尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * HYTopicCellMargin, MAXFLOAT);
        //    CGFloat textH = [topic.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize].height;
        //计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //cell的高度
        //加上文字部分的高度
        _cellHeight = HYTopicCellTextY + textH + HYTopicCellMargin;
        //根据段子的类型来计算cell的高度
        if (self.type == HYTopicTypePicture) {//图片帖子
            //图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            //图片按比例显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            //根据大小是否显示全部
            if (pictureH >= HYTopicCellPictureMaxH) {//图片高度过长
                pictureH = HYTopicCellPictureBreakH;
                self.bigPicture = YES;
            }
            
            //计算图片控件的frame
            CGFloat pictureX = HYTopicCellMargin;
            CGFloat pictureY = HYTopicCellTextY + textH + HYTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            //加上图片的高度
            _cellHeight += pictureH + HYTopicCellMargin;
        }else if (self.type == HYTopicTypeVoice){//声音帖子
            CGFloat voiceX = HYTopicCellMargin;
            CGFloat voiceY = HYTopicCellTextY + textH + HYTopicCellMargin;;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            //加上声音的高度
            _cellHeight += voiceH + HYTopicCellMargin;
        }else if (self.type == HYTopicTypeVideo){//视频帖子
            CGFloat videoX = HYTopicCellMargin;
            CGFloat videoY = HYTopicCellTextY + textH + HYTopicCellMargin;;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            //加上声音的高度
            _cellHeight += videoH + HYTopicCellMargin;
        }
        //如果有最热评论就计算
        HYComment *cmt = self.top_cmt;
        if (cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@",cmt.user.username,cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += HYTopicCellTopCmtTitleH + contentH + HYTopicCellMargin;
        }
        //加上底部工具条的高度
        _cellHeight += HYTopicCellButtonBarH + HYTopicCellMargin;
    }
    return _cellHeight;
}
@end
