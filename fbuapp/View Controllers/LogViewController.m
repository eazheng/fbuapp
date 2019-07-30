//
//  LogViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "LogViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create facebook login button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    //connected to a visible view
    loginButton.center = self.loginButtonView.center;
    //ask user for access to information
    loginButton.permissions = @[@"public_profile"];
    loginButton.permissions = @[@"email"];
    //displays the created button
    [self.view addSubview:loginButton];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    else {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


@end
