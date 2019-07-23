//
//  PostCell.m
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userProfilePhoto.layer.cornerRadius = 25;
    self.userProfilePhoto.clipsToBounds = YES;
    self.eventImage.layer.cornerRadius = 20;
    self.eventImage.clipsToBounds = YES;
    
    // Initialization code
}
- (IBAction)onFavoriteTapped:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end