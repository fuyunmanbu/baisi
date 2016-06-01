//
//  LZGRecommendTagsController.m
//  百思不得姐
//
//  Created by 浮云漫步 on 16/5/20.
//  Copyright © 2016年 iphone. All rights reserved.
//

#import "LZGRecommendTagsController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "LZGRecommendTag.h"
#import "LZGRecommindTagCell.h"
@interface LZGRecommendTagsController ()
@property(nonatomic,strong)NSArray *tags;
@end
static NSString * const ID = @"tag";
@implementation LZGRecommendTagsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [self setTable];
    [self loadShuju];
}

- (void)loadShuju{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"a"] = @"tag_recommend";
    dict[@"c"] = @"topic";
    dict[@"action"] = @"sub";
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        self.tags = [LZGRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求参数错误！"];
    }];
}

- (void)setTable{
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor = LZGlogRGB;
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LZGRecommindTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZGRecommindTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.recommend = self.tags[indexPath.row];
    return cell;
}

@end
