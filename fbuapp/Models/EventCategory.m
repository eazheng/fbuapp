//
//  EventCategory.m
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "EventCategory.h"

@implementation EventCategory


@dynamic color;
@dynamic name;
@dynamic idNumber;

+ (nonnull NSString *)parseClassName {
    return @"EventCategory";
}

@end
