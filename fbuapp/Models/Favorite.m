//
//  Favorite.m
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

@dynamic postID;
@dynamic userID;

+ (nonnull NSString *)parseClassName {
    return @"Favorite";
}

+ (void) postID: (NSString *)post userID: (NSString *)user withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Favorite *newFavorite = [Favorite new];
    newFavorite.postID = post;
    newFavorite.userID = user;
}

@end
