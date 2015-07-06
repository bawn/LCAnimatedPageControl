//
//  LCAnimatedPageControl.m
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "LCAnimatedPageControl.h"
//#import "SquirmView.h"

@interface LCAnimatedPageControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *indicatorViews;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isDefaultSet;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) NSLayoutConstraint *contentWidthCon;
@property (nonatomic, strong) NSLayoutConstraint *squirmCenterCon;
@property (nonatomic, strong) NSLayoutConstraint *squirmWidthCon;
@property (nonatomic, strong) UIView *squirmView;
//@property (nonatomic, assign) BOOL isAutoLayout;
//@property (nonatomic, strong) UIView *single`;

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
//    _isAutoLayout = !self.superview.translatesAutoresizingMaskIntoConstraints;
//    if (_isAutoLayout) {
    
        _contentView = [[UIView alloc] init];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
                               ]];
//    }
//    else{
//        _contentView = [[UIView alloc] initWithFrame:self.frame];
//        [self addSubview:_contentView];
//
//    }
    _indicatorViews = [NSMutableArray array];
    _numberOfPages = 0;
    _currentPage = 0;
    _pageIndicatorColor = [UIColor orangeColor];
    _currentPageIndicatorColor = [UIColor blackColor];
    _indicatorMultiple = 1.0f;
    _indicatorDiameter = self.frame.size.height / _indicatorMultiple;
    _indicatorMargin = 0.0f;
    _radius = _indicatorDiameter * 0.5f;
    
//    self.contentView.backgroundColor = [UIColor blackColor];
}


- (void)prepareShow{

    [self addIndicatorsWithIndex:0];
    [self.sourceScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    

    //    if (_isAutoLayout) {
    CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
    self.contentWidthCon = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:viewWidth];
    [self.contentView addConstraint:_contentWidthCon];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:_indicatorDiameter * _indicatorMultiple]];
    //    }

    
    if (_pageStyle == SclaePageStyle) {
        [self setDefaultIndicator];
    }
    else if(_pageStyle == SquirmPageStyle){
        self.squirmView = [[UIView alloc] init];
        self.squirmView.translatesAutoresizingMaskIntoConstraints = NO;
        self.squirmView .clipsToBounds = YES;
        self.squirmView .layer.cornerRadius = _radius;
        self.squirmView .backgroundColor = _currentPageIndicatorColor;
        [self.contentView addSubview:_squirmView];
        
        self.squirmCenterCon = [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-_indicatorDiameter * 0.5f];
        self.squirmWidthCon = [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:self.indicatorDiameter];
        [self.contentView addConstraints:@[
                                           self.squirmCenterCon,
                                           [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]
                                           ]];
        
        [self.squirmView addConstraint:[NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:self.indicatorDiameter]];
        self.squirmWidthCon = [NSLayoutConstraint constraintWithItem:self.squirmView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.squirmView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        [self.squirmView addConstraint:self.squirmWidthCon];
        [self.contentView layoutIfNeeded];
//        [self configBPAnimation:_squirmView];
        
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
    self.radius = _indicatorDiameter * 0.5f;
}

- (void)addIndicatorsWithIndex:(NSInteger)index{
    for (NSInteger number = index; number < _numberOfPages; number ++ ) {
        UIView *point = nil;
//        if (_isAutoLayout) {
            point =[[UIView alloc] init];
//        }
//        else{
//            point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _indicatorDiameter, _indicatorDiameter)];
//        }
        point.clipsToBounds = YES;
        point.layer.cornerRadius = _radius;
        point.backgroundColor = _pageIndicatorColor;
        [self.contentView addSubview:point];
        [self.indicatorViews addObject:point];
        [self configCSAnimation:point];
    }
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
        // remove
        if (difference < 0) {
            if (_currentPage != lastNumberPages - 1) {
                UIView *view = self.indicatorViews[_currentPage];
                view.layer.timeOffset = 0.0f;
            }
            NSArray *array = [self.indicatorViews subarrayWithRange:NSMakeRange(0, ABS(difference))];
            [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.indicatorViews removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, ABS(difference))]];
            [self.contentView removeConstraints:_contentView.constraints];
            [self layoutContentView];
        }
        // add
        else{
            [self.contentView removeConstraints:_contentView.constraints];
            [self addIndicatorsWithIndex:lastNumberPages];
        }
        [self resetContentLayout];
        [self setDefaultIndicator];
    }
}


- (void)resetContentLayout{
//    if (_isAutoLayout) {
        if (_numberOfPages) {
            CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
            self.contentWidthCon = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:viewWidth];
            [self.contentView addConstraint:_contentWidthCon];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:_indicatorDiameter * _indicatorMultiple]];
        }
//    }
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
            pointView.layer.timeOffset = 1.0f;
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
        
        if (_pageStyle == SclaePageStyle) {
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
            self.currentPage = currentIndex;
        }
        else if (_pageStyle == SquirmPageStyle){
//            NSLog(@"%f", ABS(timeOffset - 0.5));
            CGFloat newOffset;
            if (timeOffset - 0.5 <= 0.0f) {
                newOffset = timeOffset*2;
            }
            else if (timeOffset - 0.5){
                newOffset = ABS(timeOffset - 1.0f)*2;
            }
            NSLog(@"%f", newOffset);
//            self.squirmView.layer.timeOffset = timeOffset;
            self.squirmCenterCon.constant = timeOffset  * 2* (_indicatorMargin - _indicatorDiameter * 0.5f) + _indicatorDiameter * 0.5f;
            self.squirmWidthCon.constant = newOffset * (_indicatorDiameter + _indicatorMargin);
        }
    }

    
