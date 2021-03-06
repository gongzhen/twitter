//
//  TwitterClient.h
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "User.h"
#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

@property (strong, nonatomic) NSArray *accounts;

+(TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)removeRetweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)removeFavoriteWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;

@end
