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
#import "LZGCommentCell.h"

static NSString * const comm = @"comment";
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
/**
 *  保存top_cmt
 */
@property(nonatomic,strong)XMGComment *topArray;
/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
//选中的行
@property(nonatomic,strong)NSIndexPath *indexpath;
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
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LZGlogRGB;
    /**
     清空top
     */
    if (self.topic.top_cmt) {
        self.topArray = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        /**
         *  重新计算frame
         */
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    [self setUI];
    [self setHearView];
    [self sethearder];
}
- (void)sethearder{
    self.commentTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.commentTable.mj_header beginRefreshing];
    
    self.commentTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.commentTable.mj_footer.hidden = YES;
}
- (void)loadMoreComments{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 页码
    NSInteger page = self.page + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    XMGComment *cmt = [self.latestComment lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            //        如果没有数据就返回
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                self.commentTable.mj_footer.hidden = YES;
                return ;
            }
            
        // 最新评论
        NSArray *newComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComment addObjectsFromArray:newComments];
        
        // self.latestComments = @[1, 3, 0, 9]
        // newComments = @[2, 8]
        //        [self.latestComments addObject:newComments];
        // self.latestComments = @[1, 3, 0, 9, @[2, 8]]
        
        // 页码
        self.page = page;
        
        // 刷新数据
        [self.commentTable reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComment.count >= total) { // 全部加载完毕
            self.commentTable.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            self.commentTable.mj_footer.hidden = NO;
            [self.commentTable.mj_footer endRefreshing];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.commentTable.mj_footer endRefreshing];
    }];
}
- (void)loadNewComments{
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"a"] = @"dataList";
    dict[@"c"] = @"comment";
    dict[@"data_id"] = self.topic.ID;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        如果没有数据就返回
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.commentTable.mj_header endRefreshing];
            return ;
        }

        self.hotComment = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latestComment = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
         [self.commentTable reloadData];
        [self.commentTable.mj_header endRefreshing];
        
        self.page = 1;
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComment.count >= total) { // 全部加载完毕
            self.commentTable.mj_footer.hidden = YES;
        }else{
            self.commentTable.mj_footer.hidden = NO;
        }
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
    self.commentTable.backgroundColor = LZGlogRGB;
    self.commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    /**
     *  cell的高度设置
     */
    self.commentTable.estimatedRowHeight = 44;
    self.commentTable.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.commentTable registerNib:[UINib nibWithNibName:NSStringFromClass([LZGCommentCell class]) bundle:nil] forCellReuseIdentifier:comm];
    
    // 内边距
    self.commentTable.contentInset = UIEdgeInsetsMake(0, 0, XMGTopicCellMargin, 0);
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
    /**
     *  恢复帖子cmt
     */
    if (self.topArray) {
        self.topic.top_cmt = self.topArray;
        /**
         *  重新计算frame
         */
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    // 取消所有任务
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];
}
- (void)itemClick:(UIBarButtonItem *)item{
    
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
    tableView.mj_footer.hidden = (lat == 0);
    
    if (section == 0) {
        return hot > 0 ? hot : lat;
    }
    if (section == 1) {
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
- (XMGComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:comm];

    cell.comment = [self commentInIndexPath:indexPath];
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
     LZGCommentCell *cell = (LZGCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.indexpath = indexPath;
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }else {
        [cell becomeFirstResponder];
        UIMenuItem *ding = [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding,replay,report];
        [menu setTargetRect:CGRectMake(0, cell.height * 0.5, cell.width, cell.height) inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}
- (void)ding:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.commentTable indexPathForSelectedRow];
    NSLog(@"%@",[self commentInIndexPath:indexPath].content);
}
- (void)replay:(UIMenuController *)menu{
    
}
- (void)report:(UIMenuController *)menu{
    
}
@end
