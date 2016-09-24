//
//  HamburgerViewController.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/23/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "HamburgerViewController.h"
#import "ProfileViewController.h"
#import "TimelineViewController.h"
#import "MentionsViewController.h"

@interface HamburgerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentViewTrailingConstraint;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:swipeRight];
    
    self.currentViewLeadingConstraint.constant = -20;
    self.currentViewTrailingConstraint.constant = -20;
    [self initializeViewControllers];
}

- (void) openMenu {
    NSLog(@" swipe right// ");
    [UIView animateWithDuration:0.3 animations:^{
        self.currentViewLeadingConstraint.constant = 200;
        self.currentViewTrailingConstraint.constant = -self.view.bounds.size.width;
        [self.view layoutIfNeeded];
    }];
}

- (void) closeMenu {
    
    NSLog(@" left swpe/// ");
    [UIView animateWithDuration:0.3 animations:^{
        self.currentViewLeadingConstraint.constant = -20;
        self.currentViewTrailingConstraint.constant = -20;
        [self.view layoutIfNeeded];
    }];
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    [self closeMenu];
    
}

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    [self openMenu];
}


- (void)initializeViewControllers {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    // Timeline
    TimelineViewController *tvc = [storyboard instantiateViewControllerWithIdentifier:@"TimelineViewController"];

    UINavigationController *tnvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    tnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    tnvc.navigationBar.tintColor = [UIColor whiteColor];
    [tnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    tnvc.navigationBar.translucent = NO;

    // Profile
    ProfileViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    UINavigationController *pnvc = [[UINavigationController alloc] initWithRootViewController:pvc];
    pnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    pnvc.navigationBar.tintColor = [UIColor whiteColor];
    [pnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    pnvc.navigationBar.translucent = NO;
    
    // Mentions
    MentionsViewController *mvc = [storyboard instantiateViewControllerWithIdentifier:@"MentionsViewController"];
    UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    mnvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    mnvc.navigationBar.tintColor = [UIColor whiteColor];
    [mnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    mnvc.navigationBar.translucent = NO;
    
    self.viewControllers = [NSArray arrayWithObjects:tnvc, pnvc, mnvc, nil];
    
    // set timeline as initial view
    self.currentVC = tnvc;
    self.currentVC.view.frame = self.currentView.bounds;
    [self.currentView addSubview:self.currentVC.view];
    [self.currentVC didMoveToParentViewController:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"My Timeline";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"My Profile";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"My Mentions";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < 3) {
        // add new
        self.currentVC = self.viewControllers[indexPath.row];
        
        [self setNewContentController];
    }
}

- (void)setNewContentController {
    self.currentVC.view.frame = self.currentView.bounds;
    [self.currentView addSubview:self.currentVC.view];
    [self.currentVC didMoveToParentViewController:self];
    [self closeMenu];
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
