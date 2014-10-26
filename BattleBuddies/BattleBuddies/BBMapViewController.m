//
//  BBMapViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBMapViewController.h"
#import "BBGridLayout.h"

@interface BBMapViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BBGridLayout *flowLayout;

@property (nonatomic, strong) UIButton *rightDirection;
@property (nonatomic, strong) UIButton *leftDirection;

@property (nonatomic, strong) UIButton *upDirection;
@property (nonatomic, strong) UIButton *downDirection;

@end

@implementation BBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    self.rightDirection = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 64.0, 0.0, 64.0, CGRectGetHeight(self.view.bounds))];
    [self.rightDirection setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight];
    [self.rightDirection setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    [self.rightDirection addTarget:self action:@selector(goRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightDirection];
    
    self.leftDirection = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, CGRectGetHeight(self.view.bounds))];
    [self.leftDirection setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight];
    [self.leftDirection setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
    [self.leftDirection addTarget:self action:@selector(goLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftDirection];
    
    self.upDirection = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 64.0)];
    [self.upDirection setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth];
    [self.upDirection setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.75]];
    [self.upDirection addTarget:self action:@selector(goUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upDirection];
    
    self.downDirection = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - 64.0, CGRectGetWidth(self.view.bounds), 64.0)];
    [self.downDirection setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    [self.downDirection setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.5]];
    [self.downDirection addTarget:self action:@selector(goDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downDirection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:2500] atScrollPosition:UICollectionViewScrollPositionTop|UICollectionViewScrollPositionRight animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)goLeft:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:--x inSection:y] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)goRight:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:++x inSection:y] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)goUp:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:--y] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)goDown:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:++y] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5000;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
//    [cell setBackgroundColor:[UIColor colorWithHue:(indexPath.section/10000.0) saturation:1.0 brightness:((10000.0 - indexPath.row)/10000.0) alpha:1.0]];
//    [cell setBackgroundColor:[UIColor colorWithHue:(arc4random() % 200)/200.0 saturation:1.0 brightness:1.0 alpha:1.0]];
    [cell setBackgroundColor:[UIColor colorWithHue:1.0 saturation:((indexPath.section % 2) ? 0.75 : 0.25) brightness:((indexPath.row % 2) ? 0.25 : 0.75) alpha:1.0]];
    
    [cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.layer setBorderWidth:0.5];
    
    UILabel *crapLabel = (UILabel *)[cell viewWithTag:99];
    if (!crapLabel) {
        crapLabel = [[UILabel alloc] initWithFrame:cell.bounds];
        [crapLabel setTag:99];
        [crapLabel setFont:[UIFont systemFontOfSize:10.0]];
        [crapLabel setNumberOfLines:2];
        [cell addSubview:crapLabel];
    }
    
    [crapLabel setText:[NSString stringWithFormat:@"%li\n%li",indexPath.row, indexPath.section]];

    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Views

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        [_collectionView setScrollEnabled:NO];
    }
    
    return _collectionView;
}

- (BBGridLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[BBGridLayout alloc] init];
    }
    
    return _flowLayout;
}

@end
