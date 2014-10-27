//
//  BattleBuddiesTests.m
//  BattleBuddiesTests
//
//  Created by Ryan Poolos on 10/26/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BBBuddy.h"
#import "BBConstants.h"

@interface BattleBuddiesTests : XCTestCase

@end

@implementation BattleBuddiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBuddyCreation {
    NSArray *names = @[@"Marcus Smith", @"Michael Ryan Poolos", @"Sansan", @"Galen Yacalis", @"Tyler Hemmie", @"Jacab"];
    
    NSArray *levels = @[@5, @25, @45];
    
    for (NSString *name in names) {
        for (NSNumber *level in levels) {
            BBBuddy *buddy = [[BBBuddy alloc] initFromUniqueIdentifier:name name:name imageURL:nil level:[level unsignedIntegerValue]];
            
            NSLog(@"\n%@", buddy);
        }
    }
    
    XCTAssert(YES == YES);
}

- (void)testAttackSyllabus
{
    uint count = 0;
    for (uint element = BBElementFirst; element <= BBElementMax; element++) {
        for (uint class = BBLevelClassFirst; class <= BBLevelClassMax; class++) {
            for (uint variation = 0; variation <= 1; variation++) {
                BBAttack *attack = [BBAttack attackNumber:variation forElement:element inLevelClass:class];
                NSLog(@"%@", attack);
                if (!attack.name) {
                    NSLog(@"OH FUCK!!!! Element: %u, Class: %u, Variation: %u", element, class, variation);
                    count++;
                }
                
            }
        }
    }
    
    NSLog(@"Count: %d", count);
    
    XCTAssert(count < 1);
}

- (void)testLevelUpping
{
    BBBuddy *buddy = [[BBBuddy alloc] initFromUniqueIdentifier:@"Marcus Smith" name:@"Marcus Smith" imageURL:nil level:1];
    
    while (buddy.level < 50) {
        NSLog(@"%@", [buddy giveExp:50]);
    }
    
    XCTAssert(YES == YES);
}

- (void)testAttacks
{
    BBBuddy *buddy = [[BBBuddy alloc] initFromUniqueIdentifier:@"Coy Woolard" name:@"Coy Woolard" imageURL:nil level:1];
    
    for (NSUInteger i = 1; i < 52; i++) {
        [buddy setLevel:i];
        
        NSLog(@"LEVEL %ld\nAttack1: %@\nAttack2: %@\nAttack3: %@\nAttack4: %@", i, buddy.attack1, buddy.attack2, buddy.attack3, buddy.attack4);
    }
}

@end
