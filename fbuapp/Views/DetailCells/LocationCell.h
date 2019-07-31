//
//  LocationCell.h
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationCityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDistanceLabel;
@property Post *post;

@end

NS_ASSUME_NONNULL_END
