//
//  TwitterClient.m
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"0DyqdQeh7J6MlIOFBC4i68VLQ";
NSString * const kTwitterConsumerSecret = @"DvKf0LCosH9wDf6GeB0UpbtxFVkPGddvXVR9GGNJlATKQOVzoE";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+(TwitterClient *)sharedInstance
{
    // only set once due to `static` declaration
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc]
                        initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                        consumerKey:kTwitterConsumerKey
                        consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

-(void)loginWithCompletion:(void (^)(User *, NSError *))completion
{
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSLog(@"got the request token");
                                NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                NSLog(@"authURL: %@", [authURL absoluteString]);
                                [[UIApplication sharedApplication] openURL:authURL];
                            } failure:^(NSError *error) {
                                NSLog(@"ailed to get request token, error: %@", error);
                                self.loginCompletion(nil, error);
                            }];
}

-(void)openURL:(NSURL *)url
{
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                           success:^(BDBOAuthToken *accessToken) {
                               NSLog(@"Got the access token");
                               // Save access token.
                               [self.requestSerializer saveAccessToken:accessToken];
                               [self GET:@"1.1/account/verify_credentials.json"
                              parameters:nil
                                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                     User *user = [[User alloc] initWithDictionary:responseObject];
                                     self.loginCompletion(user, nil);
                                 }
                                 failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                     NSLog(@"Failed getting current user, error: %@", error);
                                     self.loginCompletion(nil, error);
                                 }];
                           }
                           failure:^(NSError *error) {
                               NSLog(@"Failed to get access token, error: %@", error);
                           }];
}

-(void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          if ([responseObject isKindOfClass:[NSArray class]]){
              NSArray *tweets = [Tweet tweetsWithArray:responseObject];
              completion(tweets,nil);
          } else {
              NSLog(@"response was not an array: %@", responseObject);
          }
      } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
          completion(nil, error);
      }];
}

-(void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    [self GET:@"1.1/statuses/user_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          if ([responseObject isKindOfClass:[NSArray class]]) {
              NSArray *tweets = [Tweet tweetsWithArray:responseObject];
              completion(tweets, nil);
          } else {
              NSLog(@"response was not an array: %@", responseObject);
          }
      } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
          completion(nil, error);
      }];
}

-(void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion
{
    NSLog(@"getting mentions...");
    [self GET:@"1.1/statuses/mentions_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          if ([responseObject isKindOfClass:[NSArray class]]) {
              NSArray *tweets = [Tweet tweetsWithArray:responseObject];
              completion(tweets, nil);
          } else {
              NSLog(@"response was not an array: %@", responseObject);
          }
      } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
          completion(nil, error);
      }];
}

-(void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    [self POST:@"1.1/statuses/update.json"
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           completion(nil, error);
       }];
}

-(void)retweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    NSString *tweetID = [params valueForKey:@"id"];
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID]
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)removeRetweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    NSString *tweetID = [params valueForKey:@"id"];
    [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetID]
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           completion(nil, error);
       }];
}

-(void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    [self POST:@"1.1/favorites/create.json"
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           completion(nil, error);
       }];
}

-(void)removeFavoriteWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion
{
    [self POST:@"1.1/favorites/destroy.json"
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           completion(nil, error);
       }];
}

@end
