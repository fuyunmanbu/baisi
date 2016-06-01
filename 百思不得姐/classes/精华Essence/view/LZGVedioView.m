//
//  LZGVedio.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/29.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGVedioView.h"
#import <UIImageView+WebCache.h>
#import "XMGTopic.h"
#import "LZGPictureViewController.h"
@interface LZGVedioView ()
@property (weak, nonatomic) IBOutlet UILabel *VedioLength;
@property (weak, nonatomic) IBOutlet UILabel *Vedioplaycount;
@property (weak, nonatomic) IBOutlet UIImageView *VediobackImage;

@end
@implementation LZGVedioView
+ (instancetype)vedioView{
    return [[[NSBundle mainBundle]loadNibNamed:@"LZGVedioView" owner:nil options:nil]lastObject];
}
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.VediobackImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPan)];
    [self.VediobackImage addGestureRecognizer:pan];
}
- (void)loadPan{
    LZGPictureViewController *picture = [[LZGPictureViewController alloc]init];
    picture.topic = self.vedio;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picture animated:YES completion:nil];
}

- (void)setVedio:(XMGTopic *)vedio{
    _vedio = vedio;
    [self.VediobackImage sd_setImageWithURL:[NSURL URLWithString:vedio.large_image]];
    
    self.Vedioplaycount.text = [NSString stringWithFormat:@"%ld播放",vedio.playcount];
    
    // 时长
    NSInteger minute = vedio.videotime / 60;
    NSInteger second = vedio.videotime % 60;
    self.VedioLength.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}
@end
