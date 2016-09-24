//
//  ComposeViewController.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/22/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didCompose:(BOOL)compose;

@end

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) User *user;
@property BOOL isReply;
@property (strong, nonatomic) Tweet *replyTweet;


@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;
@end
