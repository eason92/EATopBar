//
//  EATopBar.m
//
//  Created by imac on 15/10/15.
//  Copyright (c) 2015年 黄漪辰. All rights reserved.
//

#import "EATopBar.h"

// 选中图片的宽高
const NSInteger selectViewWH = 32;


@implementation EATopBar

+ (instancetype)topBarWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<EATopBarDelegate>)delegate
{
    return [[self alloc] initWithFrame:frame titles:titles delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<EATopBarDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = delegate;
        
        // 1.创建topBar
        _topBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * .1)];
        [self addSubview:_topBar];
        
        //  1> 创建上面的按钮
        _titles = titles;
        NSInteger btnWidth = _topBar.frame.size.width / _titles.count;
        for (int i = 0; i < _titles.count; i++) {
            _button = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, _topBar.frame.size.height)];
            _button.tag = i + 8892;
            _button.backgroundColor = [UIColor whiteColor];
            [_button setTitle:_titles[i] forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            _button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [_button addTarget:self action:@selector(topBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:_button];
            if (i == 0) [self topBarButtonClick:_button];  // 设置刚进入时,第一个按钮为选中状态
        }
        
        //  2> 创建选中图片
        _selectView = [[UIImageView alloc] initWithFrame:CGRectMake((btnWidth - selectViewWH) / 2, _topBar.frame.size.height - selectViewWH, _topBar.frame.size.width / _titles.count, selectViewWH)];
        _selectView.image = [UIImage imageNamed:@"red_line_and_shadow@2x"];
        [_topBar addSubview:_selectView];
        
        
        // 2.创建主滑动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * .1, self.frame.size.width, self.frame.size.height * .9)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * titles.count, self.frame.size.height * .9);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        // 3.创建主滑动视图上的表视图
        for (int i = 0; i < _titles.count; i++) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, _scrollView.frame.size.height) style:UITableViewStylePlain];
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.tag = i + 902;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [_scrollView addSubview:_tableView];
        }
    }
    return self;
}

//#pragma mark - 给tableview网络请求数据
//- (void)requestNetworkData:(UITableView *)tableView url:(NSString *)url params:(NSMutableDictionary *)params
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       
//        // 刷新表视图
//        [tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败--%@", error);
//    }];
//}

#pragma mark - topBar上的按钮点击事件
- (void)topBarButtonClick:(UIButton *)button
{
    // 1.让选中图片在选中按钮下方
    [UIView animateWithDuration:.3 animations:^{
        float btnWidth = _topBar.frame.size.width / _titles.count;
        int page = button.tag - 8892;
        CGRect tempFrame = _selectView.frame;
        tempFrame.origin.x = (btnWidth - _selectView.frame.size.width) / 2 + page * btnWidth;
        _selectView.frame = tempFrame;
    }];
    
    // 2.点击按钮,实现控制器之间的切换
    _scrollView.contentOffset = CGPointMake((button.tag - 8892) * self.frame.size.width, 0);

    // 3.让选中的按钮变成红色字体
    //  先将之前选中的按钮设置为未选中
    _selectButton.selected = NO;
    //  再将当前按钮设置为选中
    button.selected = YES;
    //  最后把当前按钮赋值为之前选中的按钮
    _selectButton = button;
}

#pragma mark - 主视图滑动松手时监听topBar按钮状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 排除纵向滑动的情况
    if (scrollView.contentOffset.x == 0) return;

    [UIView animateWithDuration:.2 animations:^{
        // 1.选中按钮视图随着表视图更换而滚动
        float btnWidth = _topBar.frame.size.width / _titles.count;
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGRect tempFrame = _selectView.frame;
        tempFrame.origin.x = (btnWidth - _selectView.frame.size.width) / 2 + page * btnWidth;
        _selectView.frame = tempFrame;
        
        // 2.选中按钮随表视图更换而变为红色
        UIButton *button = (UIButton *)[_topBar viewWithTag:page + 8892];
        if (_selectButton != button) {      // 不判断这句会导致如果松手并未换页时,选按钮文字会变色的bug
            button.selected = YES;
            _selectButton.selected = NO;
            _selectButton = button;
        }
    }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.delegate respondsToSelector:@selector(eaNumberOfSectionsInTableView:)]) {
        return [self.delegate eaNumberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:numberOfRowsInSection:)]) {
        return [self.delegate eaTableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:cellForRowAtIndexPath:)]) {
        return [self.delegate eaTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate eaTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:heightForRowAtIndexPath:)]) {
        return [self.delegate eaTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:heightForHeaderInSection:)]) {
        return [self.delegate eaTableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:heightForFooterInSection:)]) {
        return [self.delegate eaTableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:viewForHeaderInSection:)]) {
        return [self.delegate eaTableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:viewForFooterInSection:)]) {
        return [self.delegate eaTableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:titleForHeaderInSection:)]) {
        return [self.delegate eaTableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(eaTableView:titleForFooterInSection:)]) {
        return [self.delegate eaTableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

@end
