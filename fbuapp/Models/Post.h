//
//  Post.h
//  fbuapp
//
//  Created by belchercd on 7/18/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventAuthor;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, assign) NSInteger eventCategory;
@property (nonatomic, assign) NSInteger authorSkillLevel;
@property (nonatomic, assign) NSInteger authorRole;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) PFGeoPoint *eventLocation;
@property (nonatomic, strong) NSString *eventLocationName;
@property (nonatomic, strong) NSNumber *eventPrice;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *authorPhoto;


+ (void) postEvent: (NSString *)title withDescription: (NSString *)description withPrice: (NSNumber *) price withSkill: (NSInteger) authorSkill withLocation: (CLLocation *)location withLocationName: (NSString *) locationName withRole: (NSInteger)authorRole withCategory: (NSInteger)cat withImage: (UIImage *)image withAuthorName:(NSString *)authorName withAuthorPhoto:(NSString *)authorPhoto withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
