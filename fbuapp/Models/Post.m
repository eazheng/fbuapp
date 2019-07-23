
//
//  Post.m
//  fbuapp
//
//  Created by belchercd on 7/18/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic eventTitle;
@dynamic eventAuthor;
@dynamic eventDescription;
@dynamic eventCategory;
@dynamic authorSkillLevel;
@dynamic authorRole;
@dynamic createdAt;
@dynamic eventLocation;
@dynamic eventPrice;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postEvent: (NSString *)title withDescription: (NSString *)description withPrice: (NSNumber *) price withSkill: (NSInteger) authorSkill withLocation: (CLLocation *)location withRole: (NSInteger) authorRole withCategory: (NSInteger) cat withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.eventTitle = title;
    newPost.eventDescription = description;
    newPost.eventAuthor = [PFUser currentUser];
    newPost.authorSkillLevel = authorSkill;
    newPost.authorRole = authorRole;
    newPost.eventCategory = cat;
    
    newPost.createdAt = [NSDate date];
    //newPost.eventLocation = location;
    //create a geopoint for parse
    PFGeoPoint *parsePoint = [PFGeoPoint geoPointWithLocation:location];
    newPost.eventLocation = parsePoint;
    newPost.eventPrice = price;
    
    [newPost saveInBackgroundWithBlock: completion];
}

@end
