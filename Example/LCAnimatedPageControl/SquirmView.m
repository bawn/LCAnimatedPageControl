//
//  SquirmView.m
//  LCAnimatedPageControl
//
//  Created by beike on 7/6/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "SquirmView.h"

@implementation SquirmView


- (instancetype)initWithColor:(UIColor *)color{
    self = [super init];
    if (self) {
       
        self.boundsLayer = [CALayer layer];
        self.boundsLayer.frame = self.layer.bounds;
        self.boundsLayer.backgroundColor = [color CGColor];
        [self.layer addSublayer:_boundsLayer];
        
    }
    return self;
}

@end
