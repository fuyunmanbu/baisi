//
//  LZGPictureViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/26.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGPictureViewController.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "LZGProgressView.h"
#import <SVProgressHUD.h>
@interface LZGPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScroller;

@property (weak, nonatomic) IBOutlet LZGProgressView *prgressView;
@property(nonatomic,strong) UIImageView *ProgressImage;

@end

@implementation LZGPictureViewController
- (void)panClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)dismisBtnClick:(UIButton *)sender {
    [self panClick];
}
- (IBAction)saveImage:(UIButton *)sender {
    if (self.ProgressImage.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片没有下载完毕"];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(_ProgressImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [self panClick];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    _ProgressImage = [[UIImageView alloc]init];
    _ProgressImage.userInteractionEnabled = YES;
    [self.pictureScroller addSubview:_ProgressImage];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panClick)];
    [_ProgressImage addGestureRecognizer:tap];
    
    CGFloat mainW = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat w = mainW;
    CGFloat h = w * self.topic.height / self.topic.width;
    if (h > mainH) {
        _ProgressImage.frame = CGRectMake(0, 0, w, h);
        self.pictureScroller.contentSize = CGSizeMake(0, h);
    }else {
        
        _ProgressImage.size = CGSizeMake(w, h);
        _ProgressImage.centerY = mainH * 0.5;
    }
    
    /**
     *  马上显示当前图片下载进度
     */
    [self.prgressView setProgress:self.topic.pictureProgress animated:YES];
    
    [_ProgressImage sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.prgressView setProgress:1.0 * receivedSize / expectedSize animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.prgressView.hidden = YES;
    }];
}

@end