//    if (_pageStyle == SclaePageStyle) {
//        
//        NSValue *oldOffsetValue = change[NSKeyValueChangeOldKey];
//        CGPoint oldOffset = [oldOffsetValue CGPointValue];
//        
//        NSValue *newOffsetValue = change[NSKeyValueChangeNewKey];
//        CGPoint newOffset = [newOffsetValue CGPointValue];
//        
//        CGFloat scrollViewWidth = [(UIScrollView *)object bounds].size.width;
//        
//        CGFloat rate = newOffset.x / scrollViewWidth;
//        if (rate >= 0.0f && rate <= _numberOfPages - 1) {
//            
//            NSInteger currentIndex = (NSInteger)ceilf(rate);
//            NSInteger lastIndex = (NSInteger)floorf(rate);
//            if (currentIndex == lastIndex && currentIndex >= 1) {
//                lastIndex -= 1;
//            }
//            UIView *currentPointView = self.indicatorViews[currentIndex];
//            UIView *lastPointView = self.indicatorViews[lastIndex];
//            
//            if ((NSInteger)newOffset.x % (NSInteger)scrollViewWidth == 0 &&
//                (NSInteger)oldOffset.x % (NSInteger)scrollViewWidth == 0 &&
//                newOffset.x != oldOffset.x &&
//                (NSInteger)ABS(newOffset.x - oldOffset.x)) {
//                
//                CGFloat oldRate = oldOffset.x / scrollViewWidth;
//                lastIndex = (NSInteger)ceilf(oldRate);
//                if (lastIndex <= _numberOfPages - 1) {
//                    lastPointView = self.indicatorViews[lastIndex];
//                    currentPointView.layer.timeOffset = 1.0f;
//                    lastPointView.layer.timeOffset = 0.0f;
//                    self.currentPage = currentIndex;
//                }
//                return;
//            }
//            
//            CGFloat timeOffset = rate - floorf(rate);
//            if (timeOffset == 0.0f && currentIndex) {
//                timeOffset = 1.0f;
//            }
//            currentPointView.layer.timeOffset = timeOffset;
//            lastPointView.layer.timeOffset = 1.0f - timeOffset;
//            self.currentPage = currentIndex;
//        }
//    }
//    else if (_pageStyle == SquirmPageStyle){
//        
//    }
}



- (void)layoutContentView{
//    if (self.isAutoLayout) {
        [self.indicatorViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [view removeConstraints:view.constraints];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_indicatorDiameter]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
            
            if (idx) {
                UIView *lastView = self.indicatorViews[idx - 1];
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:_indicatorMargin + _indicatorMultiple * _indicatorDiameter]];
            }
            else{
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:_indicatorDiameter * _indicatorMultiple * 0.5f]];
                
            }
        }];
//    }
//    else{
//        [self.indicatorViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
//            CGFloat centerX = 0.0f;
//            if (idx) {
//                UIView *lastView = self.indicatorViews[idx - 1];
//                centerX += lastView.center.x + _indicatorDiameter * _indicatorMultiple + _indicatorMargin;
//            }
//            else{
//                centerX = _indicatorDiameter * _indicatorMultiple * 0.5;
//            }
//            view.center = CGPointMake(centerX, self.frame.size.height * 0.5f);
//        }];
//        
//        CGFloat viewWidth = (_indicatorDiameter * _indicatorMultiple) * _numberOfPages + (_numberOfPages - 1) * _indicatorMargin;
//        self.contentView.frame = CGRectMake(0, 0, viewWidth, self.frame.size.height);
//        self.contentView.center = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
//    }
}



- (void)configCSAnimation:(UIView *)view{
    [self configColorAnimation:view];
    [self configScaleAnimation:view];
}

- (void)configBPAnimation:(UIView *)view{
    [self configBoundsAnimation:view];
    [self configPositionAnimation:view];
}

- (void)configColorAnimation:(UIView *)view{
    CABasicAnimation *changeColor =  [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[self.pageIndicatorColor CGColor];
    changeColor.toValue   = (id)[self.currentPageIndicatorColor CGColor];
    changeColor.duration  = 1.0;
    changeColor.removedOnCompletion = NO;
    [view.layer addAnimation:changeColor forKey:@"Change color"];
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


- (void)configBoundsAnimation:(UIView *)view{
    CABasicAnimation *changeBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
    changeBounds.fromValue = [NSValue valueWithCGRect:view.bounds];
    changeBounds.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, view.bounds.size.width + _indicatorMargin + _indicatorDiameter, view.bounds.size.height)];
    changeBounds.duration  = 1.0;
    changeBounds.removedOnCompletion = NO;
    [view.layer addAnimation:changeBounds forKey:@"bounds"];
    view.layer.speed = 0.0;
    
//    view.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
//    view.layer.position = CGPointMake(view.layer.position.x - view.frame.size.width / 2, view.layer.position.y);
}


- (void)configPositionAnimation:(UIView *)view{
    
    CABasicAnimation *changePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    changePosition.fromValue = [NSValue valueWithCGPoint:view.center];
    changePosition.toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x + _indicatorMargin + _indicatorDiameter, view.center.y)];
    changePosition.duration  = 1.0;
    changePosition.removedOnCompletion = NO;
    [view.layer addAnimation:changePosition forKey:@"position"];
    view.layer.speed = 0.0;
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    CGFloat multipleRadius = _indicatorMultiple * 0.5 * _indicatorDiameter;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    UIView *pointView = _indicatorViews[_currentPage];
    if (point.x > pointView.center.x + multipleRadius) {
        self.currentPage++;
    }
    else if (point.x < pointView.center.x  - multipleRadius){
        self.currentPage--;
    }
    [self setCurrentPage:_currentPage sendEvent:YES];
}


- (void)dealloc{
    [self.sourceScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
