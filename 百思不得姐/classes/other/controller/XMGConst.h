
#import <UIKit/UIKit.h>

typedef enum {
    AllTypeAll = 1,
    AllTypePicture = 10,
    AllTypeWord = 29,
    AllTypeVoice = 31,
    AllTypeVideo = 41
} AllType;

/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const XMGTitilesViewH;
/** 精华-顶部标题的Y */
UIKIT_EXTERN CGFloat const XMGTitilesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const XMGTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const XMGTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const XMGTopicCellBottomBarH;

/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const XMGTopicCellPictureMaxH;

/** 精华-cell-图片帖子的固定高度 */
UIKIT_EXTERN CGFloat const XMGTopicCellPictureBreakH;

/** XMGUser模型-性别属性值 */
UIKIT_EXTERN NSString * const XMGUserSexMale;
UIKIT_EXTERN NSString * const XMGUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const XMGTopicCellTopCmtTitleH;