# LCAnimatedPageControl

![License MIT](https://img.shields.io/dub/l/vibe-d.svg)
![Pod version](http://img.shields.io/cocoapods/v/LCAnimatedPageControl.svg?style=flat)
![Platform info](http://img.shields.io/cocoapods/p/LCAnimatedPageControl.svg?style=flat)
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)

![logo](logo.png)

Custom UIPageControl with a simple animation.

## Demo

 __　　LCSquirmPageStyle　　　　　　　　　　　　　LCScaleColorPageStyle__

<img src="https://raw.github.com/bawn/LCAnimatedPageControl/master/demo1.gif" width="320">
<img src="https://raw.github.com/bawn/LCAnimatedPageControl/master/demo2.gif" width="320">
<br/> <br/>

 __　　LCSquirmPageStyle　　　　　　　　　　　　　LCFillColorPageStyle__
 
<img src="https://raw.github.com/bawn/LCAnimatedPageControl/master/demo3.gif" width="320">
<img src="https://raw.github.com/bawn/LCAnimatedPageControl/master/demo4.gif" width="320">

## Installation

CocoaPods:
```
pod 'LCAnimatedPageControl'
```

## Example Usage
```
#import <LCAnimatedPageControl.h>
```
```
self.pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 280, 20)];
self.pageControl.center = CGPointMake(self.view.frame.size.width * 0.5f, _pageControl.center.y);
self.pageControl.pageStyle = LCScalePageStyle;
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

## Requirements
* iOS 6 or higher
* ARC

## More Info
[Blog](http://bawn.github.io/ios/uipagecontrol/2015/06/16/LCAnimatedPageControl.html)

## License

[MIT](http://mit-license.org/)

