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


#import "BBItemListViewController.h"

#import "BBBattleViewController.h"
#import "BBBattlePresentationController.h"
#import "BBBattleDismissalController.h"

#import "BBTwitterStuff.h"
#import "BBDatabase.h"
#import "BBBuddy.h"

#import "SDSoundManager.h"

@interface BBMapViewController () <UICollectionViewDataSource, UICollectionViewDelegate, BBMapTouchDelegate, UIViewControllerTransitioningDelegate>
{
    NSDictionary *directionButtons;
    int tilesWalked;
    
    NSArray *availableBuddies;
    
    SDAudioPlayer *menuMusic;
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

@property (nonatomic, strong) UIButton *itemsButton;
@property (nonatomic, strong) UIButton *buddiesButton;

@property (nonatomic, strong) UIImageView *mainCharacter;

@end

@implementation BBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    [self setupDirectionButtons];
    
    [self.view addSubview:self.touchView];
    
    
    [self setTileMap:[[BBMapAtlas alloc] init]];
    
    [self.view addSubview:self.itemsButton];
    [self.view addSubview:self.buddiesButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8.0)-[items]-(>=0.0)-[buddies]-(8.0)-|" options:0 metrics:nil views:@{@"items": self.itemsButton, @"buddies": self.buddiesButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8.0)-[items]" options:0 metrics:nil views:@{@"items": self.itemsButton, @"buddies": self.buddiesButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8.0)-[buddies]" options:0 metrics:nil views:@{@"items": self.itemsButton, @"buddies": self.buddiesButton}]];
    
    
    [self.view addSubview:self.mainCharacter];
    
    
//    UIView *vertical = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 16.0, 0.0, 32.0, CGRectGetHeight(self.view.bounds))];
//    [vertical setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.5]];
//    [self.view addSubview:vertical];
//    
//    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMidY(self.view.bounds) - 16.0, CGRectGetWidth(self.view.bounds), 32.0)];
//    [horizontal setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
//    [self.view addSubview:horizontal];
    
    
    [self centerTheMapForSize:self.view.bounds.size];
    
    
    
    // Load twitter buddies.
    [[BBTwitterStuff sharedStuff] followerBuddySeedsWithCompletion:^(NSArray *buddySeeds, NSError *error) {
        if (error) {
            NSLog(@"ERROR!!!\n%@", error);
        }
        if (buddySeeds) {
            NSLog(@"updating all buddies with followers");
            NSSet *buddySeedSet = [NSSet setWithArray:buddySeeds];
            [BBDatabase updateAllBuddiesWithBuddies:buddySeedSet];
        }
        
        NSMutableArray *_availableBuddies = [NSMutableArray array];
        
        [[BBDatabase allBuddies] enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            BBBuddy *buddy = [BBBuddy buddyFromBuddySeed:obj atLevel:10];
            
            [_availableBuddies addObject:buddy];
        }];
        
        availableBuddies = _availableBuddies.copy;
        _availableBuddies = nil;
        
        NSLog(@"Buddyies Loaded: %@",[availableBuddies valueForKey:NSStringFromSelector(@selector(name))]);
    }];
    
    [[BBTwitterStuff sharedStuff] friendBuddySeedsWithCompletion:^(NSArray *buddySeeds, NSError *error) {
        if (error) {
            NSLog(@"ERROR!!!\n%@", error);
        }
        if (buddySeeds) {
            NSLog(@"updating all buddies with friends");
            NSSet *buddySeedSet = [NSSet setWithArray:buddySeeds];
            [BBDatabase updateAllBuddiesWithBuddies:buddySeedSet];
        }
        
        NSMutableArray *_availableBuddies = [NSMutableArray array];
        
        [[BBDatabase allBuddies] enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            BBBuddy *buddy = [BBBuddy buddyFromBuddySeed:obj atLevel:10];
            
            [_availableBuddies addObject:buddy];
        }];
        
        availableBuddies = _availableBuddies.copy;
        _availableBuddies = nil;
        
        NSLog(@"Buddyies Loaded: %@",[availableBuddies valueForKey:NSStringFromSelector(@selector(name))]);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:2500] atScrollPosition:UICollectionViewScrollPositionTop|UICollectionViewScrollPositionRight animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    menuMusic = [[SDSoundManager sharedManager] loopAudioNamed:@"NewWalk2" atVolume:0.0];
    [menuMusic fadeInOverTime:5.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self centerTheMapForSize:size];
}

