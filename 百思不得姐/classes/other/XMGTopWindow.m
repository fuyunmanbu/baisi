//
//  XMGTopWindow.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/2.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGTopWindow.h"

@implementation XMGTopWindow

static UIWindow *window_;

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, LZGScreenW, 20);
    window_.backgroundColor = [UIColor clearColor];
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}

+ (void)show
{
    window_.hidden = NO;
}

/**
 * 监听窗口点击
 */
+ (void)windowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}
+ (void)hide{
    window_.hidden = YES;
}

//+ (void)searchScrollViewInView:(UIView *)superview
//{
//    for (UIScrollView *subview in superview.subviews) {
////        判断两个矩形框是否有交界
////        CGRectIntersectsRect([UIApplication sharedApplication].keyWindow.bounds, subview.frame)
////        交换两个视图的坐标系
////        (将a.frame矩形框相对a.superview坐标原点转化为相对b的坐标原点，返回一个新的frame)
////        CGRect newFrame = [a.superview convertRect:a.frame toView:b];
//        
////        CGRect newFrame = [[UIApplication sharedApplication].keyWindow convertRect:subview.frame fromView:subview.superview];
//        
//        // 如果是scrollview, 滚动最顶部
//        if ([subview isKindOfClass:[UIScrollView class]]) {
//            CGPoint offset = subview.contentOffset;
//            offset.y = - subview.contentInset.top;
//            [subview setContentOffset:offset animated:YES];
//        }
//        // 继续查找子控件
//        [self searchScrollViewInView:subview];
//    }
//}
+ (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}
@end
