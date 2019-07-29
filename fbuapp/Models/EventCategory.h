//
//  EventCategory.h
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventCategory : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *color;
@property (nonatomic, assign) NSInteger idNumber;

@end

NS_ASSUME_NONNULL_END
