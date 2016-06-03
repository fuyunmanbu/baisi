//
//  LZGCommentCell.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/6/2.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGCommentCell.h"
#import "XMGComment.h"
#import <UIImageView+WebCache.h>
#import "XMGUser.h"
@interface LZGCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;


@end
@implementation LZGCommentCell

- (void)awakeFromNib {
    UIImageView *ima = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.backgroundView = ima;
}

- (void)setComment:(XMGComment *)comment{
    _comment = comment;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.sexImage.image = [comment.user.sex isEqualToString:XMGUserSexMale]?[UIImage imageNamed:@"Profile_manIcon"]:[UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLable.text = comment.content;
    self.likeCountLable.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    self.usernameLable.text = comment.user.username;
    
    if (comment.voiceuri.length) {
        self.pictureButton.hidden = NO;
        [self.pictureButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.pictureButton.hidden = YES;
    }
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = XMGTopicCellMargin;
    frame.size.width -= 2 * XMGTopicCellMargin;
    
    [super setFrame:frame];
}
@end
