//
//  LZGPushGuideView.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/21.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGPushGuideView.h"

@implementation LZGPushGuideView
+ (instancetype)loadView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        LZGPushGuideView *guideView = [LZGPushGuideView loadView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)meNew:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
