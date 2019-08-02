//
//  Profile.m
//  fbuapp
//
//  Created by belchercd on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "Profile.h"
#

@implementation Profile

@dynamic currentUser;
@dynamic firstName;
@dynamic lastName;
@dynamic username;
@dynamic bio;

+ (void) userProfile {
    self.firstName = currentUser[@"firstName"];
    self.lastName = currentUser[@"lastName"];
    self.username = currentUser.username;
}

//PFUser *currentUser = [PFUser currentUser];
//if (currentUser != nil) {
//    [currentUser fetch];

@end
