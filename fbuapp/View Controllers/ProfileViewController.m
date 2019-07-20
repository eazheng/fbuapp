//
//  ProfileViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface ProfileViewController ()
@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, copy, readonly) NSString *userID;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                //welcome user
                NSLog(@"Hello, %@!", profile.firstName);
            }
        }];
    });
    
    //display users's facebook profile picture
    FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
    //manual placement on profile page
    profilePictureView.frame = CGRectMake(137, 70, 95, 95);
    //show profile of current user logged in
    profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
    [self.view addSubview:profilePictureView];
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
