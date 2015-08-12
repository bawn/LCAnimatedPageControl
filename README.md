# LCAnimatedPageControl

![License MIT](https://img.shields.io/dub/l/vibe-d.svg)
![Pod version](http://img.shields.io/cocoapods/v/LCAnimatedPageControl.svg?style=flat)
![Platform info](http://img.shields.io/cocoapods/p/LCAnimatedPageControl.svg?style=flat)


Custom UIPageControl with a simple animation, Support AtuoLayout.

##Demo

**SquirmPageStyle**

![1](demo1.gif)

**ScaleColorPageStyle**

![2](demo2.gif)

**DepthColorPageStyle**

![3](demo3.gif)

##Installation

Cocoapods:
```
pod 'LCAnimatedPageControl'
```

##Example Usage
```
#import <LCAnimatedPageControl.h>
```
```
self.pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 280, 20)];
self.pageControl.center = CGPointMake(self.view.frame.size.width * 0.5f, _pageControl.center.y);
self.pageControl.pageStyle = ScalePageStyle;
self.pageControl.numberOfPages = 5;
self.pageControl.indicatorMargin = 5.0f;
self.pageControl.indicatorMultiple = 1.6f;
self.pageControl.pageIndicatorColor = [UIColor redColor];
self.pageControl.currentPageIndicatorColor = [UIColor blackColor];
self.pageControl.sourceScrollView = _collectionView;
[self.pageControl prepareShow];
[self.view addSubview:_pageControl];
```

Use the ScalePageStyle, If you want to scrollView to scroll to the non-adjacent location, Please realize the following protocol methods

```
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;{
    [self.pageControl clearIndicators];
}
```

##Requirements
* iOS 6 or higher
* ARC

##More Info
[Blog](http://bawn.github.io/ios/uipagecontrol/2015/06/16/LCAnimatedPageControl.html)

##License
```
The MIT License (MIT)

Copyright (c) 2015 Bawn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
