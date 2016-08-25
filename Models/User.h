//
//  User.h
//  Twitter_GZ
//
//  Created by gongzhen on 8/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

// static:
// static variable or function at global scope means that that symbol has internal linkage
// extern:  external linkage: declare the variable with the extern keyword in a header file,
// and then in one source file, define it at global scope without the extern keyword.
// http://nshipster.com/c-storage-classes/
// extern:extern makes functions and variables visible globally to all files.
extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileImageUrlBigger;
@property (nonatomic, strong) NSString *profileImageUrlOriginal;
@property (nonatomic, strong) NSString *profileBannerUrl;
@property (nonatomic, strong) NSString *profileBannerUrlMedium;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *numberOfTweets;
@property (nonatomic, strong) NSNumber *numberFollowing;
@property (nonatomic, strong) NSNumber *numberOfFollowers;

-(id)initWithDictionary:(NSDictionary *)dictionary;

// Class method:
// A class method is a method that operates on class objects rather than instances of the class.
+(User *)currentUser;
+(NSArray *)allUsers;
+(void)setCurrentUser:(User *)currentUser;
+(void)addUser:(User *)user;
+(void)logout;

@end
