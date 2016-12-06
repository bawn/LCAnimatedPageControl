//
//  IndicatorView.m
//  LCAnimatedPageControl
//
//  Created by beike on 8/14/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView


- (instancetype)init{
    self = [super init];
    if (self) {
        _frontView = [[UIView alloc] init];
        _backView = [[UIView alloc] init];
        _frontView.translatesAutoresizingMaskIntoConstraints = NO;
        _backView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backView];
        [self addSubview:_frontView];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_frontView, _backView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_frontView]-0-|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_frontView]-0-|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backView]-0-|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backView]-0-|" options:0 metrics:nil views:viewsDictionary]];

    }
    return self;
}

@end
