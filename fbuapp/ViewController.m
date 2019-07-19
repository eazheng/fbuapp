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
#import "AppDelegate.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create login button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // center button
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        // TODO: User is logged in, do work such as go to next view controller.
        //
        //
        
    }
    
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
        if (profile){
            NSLog(@"Hello, %@!", profile.firstName);
        }
    }];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKProfileDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock: ^(NSNotification *notification) {
        if ([FBSDKProfile currentProfile]) {
            // Update for new user profile
        }
    }];
    
    //display users's facebook profile picture
    FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
    profilePictureView.frame = CGRectMake(0,0, 100, 100);
    //show profile of current user logged in
    profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
    [self.view addSubview:profilePictureView];
    
}

//Testing


@end

