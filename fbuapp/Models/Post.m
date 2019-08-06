//
//  Post.m
//  fbuapp
//
//  Created by danielavila on 7/22/19.
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
@dynamic eventLocationName;
@dynamic eventPrice;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postEvent: (NSString *)title withDescription: (NSString *)description withPrice: (NSNumber *) price withSkill: (NSInteger) authorSkill withLocation: (CLLocation *) location withLocationName: (NSString *) locationName withRole: (NSInteger) authorRole withCategory: (NSInteger) cat withImage: (UIImage *)image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.eventTitle = title;
    newPost.eventDescription = description;
    newPost.eventAuthor = [PFUser currentUser].objectId;
    newPost.authorSkillLevel = authorSkill;
    newPost.authorRole = authorRole;
    newPost.eventCategory = cat;
    
    newPost.createdAt = [NSDate date];
    //create a geopoint for parse
    PFGeoPoint *parsePoint = [PFGeoPoint geoPointWithLocation:location];
    newPost.eventLocation = parsePoint;
    newPost.eventLocationName = locationName;
    newPost.eventPrice = price;
    
    newPost.image = [self getPFFileFromImage:image];
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
