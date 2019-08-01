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
@property (strong, nonatomic) UIImage *picImage;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Creating navigation bar button to send user back to LogViewController.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didCancel)];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                //Get access to user's facebook email
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
                
                //Welcome user
                self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@", profile.firstName];
            }
        }];
    }
    
    // Shadow and Radius of signupButton
    self.signupButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.signupButton.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.signupButton.layer.shadowOpacity = 1.0f;
    self.signupButton.layer.shadowRadius = 0.0f;
    self.signupButton.layer.cornerRadius = 4.0f;
    
    //make profile image circular
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
    self.profilePictureView.clipsToBounds = YES;
    //add border to profile image
    self.profilePictureView.layer.borderWidth = 3.0f;
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;

}


- (void)didCancel {
    //Dismiss RegisterViewController and head back to LogViewController.
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    registerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)signupButton:(id)sender {
    
    //initialize the object
    PFUser *newUser = [PFUser user];
    
    UIImage *image = [[FBSDKProfile currentProfile] imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(100, 100)];
    newUser[@"profilePicture"] = [PFFileObject fileObjectWithData:UIImagePNGRepresentation(image)];
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = @" ";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
            //take newUser to their profile page
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
            profileViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            profileViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            [self presentViewController:navigationController animated:YES completion: nil];
        }
    }];
}


@end
