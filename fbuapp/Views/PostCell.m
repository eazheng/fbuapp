//
//  PostCell.m
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PostCell.h"
#import "Favorite.h"
#import "HomeViewController.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.eventImage.layer.cornerRadius = 17;
    self.eventImage.clipsToBounds = YES;
    self.eventImage.contentMode = UIViewContentModeScaleToFill;
    self.fbProfilePhoto.layer.cornerRadius = self.fbProfilePhoto.frame.size.width / 2;
    self.fbProfilePhoto.clipsToBounds = YES;
    
}

- (IBAction)onTapFavorited:(id)sender {
    if(self.isFavorited == NO){
        self.isFavorited = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateNormal];
        [self.delegate favoritePost: self.post.objectId withUser: self.currentUserId];
    }
    else{
        self.isFavorited = NO;
        [self.favoriteButton setImage:[UIImage imageNamed:@"notfavorited"] forState:UIControlStateNormal];
        [self.delegate unFavoritePost: self.post.objectId withUser: self.currentUserId];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onTapCell:(id)sender {
}


@end
