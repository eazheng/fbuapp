//
//  LogViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "LogViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface LogViewController ()
@property (strong, nonatomic) NSString *userEmail;



@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //create facebook login button
    FBSDKLoginButton *fbloginButton = [[FBSDKLoginButton alloc] init];
    fbloginButton.delegate = self;
    //connected to a visible view
    fbloginButton.center = self.loginButtonView.center;
    //ask user for access to information
    fbloginButton.permissions = @[@"public_profile"];
    fbloginButton.permissions = @[@"email"];
    // Shadow and Radius of signupButton
    fbloginButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    fbloginButton.layer.shadowOffset = CGSizeMake(0, 2.0f);
    fbloginButton.layer.shadowOpacity = 1.0f;
    fbloginButton.layer.shadowRadius = 0.0f;
    fbloginButton.layer.cornerRadius = 4.0f;
    
    [self.view addSubview:fbloginButton];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    //access to user's email
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"user:%@", result);
                 //call query
                 [self createQuery:result[@"email"]];
             }
         }];

}


- (void)createQuery:(NSString *)email {
    
    //Create query to search if user's facebook email is linked to an existing PFUser.
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        PFUser *user = objects.firstObject;
        if (user) {
            NSLog(@"Existing user found");
            //log user into app.
            [PFUser logInWithUsername:user.username password:@" "];

            //Take existing user to HomeViewController
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            homeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            [self presentViewController:navigationController animated:YES completion: nil];
            
        }
        else {
            //If email does not match an existing user, take user to RegisterViewController to create an account
            NSLog(@"User not found, must create new account");
            RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
            registerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            registerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
            [self presentViewController:navigationController animated:YES completion: nil];
        }
    }];
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

}


@end
