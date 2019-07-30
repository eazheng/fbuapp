//
//  RegisterViewController.m
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "LogViewController.h"
#import "ProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Parse/Parse.h"
#import "FBSDKProfile.h"

@interface RegisterViewController ()


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([FBSDKAccessToken currentAccessToken]) {
        
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                
                //access to user's email
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"user:%@", result);
                         self.emailField.text = result[@"email"];
                     }
                 }];
                
                //get user's first and last name
                self.firstNameField.text = profile.firstName;
                self.lastNameField.text = profile.lastName;
                //test
                NSLog(@"Hello %@!", profile.firstName);
                //welcome user to app within navigation bar
                self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@", profile.firstName];
    
                //display users's facebook profile picture
                FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
                profilePictureView.frame = CGRectMake(124, 99, 125, 125);
                //show profile of current user logged in
                profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
                profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2;
                profilePictureView.clipsToBounds = YES;
                [self.view addSubview:profilePictureView]; 

            }
        }];
    }
}


- (IBAction)signupButton:(id)sender {
    
    //initialize the object
    PFUser *newUser = [PFUser user];
    
//    newUser[@"profilePicture"] = self.pictureView.image;
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = @" ";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error!= nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
            ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            [self presentViewController:profileViewController animated:YES completion:nil];
        }
    }];
}


@end
