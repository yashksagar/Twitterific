//
//  User.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/20/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        self.profileImgUrl = [dictionary[@"profile_image_url"] stringByReplacingOccurrencesOfString:@"normal" withString:@"200x200"];
        self.profileBannerUrl = dictionary[@"profile_banner_url"];
        self.tagline = dictionary[@"description"];
        self.location = dictionary[@"location"];
        self.tweetsCount = dictionary[@"statuses_count"];
        self.followersCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
    }
    
    return self;
}

static User *_currentUser = nil;

+ (User *)getCurrentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_data"];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [userDefaults setObject:data forKey:@"current_user_data"];
    }
    
    _currentUser = currentUser;
    
    [userDefaults synchronize];
}

+ (void) logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [User setCurrentUser:nil];
    [userDefaults setObject:nil forKey:@"current_user_data"];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogoutNotification" object:nil];
}

@end
