//
//  LZGTopicCell.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/22.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGTopicCell.h"
#import "XMGTopic.h"
#import <UIImageView+WebCache.h>
#import "LZGTopicPictureView.h"
#import "LZGVioceView.h"
#import "LZGVedioView.h"
#import "XMGComment.h"
#import "XMGUser.h"
@interface LZGTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *text_Lable;
/**
 *  声音帖子
 */
@property(nonatomic,strong) LZGVioceView *voice;
@property(nonatomic,strong)LZGVedioView *vedio;

@property(nonatomic,strong)LZGTopicPictureView *pictureView;
/**
 *  最热评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLable;
/**
 *  最热评论整体
 */
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation LZGTopicCell
+ (instancetype)cellLoad{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
- (LZGVioceView *)voice{
    if (_voice == nil) {
        _voice = [LZGVioceView voiceView];
        [self.contentView addSubview:_voice];
    }
    return _voice;
}
- (LZGVedioView *)vedio{
    if (_vedio == nil) {
        _vedio = [LZGVedioView vedioView];
        [self.contentView addSubview:_vedio];
    }
    return _vedio;
}
- (LZGTopicPictureView *)pictureView{
    if (_pictureView == nil) {
        _pictureView = [LZGTopicPictureView pictureView];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}
- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.backgroundView = bgView;
}
- (void)setTopic:(XMGTopic *)topic{
    _topic = topic;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
//    设置帖子文字内容
    self.text_Lable.text = topic.text;
    
    /**
     *  根据模型内容添加对应的内容
     */
    if (topic.type == AllTypePicture) {
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureView;
        
        self.vedio.hidden = YES;
        self.voice.hidden = YES;
    }else if (topic.type == AllTypeVoice){
        self.voice.hidden = NO;
        self.voice.voice = topic;
        self.voice.frame = topic.voiceF;
        
        self.vedio.hidden = YES;
        self.pictureView.hidden = YES;
    }else if (topic.type == AllTypeVideo){
        self.vedio.hidden = NO;
        self.vedio.vedio = topic;
        self.vedio.frame = topic.videoF;
        
        self.pictureView.hidden = YES;
        self.voice.hidden = YES;
    }else{//段子贴
        self.vedio.hidden = YES;
        self.voice.hidden = YES;
        self.pictureView.hidden = YES;
    }
    // 处理最热评论
    XMGComment *cmt = [topic.top_cmt firstObject];
    if (cmt) {
        self.topView.hidden = NO;
        self.topCmtContentLable.text = [NSString stringWithFormat:@"%@ : %@",cmt.user.username,cmt.content];
    }else{
        self.topView.hidden = YES;
    }
}
/**
 * 设置底部按钮文字
 */
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 10;
    frame.size.width -= frame.origin.x * 2;
//    frame.size.height -= 10;
    frame.size.height = self.topic.cellHeight - XMGTopicCellMargin;
    frame.origin.y += 10;
    [super setFrame:frame];
}
- (IBAction)more:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