- (void)startBattleAgainstBuddy:(BBBuddy *)opponent
{
    [menuMusic fadeOut];
    
    [[SDSoundManager sharedManager] playSoundEffectNamed:@"BattleIn"];
    
    BBBattleViewController *battleView = [[BBBattleViewController alloc] init];
    [battleView setOpponent:opponent];
    
    // Setup for Presentation
//    [battleView setModalPresentationStyle:UIModalPresentationCustom];
//    [battleView setTransitioningDelegate:self];
    
    [self presentViewController:battleView animated:YES completion:^{
//        [battleView setModalPresentationStyle:UIModalPresentationFullScreen];
//        [battleView setTransitioningDelegate:nil];
    }];
}

- (void)centerTheMapForSize:(CGSize)size
{
    // Center the map
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat itemSize = self.flowLayout.itemSize.width;
    
    CGFloat xRemainder = (int)width % (int)itemSize;
    CGFloat xAdjustment = itemSize - (xRemainder / 2.0);
    
    CGFloat yRemainder = (int)height % (int)itemSize;
    CGFloat yAdjustment = (itemSize - yRemainder) / 2.0;
    
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(-(yAdjustment), -(xAdjustment), 0.0, 0.0)];
}

#pragma mark - Navigation

- (void)showItems
{
    BBItemListViewController *itemList = [[BBItemListViewController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:itemList] animated:YES completion:nil];
}

- (void)showBuddies
{
    BBBuddyListViewController *buddyList = [[BBBuddyListViewController alloc] initWithMaxNumberOfSelections:6];
    [buddyList setDelegate:self];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:buddyList] animated:YES completion:nil];
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

#pragma mark - BBBuddyListViewControllerDelegate

- (void)buddyListViewController:(BBBuddyListViewController *)controller didFinishWithSelectedBuddies:(NSArray *)buddies
{
    [buddies enumerateObjectsUsingBlock:^(BBBuddy *buddy, NSUInteger idx, BOOL *stop) {
        NSLog(@"Selected: %@", buddy);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.mainCharacter.superview convertPoint:self.mainCharacter.center toView:self.collectionView]];    
//    NSLog(@"%@",indexPath);
    
    tilesWalked++;
    
    if (availableBuddies.count && tilesWalked > 10 && (arc4random() % 10) == 9) {
        [self.touchView cancelTouches];
        
        NSLog(@"Start THE FUCKING BATTLE");
        
        [self startBattleAgainstBuddy:availableBuddies[arc4random() % availableBuddies.count]];
    }
}

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

- (UIButton *)itemsButton
{
    if (!_itemsButton) {
        _itemsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_itemsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_itemsButton setTitle:@"Items" forState:UIControlStateNormal];
        [_itemsButton addTarget:self action:@selector(showItems) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _itemsButton;
}

- (UIButton *)buddiesButton
{
    if (!_buddiesButton) {
        _buddiesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buddiesButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_buddiesButton setTitle:@"Buddies" forState:UIControlStateNormal];
        [_buddiesButton addTarget:self action:@selector(showBuddies) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buddiesButton;
}

- (UIImageView *)mainCharacter
{
    if (!_mainCharacter) {
        _mainCharacter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
        [_mainCharacter setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_mainCharacter setCenter:self.view.center];
        
        [_mainCharacter setBackgroundColor:[UIColor redColor]];
    }
    
    return _mainCharacter;
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
    NSInteger x = (self.collectionView.contentOffset.x - self.collectionView.contentInset.left) / 32.0;
    NSInteger min = (CGRectGetWidth(self.view.bounds) / 2.0) / -32.0;
    min += 1;
    
    if (x <= min) {
        return;
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 32.0, self.collectionView.contentOffset.y)];
}

- (void)goRight:(id)sender
{
    NSInteger x = (self.collectionView.contentOffset.x - self.collectionView.contentInset.left) / 32.0;
    NSInteger max = [self numberOfSectionsInCollectionView:self.collectionView] - ((CGRectGetWidth(self.view.bounds) / 2.0) / 32.0);
    max -= 1;
    
    if (x >= max) {
        return;
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 32.0, self.collectionView.contentOffset.y)];
}

- (void)goUp:(id)sender
{
    NSInteger y = (self.collectionView.contentOffset.y - self.collectionView.contentInset.top) / 32.0;
    NSInteger min = (CGRectGetHeight(self.view.bounds) / 2.0) / -32.0;
    min += 1;
    
    if (y <= min) {
        return;
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y - 32.0)];
}

- (void)goDown:(id)sender
{
    NSInteger y = (self.collectionView.contentOffset.y - self.collectionView.contentInset.top) / 32.0;
    NSInteger max = [self collectionView:self.collectionView numberOfItemsInSection:0] - ((CGRectGetHeight(self.view.bounds) / 2.0) / 32.0);
    
    if (y >= max) {
        return;
    }
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 32.0)];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[BBBattlePresentationController alloc] init];
}

@end
