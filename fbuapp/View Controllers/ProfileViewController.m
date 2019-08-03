//
//  ProfileViewController.m
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "PostTableView.h"
#import "SettingsViewController.h"
#import "PostCell.h"
#import "Favorite.h"
#import "Post.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBSDKProfile.h"
#import "Parse/Parse.h"




@interface ProfileViewController () <PostCellDelegate, PostTableViewDelegate> 
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) PFQuery *postQuery;
@property PostTableView * feed;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *userPosts;
//@property (nonatomic, strong) NSString *objectId;







@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation bar button to send user back to HomeViewController.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack)];
    
    //Navigation bar button to send user to SettingsViewController.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettings)];
    
    self.postQuery = [Post query];
    self.feed = [[PostTableView alloc] initWithUserId:[PFUser currentUser].objectId]; //[PFUser currentUser].username
    [self fetchUserPosts];
    self.feed.delegate = self;
    [self.view addSubview:self.feed];

    
    //Set current user's information to their profile page.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];
        NSLog(@"Current user: %@", currentUser.email);
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
        
        NSLog(@"First: %@", currentUser[@"firstName"]);
    }
    else {
        NSLog(@"Error, user not found");
    }
    
    //make profile image circular --> condense into a helper
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
    self.profilePictureView.clipsToBounds = YES;
    //add border to profile image
    self.profilePictureView.layer.borderWidth = 3.0f;
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    //Shadow and Radius of profile View
    self.profileView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.profileView.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.profileView.layer.shadowOpacity = 1.0f;
    self.profileView.layer.shadowRadius = 0.0f;
    self.profileView.layer.cornerRadius = 4.0f;
}


//load user's posts to their profile
- (void)fetchUserPosts {
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts != nil) {
            NSLog(@"Loaded User's posts");
            self.userPosts = posts;
            [self.feed reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchUserPosts];
}


- (void)didTapBack {
    //Take User back to HomeViewController
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    homeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


- (void)didTapSettings {
    //Take User to Settings Page
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion: nil];

}


@end
