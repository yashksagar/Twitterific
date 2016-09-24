//
//  TweetViewCell.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/21/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol TweetViewCellDelegate <NSObject>

- (void) onProfileImgTap:(Tweet *)tweet;

@end

@interface TweetViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favIcon;

@property (weak, nonatomic) id <TweetViewCellDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

- (void) onImgTap:(id) sender;

@end
