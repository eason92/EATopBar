//
//  ViewController.m
//  11
//
//  Created by imac on 15/10/15.
//  Copyright (c) 2015年 黄漪辰. All rights reserved.
//

#import "ViewController.h"
#import "EATopBar.h"
#import "EAInfiniteScrollView.h"

@interface ViewController () <EATopBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建topBar
    NSArray *titles = @[@"范德萨", @"111", @"0", @"说",@"法是打发"];
    EATopBar *topBar = [[EATopBar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49) titles:titles delegate:self];
    [self.view addSubview:topBar];
    
    // 设置按钮的背景颜色(通过按钮的tag值循环取出按钮,再设置)
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = (UIButton *)[topBar viewWithTag:topBar.button.tag - i];
        button.backgroundColor = [UIColor cyanColor];
    }
    
    EAInfiniteScrollView *scrollView = [[EAInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 100, 500, 100)];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
}

- (NSInteger)eaTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 903) {
        return 5;
    } else {
        return 10;
    }
}

- (UITableViewCell *)eaTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"eee";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (tableView.tag == 902) {
        cell.textLabel.text = @"2222";
    } else {
        cell.textLabel.text = @"111";
    }
    
    return cell;
}

- (UIView *)eaTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"已加载所有数据";
    footerLabel.textColor = [UIColor darkGrayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:13];
    return footerLabel;
}

- (CGFloat)eaTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

@end
