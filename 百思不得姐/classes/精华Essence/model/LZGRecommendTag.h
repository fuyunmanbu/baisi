//
//  LZGRecommendTag.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/20.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZGRecommendTag : NSObject
/**
 *  图片
 */
@property(nonatomic,copy)NSString *image_list;
/**
 *  名字
 */
@property(nonatomic,copy)NSString *theme_name;
/**
 *  订阅数
 */
@property(nonatomic,assign)NSInteger sub_number;
@end
