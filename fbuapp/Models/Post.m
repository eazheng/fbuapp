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
@dynamic authorSkillLevel;
@dynamic createdAt;
@dynamic eventLocation;
@dynamic eventPrice;

+ (void) postEvent: (NSString *)title withDescription: (NSString *)description withPrice: (NSNumber *) price withSkill: (NSString *) authorSkill withLocation: (CLLocation *)location withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.eventTitle = title;
    newPost.eventDescription = description;
    newPost.eventAuthor = [PFUser currentUser];
    newPost.authorSkillLevel = authorSkill;
    
    newPost.createdAt = [NSDate date];
    newPost.eventLocation = location;
    newPost.eventPrice = price;
    
    [newPost saveInBackgroundWithBlock: completion];
}

@end
