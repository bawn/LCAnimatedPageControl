//
//  LCAnimatedPageControl.h
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageStyle){
    LCScaleColorPageStyle,
    LCSquirmPageStyle,
    LCDepthColorPageStyle,
    LCFillColorPageStyle,
};

@interface LCAnimatedPageControl : UIControl

@property (nonatomic, strong) UIScrollView *sourceScrollView;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) UIColor *pageIndicatorColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;
@property (nonatomic, assign) CGFloat indicatorMultiple;
@property (nonatomic, assign) CGFloat indicatorMargin;
@property (nonatomic, assign) CGFloat indicatorDiameter;
@property (nonatomic, assign) PageStyle pageStyle;
@property (nonatomic, assign, readonly) NSInteger currentPage;

- (void)prepareShow;
- (void)clearIndicators;

@end
