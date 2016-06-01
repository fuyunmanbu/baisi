//
//  LZGRecommendCategory.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/19.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZGRecommendCategory : NSObject
/** id */
@property (nonatomic, assign) NSInteger ID;
/** 总数 */
@property (nonatomic, assign) NSInteger count;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/**
 *  储存数据
 */
@property(nonatomic,strong)NSMutableArray *users;
/** 当前页码 */
@property (nonatomic, assign) NSInteger category;
/** 总用户数 */
@property (nonatomic, assign) NSInteger total;

@end
