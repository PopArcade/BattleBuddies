//
//  BBTwitterStuff.m
//  BattleBuddies
//
//  Created by Marcus Smith on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBTwitterStuff.h"

@import Accounts;
@import Social;

typedef void(^BBTwitterStuffLoadMoreCompletion)(NSString *cursor, NSError *error);

@interface BBTwitterStuff ()

@property (nonatomic, strong) BBTwitterStuffLoadMoreCompletion loadMoreCompletion;
@property (nonatomic, strong) BBTwitterStuffLoadMoreCompletion anotherLoadMoreCompletion;
@property (nonatomic, strong) NSMutableArray *buddySeeds;

@end

@implementation BBTwitterStuff

+ (instancetype)sharedStuff
{
    static BBTwitterStuff *_sharedStuff = nil;
    if (!_sharedStuff) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedStuff = [[BBTwitterStuff alloc] init];
        });
    }
    
    return _sharedStuff;
}

- (void)followerBuddySeedsWithCompletion:(BBTwitterStuffContactsCompletion)completion
{
    [self startRequestWithEARL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"] andCompletion:completion];
}

- (void)friendBuddySeedsWithCompletion:(BBTwitterStuffContactsCompletion)completion
{
    [self startRequestWithEARL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"] andCompletion:completion];
}

- (void)startRequestWithEARL:(NSURL *)requestEARL andCompletion:(BBTwitterStuffContactsCompletion)completion
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                
                __weak BBTwitterStuff *weakSelf = self;
                self.buddySeeds = nil;
            
                self.loadMoreCompletion = ^(NSString *cursor, NSError *error) {
                    SLRequest *twitterInfoRequest = [weakSelf twitterInfoRequestWithEARL:requestEARL twitterAccount:twitterAccount andCursor:cursor];
                    
                    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        
                        NSLog(@"TwitResponse: %@",urlResponse.allHeaderFields);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([urlResponse statusCode] == 429) {
                                completion(weakSelf.buddySeeds.copy, [NSError errorWithDomain:@"idunno" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Rate Limit Reached"}]);
                                return;
                            }
                            
                            
                            // Check if there is some response data
                            
                            if (responseData) {
                                
                                NSError *error = nil;
                                NSDictionary *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                NSArray *users = TWData[@"users"];
                                
                                NSLog(@"Users: %li",users.count);
                                
                                [users enumerateObjectsUsingBlock:^(NSDictionary *userDict, NSUInteger idx, BOOL *stop) {
                                    NSString *name = userDict[@"name"];
                                    NSString *screenName = userDict[@"screen_name"];
                                    NSString *urlString = userDict[@"profile_image_url"];
                                    urlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                    NSURL *imageURL = [NSURL URLWithString:urlString];
                                    BBBuddySeed *buddy = [BBBuddySeed buddySeedWithName:name screenName:screenName imageURL:imageURL];
                                    [weakSelf.buddySeeds addObject:buddy];
                                }];
                                
                                NSString *nextCursor = TWData[@"next_cursor_str"];
                                
                                if (!nextCursor || [nextCursor isEqualToString:@"0"]) {
                                    completion(weakSelf.buddySeeds.copy, error);
                                }
                                else {
                                    weakSelf.loadMoreCompletion(nextCursor, nil);
                                }
                                
                            }
                            else {
                                completion(weakSelf.buddySeeds.copy, error);
                            }
                        });
                    }];
                };
                
                self.loadMoreCompletion(nil, nil);
                
            }
            else {
                completion(nil, [NSError errorWithDomain:@"idunno" code:0 userInfo:@{NSLocalizedDescriptionKey: @"No twitter account"}]);
            }
        }
        else {
            completion(nil, [NSError errorWithDomain:@"idunno" code:0 userInfo:@{NSLocalizedDescriptionKey: @"No access granted"}]);
        }
    }];
    
}

- (SLRequest *)twitterInfoRequestWithEARL:(NSURL *)requestEARL twitterAccount:(ACAccount *)account andCursor:(NSString *)cursor
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (account) {
        [dictionary setObject:account.username forKey:@"screen_name"];
    }
    if (cursor) {
        [dictionary setObject:cursor forKey:@"cursor"];
    }
    [dictionary setObject:@(200) forKey:@"count"];
    
    SLRequest *infoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestEARL parameters:dictionary.copy];
    [infoRequest setAccount:account];
    
    return infoRequest;
}

- (NSMutableArray *)buddySeeds
{
    if (!_buddySeeds) {
        _buddySeeds = [NSMutableArray array];
    }
    
    return _buddySeeds;
}

@end
