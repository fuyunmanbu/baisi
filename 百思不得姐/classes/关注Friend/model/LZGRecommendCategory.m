//
//  LZGRecommendCategory.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/19.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGRecommendCategory.h"

@implementation LZGRecommendCategory
- (NSMutableArray *)users{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}
@end
