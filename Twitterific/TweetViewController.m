//
//  TweetViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/22/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIImageView *favIcon;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set title
    self.navigationItem.title = @"Tweet";
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(onReplyButton)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    [self renderTweet];
}

- (void) renderTweet {
    User *user = self.tweet.author;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [self.authorImage.layer setMasksToBounds:YES];
    [self.authorImage.layer setCornerRadius:5.0f];
    [self.authorImage setImageWithURL:[NSURL URLWithString:user.profileImgUrl]];
   
    self.authorName.text = user.name;
    self.screenName.text = user.screenName;
    self.tweetText.text = self.tweet.tweetText;
    
    [formatter setDateFormat:@"dd/MM/yy hh:mm a"];
    self.createdAt.text = [formatter stringFromDate:self.tweet.createdAt];
    self.retweetCount.text = [NSString stringWithFormat:@"%@", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%@", self.tweet.favoriteCount];
    
    NSLog(@" favoried?? %@", self.tweet.favorited);

    if ([self.tweet.favorited  isEqual: @1]) {
        NSLog(@" favorited! ");
        self.favIcon.image = [self.favIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.favIcon setTintColor: [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(7/255.0) alpha:1]];
    }
}


- (IBAction)onFavoriteTap:(UITapGestureRecognizer *)sender {
    
    NSLog(@"fav tapped");
    
    // if not already favorited
    if ([self.tweet.favorited isEqual:@0]) {
        [[TwitterClient sharedInstance] favoriteTweet:nil :self.tweet.idStr :^(NSNumber *favCount, NSError *error) {
            if (favCount == nil) {
                NSLog(@"favorite FAIL!");
            } else {
                //     [self.delegate didFavorite:YES];
                NSLog(@"favorite SUCCESS! : %@", favCount);
                self.tweet.favoriteCount = favCount;
                self.tweet.favorited = @1;
                [self renderTweet];
            }
        }];
    }
}

- (IBAction)onReplyIconTap:(id)sender {
    [self onReplyButton];
}

- (void) onReplyButton {
    NSLog(@"on reply button ");
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    ComposeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    
    vc.isReply = YES;
    vc.replyTweet = self.tweet;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
