//
//  LogViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "LogViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "UIColor+Helpers.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fbloginButton = [[FBSDKLoginButton alloc] init];
    self.fbloginButton.loginBehavior = FBSDKLoginBehaviorBrowser;
    self.fbloginButton.delegate = self;
    self.fbloginButton.frame = CGRectMake(110,500,200,40);
    
    self.fbloginButton.permissions = @[@"public_profile"];
    self.fbloginButton.permissions = @[@"email"];

    self.fbloginButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.fbloginButton.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.fbloginButton.layer.shadowOpacity = 1.0f;
    self.fbloginButton.layer.shadowRadius = 0.0f;
    self.fbloginButton.layer.cornerRadius = 4.0f;
    
    NSArray *color = @[@237, @167, @114];
    self.backgroundView.backgroundColor = [UIColor colorWithRGB:color];
    self.mainView.backgroundColor = [UIColor colorWithRGB:color];
    self.scrollView.backgroundColor = [UIColor colorWithRGB:color];
    
    [self.view addSubview:self.fbloginButton];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if ([FBSDKAccessToken currentAccessToken]) {
        
        //access to user's email
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"user:%@", result);

                 [self createQuery:result[@"email"]];
             }
         }];
    }
}


- (void)createQuery:(NSString *)email {
    
    //Search if user's facebook email is linked to an existing PFUser.
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"%@", objects);
        PFUser *user = objects.firstObject;
        if (user) {
            NSLog(@"Existing user found");
            //log user into app.
            [PFUser logInWithUsername:user.username password:@" "];
            
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = appDelegate.tabBarController;
            [appDelegate.tabBarController setSelectedIndex:0];
        }
        else {
            //If email does not match an existing user, take user to register an account
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
