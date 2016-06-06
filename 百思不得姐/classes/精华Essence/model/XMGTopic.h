//
//  XMGTopic.h
//  01-百思不得姐
//
//  Created by xiaomage on 15/7/27.
//  Copyright (c) 2015年 浮云漫步. All rights reserved.
//  帖子

#import <UIKit/UIKit.h>
@class XMGComment;
@interface XMGTopic : NSObject
/**
 *  id
 */
@property(nonatomic,copy)NSString *ID;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/** 图片高度 */
@property (nonatomic, assign) CGFloat height;
/** 图片宽度 */
@property (nonatomic, assign) CGFloat width;
/** 小图片URL */
@property (nonatomic, copy) NSString *small_image;
/** 大图片URL */
@property (nonatomic, copy) NSString *large_image;
/** 中图片URL */
@property (nonatomic, copy) NSString *middle_image;

/** 帖子类型 */
@property (nonatomic, assign) AllType type;

/**
 *  图片是否太大
 */
@property(nonatomic,assign,getter=isBig)BOOL bigPicture;
/**
 *  图片控件的frame
 */
@property(nonatomic,assign,readonly)CGRect pictureView;

@property(nonatomic,assign)CGFloat cellHeight;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;
/**
 *  声音frame
 */
@property(nonatomic,assign)CGRect voiceF;
/**
 *  音频时长
 */
@property(nonatomic,assign)NSInteger voicetime;
/**
 *  播放次数
 */
@property(nonatomic,assign)NSInteger playcount;
/**
 *  视频时长
 */
@property(nonatomic,assign)NSInteger videotime;

/** 视频控件的frame */
@property (nonatomic, assign, readonly) CGRect videoF;
/** 最热评论 */
@property (nonatomic, strong) XMGComment *top_cmt;

@end
