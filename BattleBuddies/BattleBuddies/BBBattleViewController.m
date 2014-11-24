//
//  BBBattleViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "UIImageView+UIImageView_FaceAwareFill.h"

#import "BBBattleViewController.h"

#import "BBItemListViewController.h"
#import "BBBuddyListViewController.h"

#import "BBTriangleView.h"
#import "BBHealthBar.h"

#import "SDSoundManager.h"

@import CoreImage;

@interface BBBattleViewController ()

@property (nonatomic, strong) BBBuddy *player;

@property (nonatomic, strong) BBTriangleView *enemyView;
@property (nonatomic, strong) UIImageView *enemyBuddyImageView;
@property (nonatomic, strong) UIImageView *enemyFaceView;
@property (nonatomic, strong) UILabel *enemyLabel;
@property (nonatomic, strong) BBHealthBar *enemyHealthBar;

@property (nonatomic, strong) BBTriangleView *playerView;
@property (nonatomic, strong) UIImageView *playerBuddyImageView;
@property (nonatomic, strong) UILabel *playerLabel;
@property (nonatomic, strong) BBHealthBar *playerHealthBar;

@property (nonatomic, strong) UIButton *attackAButton;
@property (nonatomic, strong) UIButton *attackBButton;
@property (nonatomic, strong) UIButton *attackCButton;
@property (nonatomic, strong) UIButton *attackDButton;

@property (nonatomic, strong) UIButton *newBuddyButton;
@property (nonatomic, strong) UIButton *backpackButton;
@property (nonatomic, strong) UIButton *gtfoButton;

@end

@implementation BBBattleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Setup Background Views
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.enemyView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[player]" options:0 metrics:nil views:@{@"player": self.playerView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[player]|" options:0 metrics:nil views:@{@"player": self.playerView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[enemy]|" options:0 metrics:nil views:@{@"enemy": self.enemyView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[enemy]" options:0 metrics:nil views:@{@"enemy": self.enemyView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:1.0]];
    
    // Setup Player Views
    [self.view addSubview:self.enemyBuddyImageView];
    [self.view addSubview:self.playerBuddyImageView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8.0)-[player]" options:0 metrics:nil views:@{@"player" : self.playerBuddyImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[player]-(8.0)-|" options:0 metrics:nil views:@{@"player" : self.playerBuddyImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[enemy]-(8.0)-|" options:0 metrics:nil views:@{@"enemy" : self.enemyBuddyImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8.0)-[enemy]" options:0 metrics:nil views:@{@"enemy" : self.enemyBuddyImageView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerBuddyImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerBuddyImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.4 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyBuddyImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4 constant:1.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyBuddyImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.4 constant:1.0]];
    
    // SEtup enemy face
    [self.enemyBuddyImageView addSubview:self.enemyFaceView];
    
    [self.enemyBuddyImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyFaceView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:72.0]];
    
    [self.enemyBuddyImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyFaceView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:72.0]];
    
    
    [self.enemyBuddyImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyFaceView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.enemyBuddyImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    
    [self.enemyBuddyImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.enemyFaceView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.enemyBuddyImageView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:-32.0]];
    
    // Setup GTFO Button
    [self.view addSubview:self.gtfoButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[gtfo]" options:0 metrics:nil views:@{@"gtfo": self.gtfoButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[gtfo]" options:0 metrics:nil views:@{@"gtfo": self.gtfoButton}]];
    
    // Setup Option Buttons
    [self.view addSubview:self.newBuddyButton];
    [self.view addSubview:self.backpackButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[newBuddy]-[backpack]" options:0 metrics:nil views:@{@"newBuddy": self.newBuddyButton, @"backpack": self.backpackButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[newBuddy]-|" options:0 metrics:nil views:@{@"newBuddy": self.newBuddyButton, @"backpack": self.backpackButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backpack]-|" options:0 metrics:nil views:@{@"newBuddy": self.newBuddyButton, @"backpack": self.backpackButton}]];
    
    // Setup Attack Buttons
    [self.view addSubview:self.attackAButton];
    [self.view addSubview:self.attackBButton];
    [self.view addSubview:self.attackCButton];
    [self.view addSubview:self.attackDButton];
    
    NSDictionary *attackButtons = @{@"attackA": self.attackAButton,
                                    @"attackB": self.attackBButton,
                                    @"attackC": self.attackCButton,
                                    @"attackD": self.attackDButton,};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[attackA]-|" options:0 metrics:nil views:attackButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[attackB]-|" options:0 metrics:nil views:attackButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[attackC]-|" options:0 metrics:nil views:attackButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[attackD]-|" options:0 metrics:nil views:attackButtons]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[attackA]-[attackB]-[attackC]-[attackD]-|" options:0 metrics:nil views:attackButtons]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[SDSoundManager sharedManager] loopAudioNamed:@"Battle" atVolume:0.75];
}

