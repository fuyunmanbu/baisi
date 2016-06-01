//
//  UIBarButtonItem+LZGNewItem.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LZGNewItem)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
