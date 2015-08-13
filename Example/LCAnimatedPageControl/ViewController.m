//
//  ViewController.m
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "ViewController.h"
#import "LCAnimatedPageControl.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) LCAnimatedPageControl *pageControl;
@property (assign, nonatomic) NSUInteger number;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    [self.collectionView layoutIfNeeded];
    self.number = 5;
    
    self.pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 280, 20)];
    self.pageControl.center = CGPointMake(self.view.frame.size.width * 0.5f, _pageControl.center.y);
    self.pageControl.numberOfPages = _number;
    self.pageControl.indicatorDiameter = 10.0f;
    self.pageControl.indicatorMargin = 20.0f;
//    self.pageControl.indicatorMultiple = 1.4;
    self.pageControl.pageStyle = LCSingleLinePageStyle;
    self.pageControl.pageIndicatorColor = [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.pageControl.currentPageIndicatorColor = [UIColor colorWithRed:221.0f/255.0f green:34.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
    self.pageControl.sourceScrollView = _collectionView;
    [self.pageControl prepareShow];
    [self.view addSubview:_pageControl];
    
    
    /* ------autolayout-------- */
    
//    self.pageControl = [[LCAnimatedPageControl alloc] init];
//    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
//    self.pageControl.numberOfPages = _number;
//    self.pageControl.indicatorDiameter = 5.0f;// Required
//    self.pageControl.indicatorMargin = 18.0f;
//    self.pageControl.indicatorMultiple = 1.8f;
//    self.pageControl.pageStyle = ScaleColorPageStyle;
//    self.pageControl.pageIndicatorColor = [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
//    self.pageControl.currentPageIndicatorColor = [UIColor colorWithRed:221.0f/255.0f green:34.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
//    self.pageControl.sourceScrollView = _collectionView;
//    [self.pageControl prepareShow];
//    [self.view addSubview:_pageControl];
//    
//    [self.view addConstraints:@[
//                                [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
//                                [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
//                                [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
//                                [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
//                                ]];
//    
//    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
    
    self.flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width - 60, self.collectionView.frame.size.height - 100);
    
    [self.pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView reloadData];
    
}


// If you want to scrollView to scroll to the non-adjacent location, Please realize the following protocol methods

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;{
//    [self.pageControl clearIndicators];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)valueChanged:(LCAnimatedPageControl *)sender{
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * sender.currentPage  , self.collectionView.contentOffset.y) animated:YES];
}

- (IBAction)buttonPress:(id)sender{
    if ([[(UIBarButtonItem *)sender title] isEqualToString:@"+"]) {
        self.number++;
    }
    else{
        if (self.number > 0) {
            self.number--;
        }
    }
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = _number;
}

#pragma mark  - UICollectionView DataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _number;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end
