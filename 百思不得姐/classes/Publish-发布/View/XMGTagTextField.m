//
//  XMGTagTextField.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGTagTextField.h"

@implementation XMGTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // 设置了占位文字内容以后, 才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = 25;
    }
    return self;
}

// 也能在这个方法中监听键盘的输入，比如输入“换行”,中文不监听
//- (void)insertText:(NSString *)text
//{
//    [super insertText:text];
//    
//    XMGLog(@"%d", [text isEqualToString:@"\n"]);
//}

- (void)deleteBackward
{
    
    !self.deleteBlock ? : self.deleteBlock();
    [super deleteBackward];
    
}

@end
