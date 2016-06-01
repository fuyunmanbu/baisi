//
//  LZGNewViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGNewViewController.h"

@interface LZGNewViewController ()

@end

@implementation LZGNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
     self.view.backgroundColor = LZGlogRGB;
}

- (void)tagClick{
    LZGLogFunc;
}

@end
