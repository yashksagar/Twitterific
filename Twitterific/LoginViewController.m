//
//  ViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/19/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UILabel *userNameLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginLabel.text = @"Hello stranger, please log in!";
    [self.loginButton.layer setCornerRadius:5.0f];
}

- (IBAction)onLoginButtonTap:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // proceed to logged-in state
            self.loginButton.userInteractionEnabled = NO;
            self.loginButton.alpha = 0.7;
            [self.loginButton setTitle:@"Logging in..." forState:UIControlStateNormal];

            self.loginLabel.text = [NSString stringWithFormat:@"Welcome, @%@!",user.screenName];
            self.loginLabel.textColor = [UIColor greenColor];
            self.loginLabel.font = [UIFont boldSystemFontOfSize:21.0];
            
            // delay modal segue for logging-in experience
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"HamburgerSegue" sender:self];
            });
            
        } else {
            // show error
            NSLog(@"error logging in!");
            self.loginLabel.text = @"Oops! Error logging in, please try again.";
            self.loginLabel.textColor = [UIColor redColor];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
