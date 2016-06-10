//
//  XMGTopic.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/7/27.
//  Copyright (c) 2015年 浮云漫步. All rights reserved.
//

#import "XMGTopic.h"
#import <MJExtension.h>
#import "XMGComment.h"
#import "XMGUser.h"
@implementation XMGTopic{
    CGRect _pictureView;
}
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"top_cmt" : @"XMGComment"};
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}


- (NSString *)create_time{
    
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }

}
- (CGFloat)cellHeight{
        if (!_cellHeight) {
            // 文字的最大尺寸
            CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * XMGTopicCellMargin, MAXFLOAT);
            // 计算文字的高度
            CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            
            // cell的高度
            _cellHeight = XMGTopicCellTextY + textH + XMGTopicCellBottomBarH +  XMGTopicCellMargin;
            if (self.type == AllTypePicture) {
                if (self.width != 0 && self.height != 0) {
                    
                
                /**
                 * 图片显示的最大宽度
                 */
                CGFloat imageW = maxSize.width;
               
                /**
                 * 图片显示的最大高度
                 */
                CGFloat imageH = imageW * self.height / self.width;
                
                if (imageH >=XMGTopicCellPictureMaxH) {
                    imageH = XMGTopicCellPictureBreakH;
                    _bigPicture = YES;
                }
                /**
                 *  计算图片控件的frame
                 */
                CGFloat pictureX = XMGTopicCellMargin;
                CGFloat pictureY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
                
                _pictureView = CGRectMake(pictureX, pictureY, imageW, imageH);
                
                _cellHeight += imageH;
                    }
            }else if (self.type == AllTypeVoice){
                CGFloat voiceX = XMGTopicCellMargin;
                CGFloat voiceY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
                CGFloat voiceW = maxSize.width;
                CGFloat voiceH = voiceW * self.height / self.width;
                _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
                
                _cellHeight += voiceH;
            }else if (self.type == AllTypeVideo) { // 视频帖子
                CGFloat videoX = XMGTopicCellMargin;
                CGFloat videoY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
                CGFloat videoW = maxSize.width;
                CGFloat videoH = videoW * self.height / self.width;
                _videoF = CGRectMake(videoX, videoY, videoW, videoH);
                
                _cellHeight += videoH;
            }
            // 如果有最热评论
            if (self.top_cmt) {
                NSString *content = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, self.top_cmt.content];
                CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
                _cellHeight += XMGTopicCellTopCmtTitleH + contentH + XMGTopicCellMargin;
            }
            _cellHeight += 2 * XMGTopicCellMargin;
        }
        return _cellHeight;
}
@end
