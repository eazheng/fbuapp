//
//  LocationCell.h
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property Post *post;
@property (weak, nonatomic) IBOutlet GMSMapView *mapLocationView;

@end

NS_ASSUME_NONNULL_END
