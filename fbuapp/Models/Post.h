//
//  Post.h
//  fbuapp
//
//  Created by belchercd on 7/18/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) PFUser *eventAuthor;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *authorSkillLevel;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) CLLocation *eventLocation;
@property (nonatomic, strong) NSNumber *eventPrice;

+ (void) postEvent: (NSString *)title withDescription: (NSString *)description withPrice: (NSNumber *) price withSkill: (NSString *) authorSkill withLocation: (CLLocation *)location withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end

NS_ASSUME_NONNULL_END
