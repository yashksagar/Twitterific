//
//  TimelineViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/20/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetViewCell.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, TweetViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"get timeline... ");
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.estimatedRowHeight = 200;
    self.timelineTableView.rowHeight = UITableViewAutomaticDimension;
    
    // set title
    self.navigationItem.title = @"Home";
    
    // set pull-to-refresh
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.timelineTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    
    [self fetchTimeline];
}

- (void)didCompose:(BOOL)compose {
    if (compose) {
        [self fetchTimeline];
        [self.timelineTableView setContentOffset:CGPointZero animated:YES];
    }
}

- (void) fetchTimeline {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"Loading timeline...";
    
    [[TwitterClient sharedInstance] getTimeline:^(NSMutableArray *tweets, NSError *error) {
        if (tweets != nil) {
            self.tweets = tweets;

            [self.timelineTableView reloadData];
            
            // show progress hud for a bit longer
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        } else {
            // show error view
            NSLog(@"Error getting timeline... ");
        }

        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet * tweet = self.tweets[indexPath.row];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@",
                          tweet.author.profileImgUrl
                          ];
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:tweet.createdAt.timeIntervalSinceNow];

    cell.timeAgoLabel.text = timeAgoDate.shortTimeAgoSinceNow;
    cell.authorNameLabel.text = tweet.author.name;
    cell.screenNameLabel.text = tweet.author.screenName;
    [cell.screenNameLabel sizeToFit];
    cell.tweetTextLabel.text = tweet.tweetText;
    [cell.authorImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [cell.authorImageView.layer setCornerRadius:5.0f];
    [cell.authorImageView.layer setMasksToBounds:YES];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%@", tweet.retweetCount];
    cell.favCountLabel.text = [NSString stringWithFormat:@"%@", tweet.favoriteCount];
    
    if ([tweet.favorited isEqual:@1]) {
        UIColor *yellow = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(7/255.0) alpha:1];
    
        cell.favIcon.image = [cell.favIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.favIcon setTintColor:yellow];
        cell.favCountLabel.textColor = yellow;
    } else {
        cell.favCountLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cell.favIcon setTintColor:[UIColor colorWithWhite:0.8 alpha:1]];
    }
    
    // add tap gesture recognizer for author image
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(onImgTap:)];
    
    [cell.authorImageView addGestureRecognizer:tgr];
    cell.authorImageView.tag = indexPath.row;
    
    // so that we can nav to profileView on img tap
    cell.delegate = self;
    cell.tweet = tweet;

    return cell;
}

- (void) onProfileImgTap:(Tweet *)tweet {
    NSLog(@"VC image tapped! %@", tweet.tweetText);
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    ;
    
    vc.user = tweet.author;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    [self.timelineTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *ip = [self.timelineTableView indexPathForCell:cell];

    if ([segue.identifier isEqualToString:@"TweetViewSegue"]) {
        TweetViewController *vc = segue.destinationViewController;
        vc.tweet = self.tweets[ip.row];
    } else if ([segue.identifier isEqualToString:@"ComposeSegue"]) {
        ComposeViewController *vc = segue.destinationViewController;
        vc.isReply = NO;
        vc.delegate = self;
    }
}

- (IBAction)onLogout:(UIButton *)sender {
    [User logout];
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
