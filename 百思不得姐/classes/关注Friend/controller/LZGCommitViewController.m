//
//  LZGCommitViewController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/18.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGCommitViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "XMGRecommendCategoryCell.h"
#import "LZGRecommendCategory.h"
#import "LZGRecommendUserCell.h"
#import "LZGRecommendUser.h"
#import <MJRefresh.h>

#define LZGSelectedCategory self.categories[self.tableViewLeft.indexPathForSelectedRow.row]
@interface LZGCommitViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewLeft;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRight;
/**
 *  左边的类别数据
 */
@property(nonatomic,strong)NSArray *categories;
/**
 *  请求参数
 */
@property (nonatomic , strong)NSMutableDictionary *parms;

@property(nonatomic,strong)AFHTTPSessionManager *manger;


@end

@implementation LZGCommitViewController
- (AFHTTPSessionManager *)manger{
    if (_manger == nil) {
        _manger = [AFHTTPSessionManager manager];
    }
    return _manger;
}
static NSString *const ID = @"cell1";
static NSString *const rightID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableViewRight.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableViewLeft.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
   
    self.tableViewRight.rowHeight = 70;
    self.title = @"推荐关注";
    [SVProgressHUD show];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.view.backgroundColor = LZGlogRGB;
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"a"] = @"category";
    parame[@"c"] = @"subscribe";
    [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        self.categories = [LZGRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableViewLeft reloadData];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableViewLeft selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self.tableViewRight.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
    }];
    [self registerNib];
    [self setupRefresh];
}
- (void)setupRefresh{
//    上拉
    self.tableViewRight.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        LZGRecommendCategory *c = LZGSelectedCategory;
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"a"] = @"list";
        parame[@"c"] = @"subscribe";
        parame[@"category_id"] = @(c.ID);
        parame[@"page"] = @(++c.category);
        self.parms = parame;
        [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [c.users addObjectsFromArray:[LZGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            if (self.parms != parame) return ;
            [self.tableViewRight reloadData];
            
            [self checkFooterState];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.parms != parame) return ;
            //            让底部控件结束刷新
            [self.tableViewRight.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        }];
        
    }];
    
//    下拉
    self.tableViewRight.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        LZGRecommendCategory *c = LZGSelectedCategory;
        c.category = 1;
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"a"] = @"list";
        parame[@"c"] = @"subscribe";
        parame[@"category_id"] = @(c.ID);
        parame[@"page"] = @(c.category);
        self.parms = parame;
        [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //   清空所有旧数据
            [c.users removeAllObjects];
            
            [c.users addObjectsFromArray:[LZGRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            c.total = [responseObject[@"total"] integerValue];
            
            if (self.parms != parame) return ;
            
            [self.tableViewRight reloadData];
            [self.tableViewRight.mj_header endRefreshing];
           
            [self checkFooterState];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.parms != parame) return ;
             [self.tableViewRight.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        }];
    }];
}
/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState{
    LZGRecommendCategory *c = LZGSelectedCategory;
    self.tableViewRight.mj_footer.hidden = (c.users.count == 0);
        //            是否加载完毕
    if (c.users.count == c.total) {//显示全部加载完毕
        [self.tableViewRight.mj_footer endRefreshingWithNoMoreData];
    }else{
        //            让底部控件结束刷新
        [self.tableViewRight.mj_footer endRefreshing];
    }
}

- (void)registerNib{
    //    注册cell
    [self.tableViewLeft registerNib:[UINib nibWithNibName:NSStringFromClass([XMGRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:ID];
    [self.tableViewRight registerNib:[UINib nibWithNibName:NSStringFromClass([LZGRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:rightID];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewLeft) {
        return self.categories.count;
    }else{
        LZGRecommendCategory *c = LZGSelectedCategory;
        [self checkFooterState];
        return c.users.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewLeft) {
        XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{
        LZGRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
        LZGRecommendCategory *c = LZGSelectedCategory;
        if (c.users.count) {
            cell.user = c.users[indexPath.row];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewLeft) {
        //    结束刷新
        [self.tableViewRight.mj_header endRefreshing];
        [self.tableViewRight.mj_footer endRefreshing];
        
        LZGRecommendCategory *c = self.categories[indexPath.row];
        
        if (c.users.count > 0) {
            [self.tableViewRight reloadData];
        }else {
//            [self.tableViewRight reloadData];
            //        进入下拉刷新状态
            [self.tableViewRight.mj_header beginRefreshing];
        }
    }
}
/**
 *  控制器销毁时
 */
- (void)dealloc{
    [self.manger.operationQueue cancelAllOperations];
}
@end
