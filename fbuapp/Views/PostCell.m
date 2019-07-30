//
//  PostCell.m
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PostCell.h"
#import "Favorite.h"

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
    if(self.isFavorited == NO){
        self.isFavorited = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateNormal];
        [Favorite postID: self.post.objectId userID: @"one" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {//need actual userID here
            if(!succeeded){
                NSLog(@"Error favoriting event: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Favoriting event success!");
            }
        }];//dka need actual userID
        
    }
    else{
        self.isFavorited = NO;
        [self.favoriteButton setImage:[UIImage imageNamed:@"notfavorited"] forState:UIControlStateNormal];
        PFQuery *favoriteQuery = [Favorite query];
        [favoriteQuery whereKey: @"postID" equalTo: self.post.objectId];
        [favoriteQuery whereKey: @"userID" equalTo: @"one"];//need actual userID here
        [favoriteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *favoritedPost, NSError *error) {
            if (favoritedPost) {
                [favoritedPost deleteInBackground];
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
