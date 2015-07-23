//
//  LCAnimatedPageControl.m
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "LCAnimatedPageControl.h"

static CGFloat kLCDoubleNumber = 2.0f;
static CGFloat kLCHalfNumber = 0.5f;

@interface LCAnimatedPageControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *indicatorViews;
@property (nonatomic, strong) NSMutableArray *indicatorCons;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isDefaultSet;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) NSLayoutConstraint *contentWidthCon;
@property (nonatomic, strong) NSLayoutConstraint *squirmCenterCon;
@property (nonatomic, strong) NSLayoutConstraint *squirmWidthCon;
@property (nonatomic, strong) UIView *squirmView;

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
    
    _contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
                           ]];
    _indicatorViews = [NSMutableArray array];
    _indicatorCons = [NSMutableArray array];
    _numberOfPages = 0;
    _currentPage = 0;
    _pageIndicatorColor = [UIColor orangeColor];
    _currentPageIndicatorColor = [UIColor blackColor];
    _indicatorMultiple = 1.0f;
    _indicatorDiameter = self.frame.size.height / _indicatorMultiple;
    _indicatorMargin = 0.0f;
    _radius = _indicatorDiameter * kLCHalfNumber;
}

- (void)prepareShow{


    [self addIndicatorsWithIndex:0];
    [self.sourceScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
    self.contentWidthCon = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:viewWidth];
    [self.contentView addConstraint:_contentWidthCon];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:_indicatorDiameter * _indicatorMultiple]];
   
    if (_pageStyle == ScaleColorPageStyle) {
        [self setDefaultIndicator];
    }
    else if (_pageStyle == DepthColorPageStyle){
        [self.indicatorViews.firstObject setBackgroundColor:_currentPageIndicatorColor];
        [self.contentView bringSubviewToFront:self.indicatorViews.firstObject];
    }
    else if(_pageStyle == SquirmPageStyle){
        self.squirmView = [[UIView alloc] init];
        self.squirmView.translatesAutoresizingMaskIntoConstraints = NO;
        self.squirmView .clipsToBounds = YES;
        self.squirmView .layer.cornerRadius = _radius;
        self.squirmView .backgroundColor = _currentPageIndicatorColor;
        [self.contentView addSubview:_squirmView];
        
        [self layoutSquirmView];
    }
}


- (void)clearIndicators{
    for (UIView *view in _indicatorViews) {
        if (view.layer.timeOffset < 1.0f) {
            view.layer.timeOffset = 0.0f;
        }
    }
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter{
    _indicatorDiameter = indicatorDiameter;
    self.radius = _indicatorDiameter * kLCHalfNumber;
}

- (void)addIndicatorsWithIndex:(NSInteger)index{
    for (NSInteger number = index; number < _numberOfPages; number ++ ) {
        UIView *point = [[UIView alloc] init];
        point.clipsToBounds = YES;
        point.layer.cornerRadius = _radius;
        point.backgroundColor = _pageIndicatorColor;
        [self.contentView addSubview:point];
        [self.indicatorViews addObject:point];
        if (_pageStyle == ScaleColorPageStyle) {
            [self configCSAnimation:point];
        }
        else if(_pageStyle == DepthColorPageStyle){
            if (number == 0) {
                [self configScaleAnimation:point];
            }
            else{
                [self configSmallScaleAnimation:point];
            }
        }
    }
    [self layoutContentView];
}


- (void)removeIndicatorsWithNumber:(NSInteger)number{
    
    NSArray *array = [self.indicatorViews subarrayWithRange:NSMakeRange(0, ABS(number))];
    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.indicatorViews removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, ABS(number))]];
    [self layoutContentView];
}



- (void)setCurrentPage:(NSInteger)currentPage{
    [self setCurrentPage:currentPage sendEvent:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent{
    _currentPage = MIN(currentPage, _numberOfPages - 1);
    if (sendEvent) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    numberOfPages = MAX(0, numberOfPages);
    NSInteger difference  = numberOfPages - _numberOfPages;
    NSInteger lastNumberPages = _numberOfPages;
    _numberOfPages = numberOfPages;
    if (difference && self.superview) {
        [self.contentView removeConstraints:_contentView.constraints];
        // remove
        if (difference < 0) {
            if (_currentPage != lastNumberPages - 1) {
                UIView *view = self.indicatorViews[_currentPage];
                view.layer.timeOffset = 0.0f;
            }
            if (_currentPage > _numberOfPages - 1) {
                _currentPage = _numberOfPages - 1;
            }
            [self removeIndicatorsWithNumber:difference];
        }
        // add
        else{
            [self addIndicatorsWithIndex:lastNumberPages];
        }
        [self resetContentLayout];
        if (_pageStyle == ScaleColorPageStyle) {
            [self setDefaultIndicator];
        }
        if (_pageStyle == DepthColorPageStyle) {
            [self configDepthView];
            [self setDefaultIndicator];
        }
    }
}


- (void)resetContentLayout{
    if (_numberOfPages) {
        CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
        self.contentWidthCon = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:viewWidth];
        [self.contentView addConstraint:_contentWidthCon];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:_indicatorDiameter * _indicatorMultiple]];
    }
    if (_pageStyle == SquirmPageStyle) {
        [self layoutSquirmView];
    }
}


