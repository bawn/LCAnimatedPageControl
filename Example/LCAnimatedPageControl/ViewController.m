//
//  ViewController.m
//  LCAnimatedPageControl
//
//  Created by beike on 6/17/15.
//  Copyright (c) 2015 beike. All rights reserved.
//

#import "ViewController.h"
#import "LCAnimatedPageControl.h"

@interface ViewController ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    [self.collectionView layoutIfNeeded];
    
    LCAnimatedPageControl *pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 280, 20)];
    pageControl.numberOfPages = 5;
    pageControl.indicatorMargin = 5.0f;
    pageControl.indicatorMultiple = 1.6f;
    pageControl.pageIndicatorColor = [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    pageControl.currentPageIndicatorColor = [UIColor colorWithRed:221.0f/255.0f green:34.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
    pageControl.sourceScrollView = _collectionView;
    [pageControl show];
    [self.view addSubview:pageControl];
    
    pageControl.center = CGPointMake(self.view.frame.size.width * 0.5f, pageControl.center.y);
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
    self.flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width - 20, self.collectionView.frame.size.height - 60);
    
    [pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)valueChanged:(LCAnimatedPageControl *)sender{
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * sender.currentPage, 0) animated:YES];
}


#pragma mark  - UICollectionView DataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
    
}


@end
