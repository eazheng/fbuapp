//
//  PFGeoPoint+Helpers.h
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PFGeoPoint (Helpers)

+ (NSString *)distanceToPoint: (PFGeoPoint *) point fromLocation: (CLLocation *) location;


@end

NS_ASSUME_NONNULL_END
