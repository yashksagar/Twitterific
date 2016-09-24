//
//  ProfileView.h
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/23/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIView

@property (strong, nonatomic) NSString *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
