//
//  TweetViewCell.m
//  Twitterific
//
//  Created by Yash Kshirsagar on 9/21/16.
//  Copyright © 2016 Yash Kshirsagar. All rights reserved.
//

#import "TweetViewCell.h"

@implementation TweetViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) onImgTap:(id) sender {
    NSLog(@"cell, on author image tap! %@", self.tweet);
    
    // notify delegate of the tweet that the image is associated with
    [self.delegate onProfileImgTap:self.tweet];
}

@end
