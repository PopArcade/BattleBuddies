//
//  AppDelegate.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "BBMainMenuViewController.h"
#import "BBTwitterStuff.h"
#import "BBDatabase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Stub out fake items if they don't have any
    if ([[BBDatabase itemsInBackpack] count] == 0) {
        [BBDatabase addItemToBackpack:[BBItem buddyBall]];
        [BBDatabase addItemToBackpack:[BBItem potion]];
        [BBDatabase addItemToBackpack:[BBItem potion]];
    }
    
    [[BBTwitterStuff sharedStuff] followerBuddySeedsWithCompletion:^(NSArray *buddySeeds, NSError *error) {
        if (error) {
            NSLog(@"ERROR!!!\n%@", error);
        }
        if (buddySeeds) {
            NSLog(@"updating all buddies with followers");
            NSSet *buddySeedSet = [NSSet setWithArray:buddySeeds];
            [BBDatabase updateAllBuddiesWithBuddies:buddySeedSet];
        }
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
    }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor blackColor]];
    [self.window makeKeyAndVisible];
    
    BBMainMenuViewController *menuViewController = [[BBMainMenuViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    [navController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.window setRootViewController:navController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
