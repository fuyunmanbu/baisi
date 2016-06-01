//
//  LZGMeViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGMeViewController.h"

@interface LZGMeViewController ()

@end

@implementation LZGMeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    UIBarButtonItem *btm = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(tagClick)];
    
    UIBarButtonItem *btm1 = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(tagClick1)];
    
    self.navigationItem.rightBarButtonItems = @[
                                                btm,
                                                btm1
                                               ];
     self.view.backgroundColor = LZGlogRGB;
}

- (void)tagClick{
    LZGLogFunc;
}
- (void)tagClick1{
    LZGLogFunc;
}

@end
