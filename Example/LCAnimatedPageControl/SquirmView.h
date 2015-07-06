//
//  SquirmView.h
//  LCAnimatedPageControl
//
//  Created by beike on 7/6/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquirmView : UIView

@property (nonatomic, strong) CALayer *boundsLayer;

- (instancetype)initWithColor:(UIColor *)color;

@end
