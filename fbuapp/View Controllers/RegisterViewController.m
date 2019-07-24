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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Parse/Parse.h"
#import "FBSDKProfile.h"

@interface RegisterViewController ()


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // maybe use --> dispatch_async(dispatch_get_main_queue(), ^{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        //FBSDK --> gets user's name and user ID
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                //access to user's email --> error: only getting "email" and not the actual value
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"user:%@", result);
                     }
                 }];
                //creating dictionary to pull out and utilized the user's email
                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                [parameters setValue:@"email" forKey:@"fields"];
                //set dictionary value to emailField
                self.emailField.text = parameters[@"fields"];
    
                //get user's first and last name
                //setting my created properties to currentProfile properties
                self.firstNameField.text = profile.firstName;
                self.lastNameField.text = profile.lastName;
                
                //test
                NSLog(@"Hello" " " "%@!", profile.firstName);
                
                //welcome user to app in navigation bar
                self.navigationItem.title = [NSString stringWithFormat:@"Welcome" " " "%@", profile.firstName];
                
                //display users's facebook profile picture
                FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
                //manual placement of profile page
                profilePictureView.frame = CGRectMake(137, 103, 100, 100);
                //show profile of current user logged in
                profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
                [self.view addSubview:profilePictureView];
            }
        }];
    }
}


- (IBAction)signupButton:(id)sender {
    //initialize the object
    PFUser *newUser = [PFUser user];
    
    //initialize full name and email from facebook
    // set properties user's app profile
    newUser[@"profilePicture"] = self.pictureView.image;
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
  
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error!= nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
            //present ProfileViewController
        }
    }];
}


- (IBAction)addPhotoButton:(id)sender {
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
