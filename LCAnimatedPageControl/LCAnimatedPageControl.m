//
//  LCAnimatedPageControl.m
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "LCAnimatedPageControl.h"

@interface LCAnimatedPageControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pointViews;
@property (nonatomic, strong) UIView *lastAnimationView;
@property (nonatomic, assign) BOOL isFirst;

@end


@implementation LCAnimatedPageControl

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _isFirst = YES;
    _pointViews = [NSMutableArray array];
    _numberOfPages = 0;
    _currentPage = 0;
    _pageIndicatorColor = [UIColor whiteColor];
    _currentPageIndicatorColor = [UIColor blackColor];
    _indicatorMultiple = 2.0f;
    _indicatorDiameter = self.frame.size.height / _indicatorMultiple;
    _indicatorMargin = 0.0f;
}



//- (void)setNumberOfPages:(NSUInteger)numberOfPages{
//    _numberOfPages = numberOfPages;
//    CGFloat itemWidth = self.frame.size.height/_indicatorMultiple;
//    CGFloat indicatorMargin = (self.frame.size.width - (_numberOfPages * itemWidth))/(_numberOfPages * 2);
//    for (NSInteger number; number < _numberOfPages; number ++ ) {
//        UIView *point = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / _numberOfPages), 0, 0, itemWidth)];
//    }
//}


- (void)show{
    CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewWidth, _indicatorDiameter *_indicatorMultiple);
    CGFloat halfDiameter = _indicatorDiameter * 0.5f;
    for (NSInteger number = 0; number < _numberOfPages; number ++ ) {
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _indicatorDiameter, _indicatorDiameter)];
        point.clipsToBounds = YES;
        point.layer.cornerRadius = halfDiameter;
        point.backgroundColor = _pageIndicatorColor;
        point.center = CGPointMake(self.frame.size.height * 0.5 + number * _indicatorDiameter * _indicatorMultiple + _indicatorMargin * number, self.frame.size.height * 0.5f);
        [self addAnimation:point];
        [self addSubview:point];
        [self.pointViews addObject:point];
    }
    
    
    [self.sourceScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *pointView = self.pointViews[self.currentPage];
        pointView.layer.timeOffset = 1.0f;
    });
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (_isFirst) {
        self.isFirst = NO;
        return;
    }
    NSValue *offsetValue = change[NSKeyValueChangeNewKey];
    CGPoint offset = [offsetValue CGPointValue];
    CGFloat rate = offset.x / _sourceScrollView.bounds.size.width;
    if (rate >= 0.0f && rate <= _sourceScrollView.contentSize.width/_sourceScrollView.bounds.size.width - 1.0f) {
        
        NSUInteger currentIndex = (NSUInteger)ceilf(rate);
        NSUInteger lastIndex = (NSUInteger)floorf(rate);
        if (currentIndex == lastIndex && currentIndex >= 1) {
            lastIndex -= 1;
        }
        UIView *currentPointView = self.pointViews[currentIndex];
        UIView *lastPointView = self.pointViews[lastIndex];
        
        CGFloat timeOffset = rate - floorf(rate);
        if (timeOffset == 0.0f && currentIndex) {
            timeOffset = 1.0f;
        }
        currentPointView.layer.timeOffset = timeOffset;
        lastPointView.layer.timeOffset = 1.0f - timeOffset;
    }
}


- (void)addAnimation:(UIView *)view{
    CABasicAnimation *changeColor =  [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[self.pageIndicatorColor CGColor];
    changeColor.toValue   = (id)[self.currentPageIndicatorColor CGColor];
    changeColor.duration  = 1.0;
    changeColor.removedOnCompletion = NO;
    [view.layer addAnimation:changeColor forKey:@"Change color"];
    
    CABasicAnimation *changeScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    changeScale.fromValue = @1.0f;
    changeScale.toValue = @(_indicatorMultiple);
    changeScale.duration  = 1.0;
    changeScale.removedOnCompletion = NO;
    [view.layer addAnimation:changeScale forKey:@"Change scale"];
    
    view.layer.speed = 0.0;
}


@end
