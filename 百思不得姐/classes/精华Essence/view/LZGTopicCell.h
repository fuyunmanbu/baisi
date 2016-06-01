//
//  LZGTopicCell.h
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/22.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;
@interface LZGTopicCell : UITableViewCell
@property(nonatomic,strong)XMGTopic *topic;
+ (instancetype)cellLoad;
@end
