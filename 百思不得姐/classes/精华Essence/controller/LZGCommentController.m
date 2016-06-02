//
//  LZGCommentController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/30.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGCommentController.h"
#import "LZGTopicCell.h"
#import "XMGTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "XMGComment.h"
@interface LZGCommentController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  写评论底部限制
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *commentTable;
/**
 *  最热评论
 */
@property(nonatomic,strong)NSArray *hotComment;
/**
 *  最新评论
 */
@property(nonatomic,strong)NSMutableArray *latestComment;
@end

@implementation LZGCommentController
- (NSMutableArray *)latestComment{
    if (_latestComment == nil) {
        _latestComment = [NSMutableArray array];
    }
    return _latestComment;
}
- (NSArray *)hotComment{
    if (_hotComment == nil) {
        _hotComment = [NSArray array];
    }
    return _hotComment;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LZGlogRGB;
    [self setUI];
    [self setHearView];
    [self sethearder];
}
- (void)sethearder{
    self.commentTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.commentTable.mj_header beginRefreshing];
}
- (void)loadNewComments{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"a"] = @"dataList";
    dict[@"c"] = @"comment";
    dict[@"data_id"] = self.topic.ID;
    dict[@"hot"] = @"1";
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.hotComment = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latestComment = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
         [self.commentTable reloadData];
        [self.commentTable.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.commentTable.mj_header endRefreshing];
    }];
}
- (void)setHearView{
    
     UIView *header = [[UIView alloc]init];
    header.backgroundColor = LZGlogRGB;
    LZGTopicCell *cel = [LZGTopicCell cellLoad];
    cel.topic = self.topic;
//    cel.height = self.topic.cellHeight;
//    cel.width = LZGScreenW;
    cel.size = CGSizeMake(LZGScreenW, self.topic.cellHeight);
    [header addSubview:cel];
    
    header.height = self.topic.cellHeight + XMGTopicCellMargin;
//    header.backgroundColor = [UIColor redColor];
    self.commentTable.tableHeaderView = header;
}
- (void)setUI{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"comment_nav_item_share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(itemClick:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti{
//   获取键盘显示／隐藏完毕时的frame
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    修改底部约束
    self.bottomSpace.constant = LZGScreenH - frame.origin.y;
//    获取键盘动画时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
//取消通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)itemClick:(UIBarButtonItem *)item{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - <UITableView>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hot = self.hotComment.count;
    NSInteger lat = self.latestComment.count;
    if (hot) return 2;
    if (lat) return 1;
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hot = self.hotComment.count;
    NSInteger lat = self.latestComment.count;
    if (section == 0) {
        return hot > 0 ? hot : lat;
    }
    if (section == 2) {
        return lat;
    }
    return 0;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSInteger hot = self.hotComment.count;
//    if (section == 0) {
//        return hot > 0 ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = LZGlogRGB;
    UILabel *label = [[UILabel alloc]init];
    label.width = 200;
    label.x = XMGTopicCellMargin;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    NSInteger hot = self.hotComment.count;
        if (section == 0) {
            label.text = hot > 0 ? @"最热评论" : @"最新评论";
        }else {
            label.text = @"最新评论";
        }
    [view addSubview:label];
    return view;
}
/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComment.count ? self.hotComment : self.latestComment;
    }
    return self.latestComment;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    XMGComment *comment = [self commentsInSection:indexPath.section][indexPath.row];
    cell.textLabel.text = comment.content;
    return cell;
}
@end
