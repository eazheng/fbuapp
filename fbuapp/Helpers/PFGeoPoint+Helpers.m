//
//  PFGeoPoint+Helpers.m
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PFGeoPoint+Helpers.h"

@implementation PFGeoPoint (Helpers)

+ (NSString *)distanceToPoint: (PFGeoPoint *) point fromLocation: (CLLocation *) location{
    double dist =[point distanceInMilesTo :[PFGeoPoint geoPointWithLocation: location]];
    return [NSString stringWithFormat:@"%.1f", dist];
}

@end
