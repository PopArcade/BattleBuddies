//
//  ViewController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBMainMenuViewController.h"
#import "BBMapViewController.h"

#import "SDSoundManager.h"

@interface BBMainMenuViewController ()
{
    SDAudioPlayer *menuMusic;
}

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation BBMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.backgroundView setBackgroundColor:[UIColor blueColor]];
    [self.logoView setBackgroundColor:[UIColor greenColor]];
    [self.playButton setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.playButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    menuMusic = [[SDSoundManager sharedManager] loopAudioNamed:@"Menu" atVolume:0.0];
    [menuMusic fadeInOverTime:5.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [menuMusic fadeOut];
}

- (void)play:(id)sender
{
    BBMapViewController *mapViewController = [[BBMapViewController alloc] init];
    
    NSLog(@"Start Map Generator");
    mapViewController.generator = [[BBMapGenerator alloc] initWithSize:CGSizeMake(200.0, 200.0)];
    
    [mapViewController.generator generateMap:^{
        NSLog(@"Finish Map Generator");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:mapViewController animated:YES];
        });
    }];
    
}

#pragma mark - Views

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    
    return _backgroundView;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        CGFloat startX = 32.0;
        CGFloat width = CGRectGetWidth(self.view.bounds) - (startX * 2.0);
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startX, width, 256.0)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [_logoView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        }
        else {
            [_logoView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
        }
        
    }
    
    return _logoView;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        CGFloat width = 256.0;
        CGFloat startX = (CGRectGetWidth(self.view.bounds) - width) / 2.0;
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(startX, CGRectGetHeight(self.view.bounds) - 224.0, width, 64.0)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [_playButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        }
        else {
            [_playButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
        }
        
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playButton;
}

@end
