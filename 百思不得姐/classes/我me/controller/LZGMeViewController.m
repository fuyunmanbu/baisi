//
//  LZGMeViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGMeViewController.h"
#import "XMGMeCell.h"
#import "XMGMeFooterView.h"
#import "XMGSettingViewController.h"
@interface LZGMeViewController ()

@property(nonatomic,assign)NSInteger index;
@end

@implementation LZGMeViewController

static NSString *XMGMeId = @"me";
/** 全局的窗口 */
//static UIWindow *window_;

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
    
    [self.tableView registerClass:[XMGMeCell class] forCellReuseIdentifier:XMGMeId];
//    调整header和footer
//    self.tableView.sectionFooterHeight = XMGTopicCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    
 
    XMGMeFooterView *meFooter = [[XMGMeFooterView alloc]init];
     __weak typeof(self) weakSelf = self;
    meFooter.myBlock =^(NSInteger a){
        weakSelf.index = a;
        //    设置
        self.tableView.contentInset = UIEdgeInsetsMake(45, 0, self.index + 30, 0);
    };
    self.tableView.tableFooterView = meFooter;
}


- (void)tagClick{
    XMGSettingViewController *setting = [[XMGSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)tagClick1{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMGMeCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}

@end
