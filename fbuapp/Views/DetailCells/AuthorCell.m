//
//  AuthorCell.m
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "AuthorCell.h"

@implementation AuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fbProfileView.layer.cornerRadius = self.fbProfileView.frame.size.width / 2;
    self.fbProfileView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
