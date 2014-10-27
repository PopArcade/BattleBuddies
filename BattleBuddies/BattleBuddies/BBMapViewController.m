//
//  BBMapViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBMapViewController.h"

#import "BBMapCollectionViewCell.h"
#import "BBGridLayout.h"

#import "BBMapTouchView.h"

#import "BBMapAtlas.h"



@interface BBMapViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BBMapTouchDelegate>
{
    NSDictionary *directionButtons;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BBGridLayout *flowLayout;

@property (nonatomic, strong) UIButton *upLeftDirection;
@property (nonatomic, strong) UIButton *upDirection;
@property (nonatomic, strong) UIButton *upRightDirection;

@property (nonatomic, strong) UIButton *rightDirection;
@property (nonatomic, strong) UIButton *leftDirection;

@property (nonatomic, strong) UIButton *downLeftDirection;
@property (nonatomic, strong) UIButton *downDirection;
@property (nonatomic, strong) UIButton *downRightDirection;

@property (nonatomic, strong) BBMapTouchView *touchView;

@property (nonatomic, strong) BBMapAtlas *tileMap;

@end

@implementation BBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    [self setupDirectionButtons];
    
    [self.view addSubview:self.touchView];
    
    
    [self setTileMap:[[BBMapAtlas alloc] init]];
    
    
//    NSMutableArray *columns = [NSMutableArray array];
//    for (int x = 0; x < 2000; x++) {
//        NSMutableArray *column = [NSMutableArray array];
//        for (int y = 0; y < 2000; y++) {
//            [column addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
//        }
//        [columns addObject:column];
//    }
    
//    [self.upLeftDirection setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:1.0]];
//    [self.upDirection setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:1.0]];
//    [self.upRightDirection setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:1.0]];
//    
//    [self.downLeftDirection setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:1.0]];
//    [self.downDirection setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:1.0]];
//    [self.downRightDirection setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:1.0]];
//    
//    [self.rightDirection setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:1.0]];
//    [self.leftDirection setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0]];
//    
//    [self.touchView setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.5]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:2500] atScrollPosition:UICollectionViewScrollPositionTop|UICollectionViewScrollPositionRight animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - BBMapTouchDelegate

- (void)didBeginTouching:(BBMapTouchView *)view
{
    [directionButtons.allValues enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(button.frame, view.locationOfTouch)) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

- (void)stillTouching:(BBMapTouchView *)view
{
    [directionButtons.allValues enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(button.frame, view.locationOfTouch)) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.generator.size.width;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.generator.size.height;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BBMapCollectionViewCell class]) forIndexPath:indexPath];
    
//    NSLog(@"%li",indexPath.row);
    NSArray *atlasCoordinates = [self.generator tileAtlasCoordinatesAtX:(int)indexPath.row andY:(int)indexPath.section];
    
//    if (atlasCoordinates) {
//        <#statements#>
//    }
    
    [atlasCoordinates enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
        CGPoint atlasCoordinate = [value CGPointValue];
        
        UIImageView *imageView = [cell imageViewAtIndex:idx];
        
        [imageView setImage:self.tileMap.tiles[(int)atlasCoordinate.x][(int)atlasCoordinate.y]];
    }];
    

    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Views

- (BBMapTouchView *)touchView
{
    if (!_touchView) {
        _touchView = [[BBMapTouchView alloc] initWithFrame:self.view.bounds];
        [_touchView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [_touchView setDelegate:self];
    }
    
    return _touchView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[BBMapCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BBMapCollectionViewCell class])];
        
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

- (void)setupDirectionButtons
{
    self.upLeftDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.upLeftDirection addTarget:self action:@selector(goUpLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upLeftDirection];
    
    self.upDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.upDirection addTarget:self action:@selector(goUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upDirection];
    
    self.upRightDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.upRightDirection addTarget:self action:@selector(goUpRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upRightDirection];
    
    
    
    self.downLeftDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.downLeftDirection addTarget:self action:@selector(goDownLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downLeftDirection];
    
    self.downDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.downDirection addTarget:self action:@selector(goDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downDirection];
    
    self.downRightDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.downRightDirection addTarget:self action:@selector(goDownRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downRightDirection];
    
    
    
    self.rightDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.rightDirection addTarget:self action:@selector(goRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightDirection];
    
    self.leftDirection = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.leftDirection addTarget:self action:@selector(goLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftDirection];
    
    
    
    directionButtons = @{@"upLeft": self.upLeftDirection,
                         @"up": self.upDirection,
                         @"upRight": self.upRightDirection,
                         
                         @"downLeft": self.downLeftDirection,
                         @"down": self.downDirection,
                         @"downRight": self.downRightDirection,
                         
                         @"left": self.leftDirection,
                         @"right": self.rightDirection
                         };
    
    [directionButtons.allValues enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[upLeft(>=96.0)][up(==down)][upRight(==upLeft)]|" options:0 metrics:nil views:directionButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[left(>=128.0)][up][right]|" options:0 metrics:nil views:directionButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[downLeft(==downRight)][down(==up)][downRight(==downLeft)]|" options:0 metrics:nil views:directionButtons]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upLeft(>=96.0)][left(==right)][downLeft(==upLeft)]|" options:0 metrics:nil views:directionButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[up(>=96.0)][left][down(==up)]|" options:0 metrics:nil views:directionButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upRight(==downRight)][right(==left)][downRight(==upRight)]|" options:0 metrics:nil views:directionButtons]];
}

#pragma mark - Directions

- (void)goUpLeft:(id)sender
{
    [self goLeft:sender];
    [self goUp:sender];
}

- (void)goUpRight:(id)sender
{
    [self goRight:sender];
    [self goUp:sender];
}

- (void)goDownLeft:(id)sender
{
    [self goLeft:sender];
    [self goDown:sender];
}

- (void)goDownRight:(id)sender
{
    [self goRight:sender];
    [self goDown:sender];
}

- (void)goLeft:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    if (x <= 0) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:--x inSection:y] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)goRight:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    if (x >= [self numberOfSectionsInCollectionView:self.collectionView]) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:++x inSection:y] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)goUp:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    if (y <= 0) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:--y] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

- (void)goDown:(id)sender
{
    NSInteger x = self.collectionView.contentOffset.x / 32.0;
    NSInteger y = self.collectionView.contentOffset.y / 32.0;
    
    if (y >= [self collectionView:self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:++y] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

@end
