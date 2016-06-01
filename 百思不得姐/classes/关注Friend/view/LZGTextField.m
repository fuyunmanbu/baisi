
//
//  LZGTextField.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/21.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGTextField.h"
static NSString * const LZGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation LZGTextField
- (void)awakeFromNib{
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:LZGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:LZGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

@end
