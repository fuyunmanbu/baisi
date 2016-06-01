//
//  LZGTopicPictureView.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/25.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface LZGTopicPictureView : UIView
@property(nonatomic,strong)XMGTopic *topic;
+ (instancetype)pictureView;
@end
