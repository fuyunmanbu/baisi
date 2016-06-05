//
//  LZGRecommendUserCell.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/19.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGRecommendUserCell.h"
#import "LZGRecommendUser.h"
#import <UIImageView+WebCache.h>
@interface LZGRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UIButton *love;

@end
@implementation LZGRecommendUserCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setUser:(LZGRecommendUser *)user{
    _user = user;
    self.name.text = user.screen_name;
    NSString *subNumber = nil;
    if (user.fans_count < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count / 10000.0];
    }
    self.nameText.text =  subNumber;
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.headImage setHeaderImage:user.header];
}

@end
