//
//  LZGPublishView.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/28.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGPublishView.h"
#import "LZGVerticaButton.h"
#import <POP.h>


@implementation LZGPublishView
+ (instancetype)loadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"LZGPublishView" owner:nil options:nil]lastObject] ;
}

- (void)awakeFromNib{
  
    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    /**
     *  中间的六个按钮
     */
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    int maxCols = 3;
    CGFloat maginX = 20;
    CGFloat buttonStartY = (LZGScreenH - 2 * buttonH) * 0.5;
    CGFloat TwoMaginX = (LZGScreenW - 2 * maginX - maxCols * buttonW) / (maxCols - 1);
    
    for (int i = 0; i < images.count; i ++) {
        LZGVerticaButton *btn = [[LZGVerticaButton alloc]init];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        /**
         *  设置frame
         */
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat btnX = maginX + col * (buttonW + TwoMaginX);
        CGFloat btnY = buttonStartY + row * buttonH;
        
//        btn.frame = CGRectMake(btnX, btnY, buttonW, buttonH);
        [self addSubview:btn];
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY - LZGScreenH, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY, buttonW, buttonH)];
        anim.springSpeed = 10;
        anim.springBounciness = 10;
        anim.beginTime = CACurrentMediaTime() + 0.1 * i;
        [btn pop_addAnimation:anim forKey:nil];
    }
    /**
     添加图标
     */
    UIImageView *sloganView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
//    sloganView.y = LZGScreenH * 0.2;
//    sloganView.centerX = LZGScreenW * 0.5;
    [self addSubview:sloganView];
    
    POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim1.fromValue = [NSValue valueWithCGPoint:CGPointMake(LZGScreenW * 0.5, 0)];
    anim1.toValue = [NSValue valueWithCGPoint:CGPointMake(LZGScreenW * 0.5, LZGScreenH * 0.2)];
    anim1.springSpeed = 10;
    anim1.springBounciness = 10;
    anim1.beginTime = CACurrentMediaTime() + 0.05 * images.count;
    [anim1 setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
          [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim1 forKey:nil];
}
- (IBAction)cancel{
    [self cancelWithCompletionBlick:nil];
}
/**
 *  先执行退出动画，再执行completion“Block”
 */
- (void)cancelWithCompletionBlick:(void(^)())completion{
      [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    for (int i = 2; i < self.subviews.count; i ++) {
        UIView *subView = self.subviews[i];
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + LZGScreenH;
        spring.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        spring.beginTime = CACurrentMediaTime() + (i - 2) * 0.05;
        //        spring.springSpeed = 10;
        //        spring.springBounciness = 10;
        [subView pop_addAnimation:spring forKey:nil];
        
        if (i == self.subviews.count - 1) {
            [spring setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
                 [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
                [self removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlick:nil];
}
/**
 *  点击图标按钮后
 */
- (void)btnClick:(UIButton *)btn{
    [self cancelWithCompletionBlick:^{
        if (btn.tag == 0) {
            NSLog(@"加载视图");
        }
    }];
}
@end
