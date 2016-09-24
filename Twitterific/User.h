//
//  User.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/20/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * screenName;
@property (nonatomic, strong) NSString * profileImgUrl;
@property (nonatomic, strong) NSString * profileBannerUrl;
@property (nonatomic, strong) NSString * tagline;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSNumber * tweetsCount;
@property (nonatomic, strong) NSNumber * followingCount;
@property (nonatomic, strong) NSNumber * followersCount;
@property (nonatomic, strong) NSDictionary *dictionary; // for userdefaults json serialization

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)getCurrentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void) logout;

@end