- (void)configDepthView{
    UIView *depthView = self.indicatorViews.firstObject;
    [depthView.layer removeAllAnimations];
    [self.indicatorViews.firstObject setBackgroundColor:_currentPageIndicatorColor];
    [self.contentView bringSubviewToFront:self.indicatorViews.firstObject];
    [self configScaleAnimation:depthView];
    
    for (NSInteger index = 1; index <= _currentPage; index ++) {
        NSLayoutConstraint *con = self.indicatorCons[index];
        con.constant = (_indicatorDiameter * _indicatorMultiple * kLCHalfNumber) + (index - 1) * (_indicatorDiameter * _indicatorMultiple + _indicatorMargin);
    }
}


- (void)setDefaultIndicator{
    self.isDefaultSet = YES;
    if (self.indicatorViews.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGPoint offset = self.sourceScrollView.contentOffset;
            CGFloat rate = offset.x / self.sourceScrollView.bounds.size.width;
            NSInteger currentIndex = (NSInteger)ceilf(rate);
            if (currentIndex > self.numberOfPages - 1) {
                currentIndex --;
            }
            UIView *pointView = self.indicatorViews[currentIndex];
            self.currentPage = currentIndex;
            if (_pageStyle == ScaleColorPageStyle) {
                pointView.layer.timeOffset = 1.0f;
            }
            else if (_pageStyle == DepthColorPageStyle){
                pointView.layer.timeOffset = 0.0f;
            }
            self.isDefaultSet = NO;
        });
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSValue *oldOffsetValue = change[NSKeyValueChangeOldKey];
    CGPoint oldOffset = [oldOffsetValue CGPointValue];
    
    NSValue *newOffsetValue = change[NSKeyValueChangeNewKey];
    CGPoint newOffset = [newOffsetValue CGPointValue];
    
    CGFloat scrollViewWidth = [(UIScrollView *)object bounds].size.width;
    
    CGFloat rate = newOffset.x / scrollViewWidth;
    if (rate >= 0.0f && rate <= _numberOfPages - 1) {
        
        NSInteger currentIndex = (NSInteger)ceilf(rate);
        NSInteger lastIndex = (NSInteger)floorf(rate);
        if (currentIndex == lastIndex && currentIndex >= 1) {
            lastIndex -= 1;
        }
        
        UIView *currentPointView = self.indicatorViews[currentIndex];
        UIView *lastPointView = self.indicatorViews[lastIndex];
        CGFloat timeOffset = rate - floorf(rate);
        if (timeOffset == 0.0f && currentIndex) {
            timeOffset = 1.0f;
        }
        
        if (_pageStyle == ScaleColorPageStyle) {
            if (!_sourceScrollView.decelerating && _isDefaultSet) {
                return;
            }
            if ((NSInteger)newOffset.x % (NSInteger)scrollViewWidth == 0 &&
                (NSInteger)oldOffset.x % (NSInteger)scrollViewWidth == 0 &&
                newOffset.x != oldOffset.x &&
                (NSInteger)ABS(newOffset.x - oldOffset.x)) {
                    
                CGFloat oldRate = oldOffset.x / scrollViewWidth;
                lastIndex = (NSInteger)ceilf(oldRate);
                if (lastIndex <= _numberOfPages - 1) {
                    lastPointView = self.indicatorViews[lastIndex];
                    currentPointView.layer.timeOffset = 1.0f;
                    lastPointView.layer.timeOffset = 0.0f;
                    self.currentPage = currentIndex;
                }
                return;
            }
            currentPointView.layer.timeOffset = timeOffset;
            lastPointView.layer.timeOffset = 1.0f - timeOffset;
           
        }
        else if (_pageStyle == DepthColorPageStyle){
            UIView *lastPointView = self.indicatorViews.firstObject;
            lastIndex = 0;
            CGFloat halfTimeOffset = 0.0f;
            if (timeOffset - kLCHalfNumber <= 0.0f) {
                halfTimeOffset = timeOffset * kLCDoubleNumber;
            }
            else{
                halfTimeOffset = (CGFloat)ABS(timeOffset - 1.0f) * kLCDoubleNumber;
            }
           
            currentPointView.layer.timeOffset = halfTimeOffset;
            lastPointView.layer.timeOffset = halfTimeOffset;
            NSLayoutConstraint *currentCon = self.indicatorCons[currentIndex];
            NSLayoutConstraint *lastCon = self.indicatorCons[lastIndex];
            currentCon.constant = (_indicatorDiameter * _indicatorMultiple * kLCHalfNumber) + (currentIndex - timeOffset) * (_indicatorDiameter * _indicatorMultiple + _indicatorMargin);
            lastCon.constant = (_indicatorDiameter * _indicatorMultiple * kLCHalfNumber) + (timeOffset + (currentIndex ? : 1 ) - 1) * (_indicatorDiameter * _indicatorMultiple + _indicatorMargin);
            
        }
        else if (_pageStyle == SquirmPageStyle){
            
            if (timeOffset - kLCHalfNumber <= 0.0f) {
                timeOffset = timeOffset * kLCDoubleNumber;
            }
            else{
                timeOffset = (CGFloat)ABS(timeOffset - 1.0f) * kLCDoubleNumber;
            }
            CGFloat number = (_indicatorMargin - _indicatorDiameter) * kLCHalfNumber;
            self.squirmCenterCon.constant = rate  * kLCDoubleNumber * (_indicatorMargin - number) + _indicatorDiameter * kLCHalfNumber;
            self.squirmWidthCon.constant = timeOffset * (_indicatorDiameter + _indicatorMargin);
            
        }
        self.currentPage = currentIndex;
    }
    
}


