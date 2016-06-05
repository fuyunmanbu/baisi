//
//  LZGRecommindTagCell.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/20.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGRecommindTagCell.h"
#import "LZGRecommendTag.h"
#import <UIImageView+WebCache.h>
@interface LZGRecommindTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_List;
@property (weak, nonatomic) IBOutlet UILabel *themNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;


@end
@implementation LZGRecommindTagCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setRecommend:(LZGRecommendTag *)recommend{
    _recommend = recommend;
//    [self.image_List sd_setImageWithURL:[NSURL URLWithString:recommend.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.image_List setHeaderImage:recommend.image_list];
    self.themNameLabel.text = recommend.theme_name;
    
    NSString *subNumber = nil;
    if (recommend.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommend.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommend.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 7;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -=1;
    [super setFrame:frame];
}

@end
