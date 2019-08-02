//
//  Profile.h
//  fbuapp
//
//  Created by belchercd on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *bio;

@end

NS_ASSUME_NONNULL_END
