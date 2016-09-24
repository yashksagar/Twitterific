//
//  ComposeViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/22/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UITextView *tweetInput;
@property (weak, nonatomic) IBOutlet UILabel *charCountErrorLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@" compose did load>>!");
    
    NSString *title;
    
    if (_isReply) {
        title = @"Reply";
    } else {
        title = @"Compose";
    }
    
    self.charCountErrorLabel.hidden = YES;

    // set title
    self.navigationItem.title = title;
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:_isReply ? @"Send" : @"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onComposeButton)];
    
    self.navigationItem.rightBarButtonItem = tweetButton;
    self.user = [User getCurrentUser];

    self.authorName.text = self.user.name;
    self.screenName.text = self.user.screenName;
    [self.authorImage setImageWithURL:[NSURL URLWithString:self.user.profileImgUrl]];
    
    self.tweetInput.delegate = self;
    [self.tweetInput becomeFirstResponder];
    
    NSLog(@"user is: %@", self.user.name);
    
    NSLog(@"reply tweet: %@", _replyTweet.idStr);
    
    if (_isReply) {
        self.tweetInput.text = [NSString stringWithFormat:@"%@ ",_replyTweet.author.screenName];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@" text is: %@", self.tweetInput.text);
    
    if (self.tweetInput.text.length > 140) {
        self.tweetInput.textColor = [UIColor redColor];
        self.charCountErrorLabel.text = @"Exceeded character limit!";
        self.charCountErrorLabel.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.charCountErrorLabel.hidden = YES;
        self.tweetInput.textColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void) onComposeButton {
    NSLog(@"on compose: ");

    // post tweet
    NSLog(@" tweet: %@", self.tweetInput.text);
    
    NSString *tweetText = self.tweetInput.text;
    NSDictionary *params = _isReply ? @{
                             @"idStr": _replyTweet.idStr
                             } : nil;
    
    if (tweetText.length > 0 && tweetText.length <= 140) {
        [[TwitterClient sharedInstance] postTweet:params :self.tweetInput.text :^(NSString *idStr, NSError *error) {
          if (idStr != nil) {
              [self.delegate didCompose:YES];
              NSLog(@"tweet success! : %@", idStr);
              [self.navigationController popViewControllerAnimated:YES];
          } else {
              NSLog(@"tweet FAIL! : %@", error);
              [self.navigationController popViewControllerAnimated:YES];
          }
        }];

    } else {
        // error characters above 140.
        NSLog(@"too many chars");
    }
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
