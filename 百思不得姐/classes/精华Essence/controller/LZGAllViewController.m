//
//  LZGTextViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/22.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGAllViewController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGTopic.h"
#import <MJRefresh.h>
#import "LZGCommentController.h"
#import "LZGTopicCell.h"
static NSString *const ID = @"topic";
@interface LZGAllViewController ()//<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *topis;
/**
 *  当前页码
 */
@property(nonatomic,assign)NSInteger page;
/**
 *  加载下一页数据时需要的属性
 */
@property(nonatomic,copy)NSString *maxtime;
/**
 *  上一次的请求参数
 */
@property(nonatomic,strong)NSDictionary *params;
@end

@implementation LZGAllViewController
- (NSMutableArray *)topis{
    if (_topis == nil) {
        _topis = [NSMutableArray array];
    }
    return _topis;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat button = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 35;
    CGFloat top = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(button, 0, top, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = LZGlogRGB;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LZGTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
    [self setPerfresh];
    [self loadParame];
}
- (void)setPerfresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadParame)];
    /**
     *  header是否渐变（从隐藏到出现）
     */
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreParame)];
    
}
/**
 *  上拉
 */
- (void)loadMoreParame{
    [self.tableView.mj_header endRefreshing];
    self.page ++;
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"a"] = @"list";
    parame[@"c"] = @"data";
    parame[@"type"] = @(self.type);
    parame[@"page"] = @(self.page);
    parame[@"maxtime"] = self.maxtime;
    self.params = parame;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != parame) return ;
        self.maxtime = responseObject[@"info"][@"maxtime"];
        [self.topis addObjectsFromArray:[XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self.tableView reloadData];
        /**
         *  结束刷新
         */
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != parame) return ;
        [self.tableView.mj_footer endRefreshing];
        self.page --;
    }];
}
/**
 *  下拉
 */
- (void)loadParame{
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"a"] = @"list";
    parame[@"c"] = @"data";
    parame[@"type"] = @(self.type);
    self.params = parame;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (self.params != parame) return;
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        self.topis = [XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        /**
         *  结束刷新
         */
        if (self.params != parame) return ;
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != parame) return ;
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topis.count == 0);
    return self.topis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZGTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    XMGTopic *topis = self.topis[indexPath.row];
    cell.topic = topis;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出帖子模型
    XMGTopic *topic = self.topis[indexPath.row];
    
    // 返回这个模型对应的cell高度
    return topic.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LZGCommentController *vc = [[LZGCommentController alloc]init];
    vc.topic = self.topis[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
