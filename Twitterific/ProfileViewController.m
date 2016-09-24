//
//  ProfileViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/23/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.user == nil) {
        NSLog(@"user not found.. ");
        // set to current user
        
        self.user = [User getCurrentUser];
    }

    NSLog(@"user is:: %@", self.user.name);
    
    self.navigationItem.title = @"Profile";
    UINib *pvNib = [UINib nibWithNibName:@"ProfileView" bundle:nil];
    NSArray * objects = [pvNib instantiateWithOwner:self options:nil];
    
    UIView *v = objects[0];
    
    self.userNameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenName;
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%@", self.user.tweetsCount];
    
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followingCount];

    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImgUrl]];
    [self.profileImageView.layer setCornerRadius:5.0f];
    [self.profileImageView.layer setMasksToBounds:YES];
    [self.bgImageView setImageWithURL:[NSURL URLWithString:self.user.profileBannerUrl]];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.bgImageView.image == nil) {
        self.bgImageView.backgroundColor = [UIColor blackColor];
    }
    
    self.bgImageView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImageView.alpha = 1;
    }];
    
    v.frame = self.view.bounds;

    [self.view addSubview:v];
}


- (void)viewWillDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgImageView.alpha = 0;
    }];
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
