//
//  TwitterClient.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/19/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
@property NSString* username;

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error)) completion;

- (void)openUrl:(NSURL *) url;

- (void)getTimeline:(void (^)(NSMutableArray *tweets, NSError *error)) callback;
- (void)postTweet:(NSDictionary *)params :(NSString *) tweetText :(void (^)(NSString *idStr, NSError *error))callback;
- (void)favoriteTweet:(NSDictionary *)params :(NSString *)tweetIdStr :(void (^)(NSNumber *favCount, NSError *error))callback;

- (void)getMentions:(NSDictionary *)params :(void (^)(NSMutableArray *tweets, NSError *error))callback;

@end
