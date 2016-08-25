//
//  Tweet.h
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) Tweet *retweetedTweet;
@property (nonatomic, strong) Tweet *myNewRetweetedTweet;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *tweetIDString;
@property (nonatomic, strong) NSNumber *tweetID;
@property (nonatomic, strong) NSNumber *numberOfFavorites;
@property (nonatomic, strong) NSNumber *numberOfRetweets;
@property (nonatomic) BOOL favorited;
@property (nonatomic) BOOL retweeted;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateFavoritedToValue:(BOOL)favorited;
- (void)updateRetweetedToValue:(BOOL)retweeted;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
