//
//  LCAnimatedPageControl.h
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAnimatedPageControl : UIView

@property (nonatomic, strong) UIScrollView *sourceScrollView;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, strong) UIColor *pageIndicatorColor;// 普通状态的颜色
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;// 当前状态下的颜色
@property (nonatomic, assign) CGFloat indicatorMultiple;// 放大倍数
@property (nonatomic, assign) CGFloat indicatorMargin;// 点之间的间隔
@property (nonatomic, assign) CGFloat indicatorDiameter;// 点的直径
@property (nonatomic, assign) NSUInteger currentPage;// 当前显示的

- (void)show;

@end
