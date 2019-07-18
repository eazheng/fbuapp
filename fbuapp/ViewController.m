//
//  ViewController.m
//  fbuapp
//
//  Created by eazheng on 7/16/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO: User is logged in, do work such as go to next view controller.
        //
        //
        
    }   
//        // Optional: Add Facebook Login to Your Code
//        // Add to your viewDidLoad method:
//        loginButton.readPermissions = @[@"public_profile", @"email"];

}

//Testing

@end

