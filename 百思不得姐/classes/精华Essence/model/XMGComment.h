//
//  XMGComment.h
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/2.
//  Copyright (c) 2015年 浮云漫步. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMGUser;

@interface XMGComment : NSObject
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) XMGUser *user;
/**
 *  id
 */
@property(nonatomic,copy)NSString *ID;
@end
