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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LCAnimatedPageControl *pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(20, 400, 280, 50)];
    pageControl.numberOfPages = 5;
    pageControl.pageIndicatorColor = [UIColor grayColor];
    pageControl.currentPageIndicatorColor = [UIColor blackColor];
    pageControl.sourceScrollView = _collectionView;
    [pageControl show];
    [self.view addSubview:pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
