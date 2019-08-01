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
        
        //make profile image circular
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = YES;
        //give profileView a shadow
        self.profileView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
        self.profileView.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.profileView.layer.shadowOpacity = 1.0f;
        self.profileView.layer.shadowRadius = 0.0f;
        self.profileView.layer.cornerRadius = 4.0f;
    }
}


@end
