//
//  Categories.m
//  fbuapp
//
//  Created by danielavila on 7/25/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "Category.h"

@implementation Category

@dynamic eventCategory;
@dynamic eventCategoryID;
@dynamic eventCategoryColor;

+ (nonnull NSString *)parseClassName {
    return @"Category";
}

+ (void) addCategory: (NSString *)category withID: (NSInteger) categoryID withColor: (NSArray *) categoryColor withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Category *newCategories = [Category new];
    newCategories.eventCategory = category;
    newCategories.eventCategoryID = categoryID;
    newCategories.eventCategoryColor = categoryColor;
    [newCategories saveInBackgroundWithBlock: completion];
}

@end
