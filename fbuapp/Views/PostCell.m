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
    self.eventImage.layer.cornerRadius = 17;
    self.eventImage.clipsToBounds = YES;
    self.eventImage.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)onTapFavorited:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
