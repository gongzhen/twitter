
//
//  User.m
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "User.h"

static User *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";
NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

// Class extension: public property
@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.profileImageUrlBigger = [self.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal.jpeg" withString:@"_bigger.jpeg"];
        self.profileImageUrlOriginal = [self.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal.jpeg" withString:@".jpeg"];
        self.profileBannerUrl = dictionary[@"profile_banner_url"];
        self.profileBannerUrlMedium = [self.profileBannerUrl stringByAppendingString:@"/600x200"];
        self.tagline = dictionary[@"description"];
        self.userID = dictionary[@"id"];
        self.numberOfTweets = dictionary[@"statuses_count"];
        self.numberFollowing = dictionary[@"friends_count"];
        self.numberOfFollowers = dictionary[@"followers_count"];
    }
    return self;
}

+ (User *)currentUser {
    if (!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:0
                                        error:NULL];
            
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (NSArray *)allUsers {
    NSMutableArray *mutableArray = [NSMutableArray array];
    [mutableArray addObject:[User currentUser]];
    NSArray *array = [NSArray arrayWithArray:mutableArray];
    return array;
}

+ (void) addUser:(User *)user {
    
}

+ (void) setCurrentUser:(User *)currentUser
{
    _currentUser = currentUser;
    
    if (_currentUser) {
        NSData *data = [NSJSONSerialization
                        dataWithJSONObject:currentUser
                        options:0
                        error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
}

+ (void)logout {
    [User setCurrentUser:nil];
    // todo twitterCLient
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
