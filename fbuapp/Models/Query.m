//
//  Query.m
//  fbuapp
//
//  Created by danielavila on 8/5/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "Query.h"


@implementation Query

- (id) init{ //(NSString *)eventName withCategory: (NSInteger) eventCategory withRole: (NSArray *)authorRole withLevel: (NSArray *)authorLevel withPrice: (NSNumber *) eventPrice withDistance: (float) eventDistance{
    self = [super init];
    self.name = @"";
    self.category = -1;
//    self.role = [[NSIndexSet alloc] init];
//    self.level = nil;
    self.price = -1.0;
    self.distance = -1.0;
    return self;
}



@end
