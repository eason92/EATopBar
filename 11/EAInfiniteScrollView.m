//
//  EAInfiniteScrollView.m
//  11
//
//  Created by imac on 15/10/15.
//  Copyright (c) 2015年 黄漪辰. All rights reserved.
//

#import "EAInfiniteScrollView.h"

@implementation EAInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bounds.size.height);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调用回到终点的方法
    [self recenterIfNecessary];
}

#pragma mark - 回到终点
- (void)recenterIfNecessary
{
    // 自身偏移量
    CGPoint currentOffset = self.contentOffset;
    // 自身的宽度
    CGFloat contentWidth = [self contentSize].width;
    // 自身宽度的x轴中心点
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    // 当前自身偏移量到中心点的距离
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    // 如果自身偏移量到中心点的距离大于1/4时,就重新设置变异量到中心点
    if (distanceFromCenter > contentWidth / 4.0f) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
    }
}

@end