- (void)setOpponent:(BBBuddy *)opponent
{
    _opponent = opponent;
    
    [self.enemyLabel setText:_opponent.name];
    UIImage *buddyImage = [UIImage imageNamed:_opponent.bodyImageFront];
    
    if (!buddyImage) {
        NSLog(@"Shit no buddy image: %@",_opponent.bodyImageFront);
    }
    
    [self.enemyBuddyImageView setImage:buddyImage];
    
    [self.enemyFaceView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:_opponent.faceImage]]];
    [self.enemyFaceView faceAwareFill];
    
    [self setPlayer:opponent];
}

- (void)setPlayer:(BBBuddy *)player
{
    _player = player;
    
    [self.attackAButton setTitle:_player.attack1.name forState:UIControlStateNormal];
    [self.attackBButton setTitle:_player.attack2.name forState:UIControlStateNormal];
    [self.attackCButton setTitle:_player.attack3.name forState:UIControlStateNormal];
    [self.attackDButton setTitle:_player.attack4.name forState:UIControlStateNormal];
    
    [self.playerLabel setText:_player.name];
    
    UIImage *buddyImage = [UIImage imageNamed:_player.bodyImageBack];
    
    if (!buddyImage) {
        NSLog(@"Shit no buddy image: %@",_player.bodyImageFront);
    }
    

    [self.playerBuddyImageView setImage:buddyImage];
}

#pragma mark - Attacks

- (void)attack
{
    
}

#pragma mark - Actions

- (void)gtfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showItems
{
    BBItemListViewController *itemList = [[BBItemListViewController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:itemList] animated:YES completion:nil];
}

- (void)showBuddies
{
    BBBuddyListViewController *buddyList = [[BBBuddyListViewController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:buddyList] animated:YES completion:nil];
}

#pragma mark - Views

- (UIButton *)gtfoButton
{
    if (!_gtfoButton) {
        _gtfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_gtfoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_gtfoButton setTitle:@"GTFO" forState:UIControlStateNormal];
        
        [_gtfoButton addTarget:self action:@selector(gtfo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _gtfoButton;
}

- (UIButton *)newBuddyButton
{
    if (!_newBuddyButton) {
        _newBuddyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_newBuddyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_newBuddyButton setTitle:@"BB" forState:UIControlStateNormal];
        
        [_newBuddyButton addTarget:self action:@selector(showBuddies) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _newBuddyButton;
}

- (UIButton *)backpackButton
{
    if (!_backpackButton) {
        _backpackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_backpackButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_backpackButton setTitle:@"BP" forState:UIControlStateNormal];
        
        [_backpackButton addTarget:self action:@selector(showItems) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backpackButton;
}

- (BBTriangleView *)enemyView
{
    if (!_enemyView) {
        _enemyView = [[BBTriangleView alloc] initWithFrame:CGRectZero];
        [_enemyView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_enemyView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.1]];
        
        [_enemyView setStartingCorner:BBTriangleCornerTopRight];
    }
    
    return _enemyView;
}

- (BBTriangleView *)playerView
{
    if (!_playerView) {
        _playerView = [[BBTriangleView alloc] initWithFrame:CGRectZero];
        [_playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_playerView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
        
        [_playerView setStartingCorner:BBTriangleCornerBottomLeft];
    }
    
    return _playerView;
}

- (UIImageView *)enemyBuddyImageView
{
    if (!_enemyBuddyImageView) {
        _enemyBuddyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_enemyBuddyImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_enemyBuddyImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return _enemyBuddyImageView;
}

- (UIImageView *)playerBuddyImageView
{
    if (!_playerBuddyImageView) {
        _playerBuddyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_playerBuddyImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_playerBuddyImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    return _playerBuddyImageView;
}

- (UIImageView *)enemyFaceView
{
    if (!_enemyFaceView) {
        _enemyFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 72.0, 72.0)];
        [_enemyFaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_enemyFaceView setContentMode:UIViewContentModeScaleAspectFill];
        
        [_enemyFaceView.layer setCornerRadius:CGRectGetWidth(_enemyFaceView.frame) / 2.0];
        [_enemyFaceView setClipsToBounds:YES];
        
        [_enemyFaceView.layer setBorderColor:[UIColor blackColor].CGColor];
        [_enemyFaceView.layer setBorderWidth:1.0];
    }
    
    return _enemyFaceView;
}

- (UIButton *)attackAButton
{
    if (!_attackAButton) {
        _attackAButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_attackAButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_attackAButton setTitle:@"Attack A" forState:UIControlStateNormal];
        
        [_attackAButton addTarget:self action:@selector(attack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _attackAButton;
}

- (UIButton *)attackBButton
{
    if (!_attackBButton) {
        _attackBButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_attackBButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_attackBButton setTitle:@"Attack B" forState:UIControlStateNormal];
        
        [_attackBButton addTarget:self action:@selector(attack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _attackBButton;
}

- (UIButton *)attackCButton
{
    if (!_attackCButton) {
        _attackCButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_attackCButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_attackCButton setTitle:@"Attack C" forState:UIControlStateNormal];
        
        [_attackCButton addTarget:self action:@selector(attack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _attackCButton;
}

- (UIButton *)attackDButton
{
    if (!_attackDButton) {
        _attackDButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_attackDButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_attackDButton setTitle:@"Attack D" forState:UIControlStateNormal];
        
        [_attackDButton addTarget:self action:@selector(attack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _attackDButton;
}

@end
