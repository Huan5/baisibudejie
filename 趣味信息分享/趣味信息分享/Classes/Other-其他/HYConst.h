
#import <UIKit/UIKit.h>

typedef enum {
    HYTopicTypeAll = 1,
    HYTopicTypePicture = 10,
    HYTopicTypeWord = 29,
    HYTopicTypeVoice = 31,
    HYTopicTypeVideo = 41,
}HYTopicType;
/**精华-所有顶部标题的高度*/
UIKIT_EXTERN CGFloat const HYTitlesViewH;
/**精华-所有顶部标题的Y值*/
UIKIT_EXTERN CGFloat const HYTitlesViewY;


/**精华-cell-间距*/
UIKIT_EXTERN CGFloat const HYTopicCellMargin;
/**精华-cell-底部工具条的高度*/
UIKIT_EXTERN CGFloat const HYTopicCellButtonBarH;
/**精华-cell-文字内容的Y值*/
UIKIT_EXTERN CGFloat const HYTopicCellTextY;
/**精华-cell-图片帖子的最大高度*/
UIKIT_EXTERN CGFloat const HYTopicCellPictureMaxH;
/**精华-cell-图片帖子一旦超过最大高度，就使用Break */
UIKIT_EXTERN CGFloat const HYTopicCellPictureBreakH;
/**精华-cell-最热评论标题的高度*/
UIKIT_EXTERN CGFloat const HYTopicCellTopCmtTitleH;


/**HYUser模型中的性别属性值 */
UIKIT_EXTERN NSString * const HYUserSexMale;
UIKIT_EXTERN NSString * const HYUserSexFemale;

/**tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const HYTabBarDidSelectNotfication;
/**tabBar被选中的通知 - 被选中的控制器的 index key */
UIKIT_EXTERN NSString * const HYSelectedControllerIndexKey;
/**tabBar被选中的通知 - 被选中的控制器的 key */
UIKIT_EXTERN NSString * const HYSelectedControllerKey;
/**登录后发的一个通知的通知名称 */
UIKIT_EXTERN NSString * const HYLogingSuccessNotfication;
/**点击分享后发送的通知名称 */
UIKIT_EXTERN NSString * const HYShareSelectNotfication;
/**友盟Appkey */
UIKIT_EXTERN NSString * const HYUmAppKey;