- (void)layoutSquirmView{
    [self.contentView bringSubviewToFront:_squirmView];
    self.squirmView.hidden = !_numberOfPages;
    self.squirmCenterCon = [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-_indicatorDiameter * kLCHalfNumber];
    [self.contentView addConstraints:@[
                                       self.squirmCenterCon,
                                       [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
                                       ]];
    if (!_squirmWidthCon) {
        [self.squirmView addConstraint:[NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:self.indicatorDiameter]];
        
        self.squirmWidthCon = [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.squirmView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        [self.squirmView addConstraint:self.squirmWidthCon];
    }
}


- (void)layoutContentView{
    [self.indicatorCons removeAllObjects];
    [self.indicatorViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view removeConstraints:view.constraints];
        // size
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_indicatorDiameter]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        
        // position
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        NSLayoutConstraint *con = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:(_indicatorDiameter * _indicatorMultiple * kLCHalfNumber) + idx * (_indicatorDiameter * _indicatorMultiple + _indicatorMargin)];
        [self.indicatorCons addObject:con];
        [self.contentView addConstraint:con];
    }];
    
}


- (void)configCSAnimation:(UIView *)view{
    [self configColorAnimation:view];
    [self configScaleAnimation:view];
}


- (void)configColorAnimation:(UIView *)view{
    CABasicAnimation *changeColor =  [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[self.pageIndicatorColor CGColor];
    changeColor.toValue   = (id)[self.currentPageIndicatorColor CGColor];
    changeColor.duration  = 1.0;
    changeColor.removedOnCompletion = NO;
    [view.layer addAnimation:changeColor forKey:@"Change color"];
    view.layer.speed = 0.0;
}

- (void)configScaleAnimation:(UIView *)view{
    CABasicAnimation *changeScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    changeScale.fromValue = @1.0f;
    changeScale.toValue = @(_indicatorMultiple);
    changeScale.duration  = 1.0;
    changeScale.removedOnCompletion = NO;
    [view.layer addAnimation:changeScale forKey:@"Change scale"];
    view.layer.speed = 0.0;
}

- (void)configSmallScaleAnimation:(UIView *)view{
    CABasicAnimation *changeScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    changeScale.fromValue = @1.0f;
    changeScale.toValue = @(1/_indicatorMultiple);
    changeScale.duration  = 1.0;
    changeScale.removedOnCompletion = NO;
    [view.layer addAnimation:changeScale forKey:@"Change cale small"];
    view.layer.speed = 0.0;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    CGFloat multipleRadius = _indicatorMultiple * _indicatorDiameter * (1 + kLCHalfNumber) + _indicatorMargin;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    
    NSInteger pageNumber = (NSInteger)ceilf((point.x / multipleRadius));
    if (pageNumber > _currentPage) {
        self.currentPage++;
    }
    else{
        if (_currentPage) {
            self.currentPage--;
        }
    }
    [self setCurrentPage:_currentPage sendEvent:YES];
}


- (void)dealloc{
    [self.sourceScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
