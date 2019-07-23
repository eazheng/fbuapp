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
#import "FBSDKProfile.h"



@interface ProfileViewController ()
@property (nonatomic, copy, readonly, nullable) NSString *name;
//@property (nonatomic, copy, readonly, nullable) NSString *firstName;
//@property (nonatomic, copy, readonly, nullable) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *userID;


//@property (nonatomic, readonly, nullable) NSURL *linkURL;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            if (profile){
                
                //get useres user's first and last name
                self.nameLabel.text = profile.name;
//                self.navigationItem.title = [NSString stringWithFormat:@"Hello" "%@" "%@", profile.firstName, profile.lastName];
//                //welcome user
//                NSLog(@"Hello, %@!", profile.name);
                
                //display users's facebook profile picture
                FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
                //manual placement on profile page
                profilePictureView.frame = CGRectMake(136, 83, 100, 100);
                //show profile of current user logged in
                profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
                [self.view addSubview:profilePictureView];
            }
        }];
    });
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Edit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didLogout:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
}



//- (NSInteger)tableView:(UITableView *)tableVienkejvgvbubuvirejetkuhilklutehlbrw numberOfRowsInSection:(NSInteger)section {
//}
//
//// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
//// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//
//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutButton:(id)sender {
}

- (IBAction)didEdit:(id)sender {
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"LogoutButton"];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didEdit:)];
    navigationItem.rightBarButtonItem = editButton;
}

//- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
//    NSLog(@"User has logged out");
//    //sent to delegate once user logs out
//}

- (IBAction)didLogout:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];


}
@end
