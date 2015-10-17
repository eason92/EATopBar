//
//  EATopBar.h
//
//  Created by imac on 15/10/15.
//  Copyright (c) 2015年 黄漪辰. All rights reserved.
//

/* 
 自定义屏幕上方的选择条+下面带左右滑动功能的表视图
 
 用法: 1.导入类,引用头文件,遵守协议
      2.初始化:先建立一个按钮文字的数组,直接在控制器中调用初始化方法,把数组传给参数即可
      3.可以任意修改表视图内容,方法跟原生方法一样,只是都以"eaTable"开头(不用设置代理,初始化时已经传入代理对象参数)
 */
#import <UIKit/UIKit.h>

@protocol EATopBarDelegate <NSObject>

/** 每行的cell个数 */
- (NSInteger)eaTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
/** 创建cell */
- (UITableViewCell *)eaTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/** 每组的行数 */
- (NSInteger)eaNumberOfSectionsInTableView:(UITableView *)tableView;
/** 点击cell */
- (void)eaTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/** cell的高度 */
- (CGFloat)eaTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/** 头视图的高度 */
- (CGFloat)eaTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
/** 尾视图的高度 */
- (CGFloat)eaTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
/** 头视图的内容 */
- (UIView *)eaTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
/** 尾视图的内容 */
- (UIView *)eaTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
/** 头视图的文字内容 */
- (NSString *)eaTableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
/** 尾视图的文字内容 */
- (NSString *)eaTableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

@end


@interface EATopBar : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 顶部选择条topBar */
@property (nonatomic, strong) UIScrollView *topBar;
/** 顶部选择条上的按钮(tag:8892) */
@property (nonatomic, strong) UIButton *button;
/** 之前选中的按钮 */
@property (nonatomic, strong) UIButton *selectButton;
/** 选中按钮的标注图片 */
@property (nonatomic, strong) UIImageView *selectView;
/** 按钮的title数组 */
@property (nonatomic, strong, readonly) NSArray *titles;

/** 主滑动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 主视图中的每个表视图(tag:902) */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源方法 */
@property (nonatomic, weak) id<EATopBarDelegate> delegate;


/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<EATopBarDelegate>)delegate;
+ (instancetype)topBarWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<EATopBarDelegate>)delegate;

@end
