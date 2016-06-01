//
//  LZGFriendTrendsViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGFriendTrendsViewController.h"
#import "LZGCommitViewController.h"
#import "LZGloginRegisterController.h"
@interface LZGFriendTrendsViewController ()

@end

@implementation LZGFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(tagClick)];
     self.view.backgroundColor = LZGlogRGB;
}
- (IBAction)loginRegiser:(UIButton *)sender {
    LZGloginRegisterController *login = [[LZGloginRegisterController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}

- (void)tagClick{
    LZGCommitViewController *commit = [[LZGCommitViewController alloc]init];
    [self.navigationController pushViewController:commit animated:YES];
}

@end
