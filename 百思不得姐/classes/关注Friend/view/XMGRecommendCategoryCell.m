//
//  XMGRecommendCategoryCell.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/19.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "XMGRecommendCategoryCell.h"
#import "LZGRecommendCategory.h"
@interface XMGRecommendCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *selectedIndicator;

@end
@implementation XMGRecommendCategoryCell
- (void)setCategory:(LZGRecommendCategory *)category{
    _category = category;
    self.textLabel.text = category.name;
}
- (void)awakeFromNib {
    self.backgroundColor = LZGRGBColor(244, 244, 244);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    self.selectedIndicator.backgroundColor = LZGRGBColor(219, 21, 26);
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : LZGRGBColor(78, 78, 78);
}
@end
