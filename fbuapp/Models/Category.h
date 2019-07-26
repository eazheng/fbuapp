//
//  Categories.h
//  fbuapp
//
//  Created by danielavila on 7/25/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *eventCategory;
@property (nonatomic, strong) NSArray *eventCategoryColor;
@property (nonatomic, assign) NSInteger eventCategoryID;

+ (void) addCategory: (NSString *)category withID: (NSInteger) categoryID withColor: (NSArray *) categoryColor withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END


