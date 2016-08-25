//
//  Tweet.m
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.user = [[User alloc] initWithDictionary:[dictionary valueForKey:@"user"]];
        self.text = [dictionary valueForKey:@"text"];
        self.tweetIDString  = [dictionary valueForKey:@"id"];
        self.tweetID = [dictionary valueForKey:@"id"];
        
        NSString *createdAtString = [dictionary valueForKey:@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.numberOfFavorites = @([[dictionary valueForKey:@"favorite_count"] intValue]);
        self.numberOfRetweets = @([[dictionary valueForKey:@"retweet_count"] intValue]);
        self.favorited = [[dictionary valueForKey:@"favorited"] boolValue];
        self.retweeted = [[dictionary valueForKey:@"retweeted"] boolValue];
        
        if ([dictionary valueForKey:@"retweeted_status"]) {
            self.retweetedTweet = [[Tweet alloc] initWithDictionary:[dictionary valueForKey:@"retweeted_status"]];
        }
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array
{
    // Create an empty array
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

-(void)updateFavoritedToValue:(BOOL)favorited
{
    self.favorited = favorited;
    NSLog(@"set tweet favorite to: %hhd", (char)favorited);
    if (favorited) {
        NSNumber *newNumberOfFavorites = [NSNumber numberWithInt:[self.numberOfFavorites intValue] + 1];
        self.numberOfFavorites = newNumberOfFavorites;
    } else if (self.numberOfFavorites.integerValue > 0) {
        NSNumber *newNumberOfFavorites = [NSNumber numberWithInt:[self.numberOfFavorites intValue] -1];
        self.numberOfFavorites = newNumberOfFavorites;
    }
}

-(void)updateRetweetedToValue:(BOOL)retweeted
{
    self.retweeted = retweeted;
    NSLog(@"set retweet to: %hhd", (char)retweeted);
    if (retweeted) {
        NSNumber *newNumberOfRetweets = [NSNumber numberWithInt:[self.numberOfRetweets intValue] + 1];
        self.numberOfRetweets = newNumberOfRetweets;
    } else if (self.numberOfRetweets.integerValue > 0) {
        NSNumber *newNumberOfRetweets = [NSNumber numberWithInt:[self.numberOfFavorites intValue] -1];
        self.numberOfRetweets = newNumberOfRetweets;
    }
}

@end
