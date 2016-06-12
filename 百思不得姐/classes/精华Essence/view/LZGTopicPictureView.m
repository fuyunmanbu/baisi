//
//  LZGTopicPictureView.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/25.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "XMGTopic.h"
#import "LZGProgressView.h"
#import "LZGPictureViewController.h"
@interface LZGTopicPictureView ()
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  gif标示
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/**
 *  查看大图按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

@property (weak, nonatomic) IBOutlet LZGProgressView *lableProgress;

@end

@implementation LZGTopicPictureView
- (void)awakeFromNib{

    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPan)];
    [self.imageView addGestureRecognizer:pan];
}
- (void)loadPan{
    LZGPictureViewController *picture = [[LZGPictureViewController alloc]init];
    picture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picture animated:YES completion:nil];
}

- (void)setTopic:(XMGTopic *)topic{
    _topic = topic;
    // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.lableProgress setProgress:topic.pictureProgress animated:NO];
    /**
     *  设置图片
     */
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = 1.0 * receivedSize/expectedSize;
        self.lableProgress.hidden = NO;
        topic.pictureProgress = progress;
        [self.lableProgress setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.lableProgress.hidden = YES;
        if (!topic.isBig) {
            return ;
        }
        UIGraphicsBeginImageContextWithOptions(topic.pictureView.size, YES, 0.0);
        CGFloat width = topic.pictureView.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        
        [image drawInRect:CGRectMake(0, 0, width, height)];
//        获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        //结束上下文
        UIGraphicsEndImageContext();
        
    }];
    /**
     *  是否显示gif图片
     */
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    if (topic.isBig) {
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
}
@end
