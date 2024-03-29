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
#import "UIImageView+AFNetworking.h"

@interface RegisterViewController ()

@property (strong, nonatomic) UIImage *picImage;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *profileId;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didCancel)];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                //Get access to user's facebook email
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email, id"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"user:%@", result);
                         self.emailField.text = result[@"email"];
                         self.userId = result[@"id"];
                     }
                 }];
                
                self.firstNameField.text = profile.firstName;
                self.lastNameField.text = profile.lastName;
                NSLog(@"Hello %@!", profile.firstName);
                
                self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
                self.profilePictureView.clipsToBounds = YES;
                self.profilePictureView.layer.borderWidth = 3.0f;
                self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;

                self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@", profile.firstName];
            }
        }];
    }
    
    self.signupButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.signupButton.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.signupButton.layer.shadowOpacity = 1.0f;
    self.signupButton.layer.shadowRadius = 0.0f;
    self.signupButton.layer.cornerRadius = 4.0f;
}


- (void)didCancel {
    //Take User back to LogViewController
    LogViewController *logViewController = [[LogViewController alloc] init];
    logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController ];
    [self presentViewController:navigationController animated:YES completion: nil];
    //logout of FB to retry registration
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}


- (IBAction)signupButton:(id)sender {
    //initialize the object
    PFUser *newUser = [PFUser user];
    
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = @" ";
    newUser[@"fbUserId"] = self.userId;
    newUser[@"bio"] = @"";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            //logout of FB to retry registration
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
        }
        else {
            NSLog(@"User registered successfully");
            //take newUser to their profile page
//            ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
//            profileViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//            profileViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
//            [self presentViewController:navigationController animated:YES completion: nil];
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = appDelegate.tabBarController;
            [appDelegate.tabBarController.tabBar setHidden:NO];
        }
    }];
}



@end
