//
//  TwitterClient.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/19/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

NSString * const twitterConsumerKey = @"TkR2kC0O9JRYOrrAcXFTdPO0c";
NSString * const twitterConsumerSecret = @"aGmcIvtOdQYIvaHFURMJTjgqTAn0JO1r3pmhSNw7KtqoWHTx3d";
NSString * const twitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginComplete)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    if (instance == nil) {
        
        static dispatch_once_t token;
        dispatch_once(&token, ^ {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:twitterBaseUrl] consumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
        });
    }
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error)) completion {
    self.loginComplete = completion;

    [self.requestSerializer removeAccessToken];

    [self fetchRequestTokenWithPath:@"/oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterific://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
          NSLog(@"success!!");
        
          // get authorization from user
          NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
          [[UIApplication sharedApplication] openURL:authURL];
        
      } failure:^(NSError *error) {
          NSLog(@"failed!");
        
          // add label to display error and retry
          self.loginComplete(nil, error);
      }
    ];
    
}

- (void)openUrl:(NSURL *)url {
    // get the auth token
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
        success:^(BDBOAuthToken *accessToken) {
          NSLog(@"got the access token!");
        
          // save token
          [self.requestSerializer saveAccessToken:accessToken];
        
          // get user cred
          [self GET:@"/1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"login success!");
            User *user = [[User alloc] initWithDictionary:responseObject];

            [User setCurrentUser:user];
            
            // callback to notify VC that we are logged in.
            self.loginComplete(user, nil);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"call failed;;;");
          }];
      } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
     }
  ];
}

- (void)getTimeline:(void (^)(NSMutableArray *tweets, NSError *error)) callback {
    
    // get from cache if exists
    [self.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [self GET:@"/1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"timeline success!");
        if (callback) {
          callback([Tweet getTweetsFromArray:responseObject], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"call failed;;; , %@", error);
        callback(nil, error);
    }];

}

- (void)postTweet:(NSDictionary *)params :(NSString *)tweetText :(void (^)(NSString *, NSError *))callback {
        NSString *postUrl;
    
    NSLog(@"params:: %@", params);
    if (params != nil && params[@"idStr"]) {
        postUrl = [NSString stringWithFormat:@"1.1/statuses/update.json?status=%@&in_reply_to_status_id=%@", tweetText, params[@"idStr"]];
    } else {
        postUrl = [NSString stringWithFormat:@"1.1/statuses/update.json?status=%@",tweetText];
    }
    
    NSLog(@"posting... %@", postUrl);
    [self POST:[postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"succssfully tweeted: %@", responseObject);
        callback(responseObject[@"id_str"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post fail/// ");
        callback(nil, error);
    }];
}

- (void)favoriteTweet:(NSDictionary *)params :(NSString *)tweetIdStr :(void (^)(NSNumber *favCount, NSError *error))callback {
    NSString *postUrl = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@&include_entities=false", tweetIdStr];
    
    [self POST:[postUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"favorite sucess! %@", responseObject);
        callback(responseObject[@"favorite_count"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
    }];
}

- (void)getMentions:(NSDictionary *)params :(void (^)(NSMutableArray *, NSError *))callback {
    [self GET:@"1.1/statuses/mentions_timeline.json?include_my_retweet=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"mentions timeline: %@", responseObject);
        callback([Tweet getTweetsFromArray:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
    }];
}


@end
