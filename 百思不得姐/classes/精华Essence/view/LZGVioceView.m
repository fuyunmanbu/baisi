//
//  LZGVioceView.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/29.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGVioceView.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "LZGPictureViewController.h"
@interface LZGVioceView ()
@property (weak, nonatomic) IBOutlet UILabel *voiceLength;
@property (weak, nonatomic) IBOutlet UILabel *playcount;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end
@implementation LZGVioceView
+ (instancetype)voiceView{
    return [[[NSBundle mainBundle]loadNibNamed:@"LZGVioceView" owner:nil options:nil]lastObject];
}
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPan)];
    [self.backImage addGestureRecognizer:pan];
}
- (void)loadPan{
    LZGPictureViewController *picture = [[LZGPictureViewController alloc]init];
    picture.topic = self.voice;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picture animated:YES completion:nil];
}

- (void)setVoice:(XMGTopic *)voice{
    _voice = voice;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:voice.large_image]];
    
    self.playcount.text = [NSString stringWithFormat:@"%ld播放",voice.playcount];
    
    // 时长
    NSInteger minute = voice.voicetime / 60;
    NSInteger second = voice.voicetime % 60;
    self.voiceLength.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}
@end
