//
//  ImageCell.m
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"In IMAGE CELL");
//
//    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//                if (!error) {
//                    self.eventImageView.image = [UIImage imageWithData:data];
//                    NSLog(@"LINE 20");
//                }
//                else {
//                    NSLog(@"Error getting image: %@", error.localizedDescription);
//                }
//        }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
