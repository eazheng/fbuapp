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
    
    //Auto-fill user profile
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        NSLog(@"Current user: %@", currentUser.email);
        [currentUser fetch];
        self.profileImage.image = currentUser[@"profilePicture"];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = YES;
        self.firstNameLabel.text = currentUser[@"firstName"];
        self.lastNameLabel.text = currentUser[@"lastName"];
        self.usernameLabel.text = currentUser.username;
        
        NSLog(@"First: %@", currentUser[@"firstName"]);
    }
}


@end
