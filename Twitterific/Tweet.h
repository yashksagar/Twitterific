//
//  Tweet.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/20/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString * tweetText;
@property (nonatomic, strong) NSString * idStr;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) User * author;
@property (nonatomic, strong) NSNumber * retweetCount;
@property (nonatomic, strong) NSNumber * favoriteCount;
@property (nonatomic, strong) NSNumber * favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)getTweetsFromArray:(NSArray *)array;

@end
