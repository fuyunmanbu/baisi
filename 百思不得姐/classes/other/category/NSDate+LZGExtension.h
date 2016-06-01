//
//  NSDate+LZGExtension.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/24.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LZGExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end
