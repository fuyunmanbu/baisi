//
//  XMGSettingViewController.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGSettingViewController.h"
#import <SDImageCache.h>

@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = LZGlogRGB;
}

- (void)getSize2
{
    // 图片缓存
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    //    XMGLog(@"%zd %@", size, NSTemporaryDirectory());
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];

    
    // 获得文件夹内部的所有内容名称，不包括内部文件夹
    //    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    // 获得文件夹内部的所有内容名称，包括内部文件夹
    NSArray *subpaths = [manager subpathsAtPath:cachePath];
    LZGLog(@"%@", subpaths);
}

- (void)getSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
//        fileName是文件名
        NSString *filepath = [cachePath stringByAppendingPathComponent:fileName];
        
//        BOOL dir = NO;
// 判断文件的类型：文件\文件夹
//        [manager fileExistsAtPath:filepath isDirectory:&dir];
//        if (dir) continue;
        NSDictionary *attrs = [manager attributesOfItemAtPath:filepath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totalSize += [attrs[NSFileSize] integerValue];
    }
    LZGLog(@"%zd", totalSize);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（已使用%.2fMB）", size];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[SDImageCache sharedImageCache] clearDisk];
    
//    [[NSFileManager defaultManager] removeItemAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>];
    [tableView reloadData];
}

@end
