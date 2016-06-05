//
//  LZGloginRegisterController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/20.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGloginRegisterController.h"
#import "XMGTopWindow.h"
@interface LZGloginRegisterController ()
/**
 *  登入框距离控制器view左边的间距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation LZGloginRegisterController
- (IBAction)showLoginOr:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.loginViewLeftMargin.constant == 0) {
         self.loginViewLeftMargin.constant = - self.view.width;
        [sender setTitle:@"登入账号" forState:UIControlStateNormal];
    }else{
        self.loginViewLeftMargin.constant = 0;
        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [XMGTopWindow hide];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)dismis:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [XMGTopWindow show];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
