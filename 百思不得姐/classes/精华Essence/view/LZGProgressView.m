//
//  LZGProgressView.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/26.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGProgressView.h"

@implementation LZGProgressView

- (void)awakeFromNib{
    self.roundedCorners = 2;
    self.progressLabel.tintColor = [UIColor whiteColor];
}
-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    NSString *ooo = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressLabel.text = [ooo stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
