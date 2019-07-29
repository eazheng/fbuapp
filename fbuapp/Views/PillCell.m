//
//  PillCell.m
//  fbuapp
//
//  Created by danielavila on 7/24/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PillCell.h"

@implementation PillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIView *selectedBackgroundViewForCell = [UIView new];
    [selectedBackgroundViewForCell setBackgroundColor:[UIColor lightGrayColor]];
//    theCell.selectedBackgroundView = selectedBackgroundViewForCell;

    self.selectedBackgroundView = selectedBackgroundViewForCell;
}
@end
