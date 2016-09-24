//
//  Tweet.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/20/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.tweetText = dictionary[@"text"];
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString * createdAt = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAt];
        self.retweetCount = dictionary[@"retweet_count"];
        self.favoriteCount = dictionary[@"favorite_count"];
        self.favorited = dictionary[@"favorited"];
        self.idStr = dictionary[@"id_str"];
    }
    
    return self;
}


+ (NSMutableArray *)getTweetsFromArray:(NSArray *)array {
    NSMutableArray * tweets = [NSMutableArray array];
    
    for (NSDictionary *tweet in array) {
        [ tweets addObject:[[Tweet alloc] initWithDictionary:tweet] ];
    }
    
    return tweets;
}

@end
