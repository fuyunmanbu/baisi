//
//  LZGEssenceViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/17.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGEssenceViewController.h"
#import "LZGRecommendTagsController.h"
#import "LZGAllViewController.h"

@interface LZGEssenceViewController ()<UIScrollViewDelegate>
/**
 *  指示器
 */
@property(nonatomic,strong)UIView *buttonView;
/**
 *  记录btn
 */
@property(nonatomic,strong)UIButton *btn;
/**
 *  导航条整体
 */
@property(nonatomic,strong)UIView *titlesView;
/**
 *  scroller
 */
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation LZGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LZGlogRGB;
    [self setNavigation];
    [self setTitliView];
    [self setupChildView];
    [self setupContentView];
    
}
- (void)setupChildView{
    LZGAllViewController *all = [[LZGAllViewController alloc]init];
    all.type = AllTypeAll;
    [self addChildViewController:all];
    
    LZGAllViewController *video = [[LZGAllViewController alloc]init];
    video.type = AllTypeVideo;
    [self addChildViewController:video];
    
    LZGAllViewController *shen = [[LZGAllViewController alloc]init];
    shen.type = AllTypeVoice;
    [self addChildViewController:shen];
    
    LZGAllViewController *photo = [[LZGAllViewController alloc]init];
    photo.type = AllTypePicture;
    [self addChildViewController:photo];
    
    LZGAllViewController *text = [[LZGAllViewController alloc]init];
    text.type = AllTypeWord;
    [self addChildViewController:text];
}
/**
 *  导航条
 */
- (void)setTitliView{
//    整体视图
    UIView *titleView = [[UIView alloc]init];
    self.titlesView = titleView;
    titleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    titleView.width = self.view.width;
    titleView.height = 35;
    titleView.y = 64;
    [self.view addSubview:titleView];
    
    //    指示器
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.height = 2;
    redView.y = titleView.height - redView.height;
    
    self.buttonView = redView;
    
//    内部控件
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSInteger count = 5;
    CGFloat width = titleView.width / count;
    CGFloat height = titleView.height;
    for (NSInteger i = 0; i<count; i ++) {
        UIButton *button = [[UIButton alloc]init];
        button.height = height;
        button.width = width;
        button.x = i * width;
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        /**
         *  默认点击了第一个按钮
         */
        if (i == 0) {
            button.enabled = NO;
            self.btn = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.buttonView.width = button.titleLabel.width;
         // self.indicatorView.width = [titles[i] sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            self.buttonView.centerX = button.centerX;
        }
    }
    [titleView addSubview:redView];
}
- (void)titleClick:(UIButton *)btn{
    /**¸
     *  修改按钮状态
     */
    self.btn.enabled = YES;
    btn.enabled = NO;
    self.btn = btn;
    [UIView animateWithDuration:0.4 animations:^{
        self.buttonView.width = btn.titleLabel.width;
        self.buttonView.centerX = btn.centerX;
    }];
    
    CGFloat x = btn.tag * self.contentView.width;
    
    [self.contentView setContentOffset:CGPointMake(x, 0) animated:YES];
}
- (void)setNavigation{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}
- (void)tagClick{
    LZGRecommendTagsController *recommend = [[LZGRecommendTagsController alloc]initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:recommend animated:YES];
}
/**
 *  底部scrolleView
 */
- (void)setupContentView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.contentView.width, 0);
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.height = self.view.height;
    vc.view.y = 0;
    vc.view.x = scrollView.contentOffset.x;
    
    [scrollView addSubview:vc.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}
@end
