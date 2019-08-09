//
//  LocationCell.m
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// brings user to google map of location
- (IBAction)locationButtonAction:(id)sender {
    NSLog(@"Pressed location button");
    NSLog(@"Post: %@", self.post);
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", self.post.eventLocation.latitude, self.post.eventLocation.longitude];
    NSString *linkString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@", locationString];
    NSLog(@"Location string: %@", linkString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: linkString] options:@{} completionHandler:nil];
    
}

@end
