//
//  ProfileViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBSDKProfile.h"


@interface ProfileViewController ()


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set current user's information to their profile page.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];
        NSLog(@"Current user: %@", currentUser.email);
        
        self.profileImage.image = currentUser[@"profilePicture"];
        self.firstNameLabel.text = [NSString stringWithFormat:@"@%@", currentUser[@"firstName"]];
        self.lastNameLabel.text = currentUser[@"lastName"];
        self.usernameLabel.text = currentUser.username;
        
        NSLog(@"First: %@", currentUser[@"firstName"]);
    }
}


@end
