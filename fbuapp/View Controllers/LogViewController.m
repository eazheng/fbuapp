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

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create facebook login button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    // center button
    loginButton.center = self.loginButtonView.center;
    //ask user for access to information
    loginButton.permissions = @[@"public_profile", @"email"];
    //displays the created button
    [self.view addSubview:loginButton];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    
    // take user to profile after successful login
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    else {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





//if ([FBSDKAccessToken currentAccessToken]) {
//    // TODO: User is logged in, do work such as go to next view controller.
//    //
//    //
//}
//

//
//[FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
//[[NSNotificationCenter defaultCenter] addObserverForName:FBSDKProfileDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock: ^(NSNotification *notification) {
//    if ([FBSDKProfile currentProfile]) {
//        // Update for new user profile
//    }
//}];




@end
