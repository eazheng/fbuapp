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
#import "LogViewController.h"
#import "EditViewController.h"
#import "RegisterViewController.h"
#import "PostCell.h"
#import "Favorite.h"
#import "Post.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBSDKProfile.h"
#import "Parse/Parse.h"
#import "Masonry.h"






@interface ProfileViewController () <PostTableViewDelegate>
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) PFQuery *postQuery;
@property (strong, nonatomic) PostTableView * feed;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *userPosts;
@property (nonatomic, strong) UISegmentedControl *mainSegment;
@property (nonatomic, strong) NSArray *userFavorites;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation bar button to send user back to HomeViewController.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonDidLogOut:)];
    
    //Navigation bar button to send user to SettingsViewController.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTapEdit)];
    
    //Set current user's information to their profile page.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];
        NSLog(@"Current user: %@", currentUser.email);

        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
        self.bioLabel.text = currentUser[@"bio"];
//        self.profilePictureView = currentUser[@"profileId"];
    }
    else {
        NSLog(@"Error, user not found");
    }
    
    //creating segment control bar
    self.mainSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Posts", @"Saved", nil]];
    self.mainSegment.frame = CGRectMake(87, 261, 200, 30);
    self.mainSegment.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.mainSegment.layer.shadowOpacity = 0.25f;
    self.mainSegment.selectedSegmentIndex = 1;
    [self.mainSegment addTarget:self action:@selector(fetchPosts) forControlEvents: UIControlEventValueChanged];
    [self.profileView addSubview:self.mainSegment];
    

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
    
    //initialize
    self.postQuery = [Post query];
    self.feed = [[PostTableView alloc] initWithUserId:@"myuserid"]; //[PFUser currentUser].username
    [self fetchPosts];
    self.feed.delegate = self;
    [self.postView addSubview:self.feed];
    [self.feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.postView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Profile"];
    
}


//load user's posts to their profile
- (void)fetchPosts {
    if(self.mainSegment.selectedSegmentIndex == 0)
    {
        // action for the first button (Current or Default)
        [self.postQuery orderByDescending:@"createdAt"];
        self.postQuery.limit = 20;
        [self.postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
            if (posts) {
                self.feed.posts = [NSArray arrayWithArray:posts];
                [self.feed reloadData];
            }
            else {
                NSLog(@"Failed to fetch posts from server");
            }
        }];
        
        
        PFQuery *postQuery = [Post query];
        [postQuery whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);

            }
            else {
                //If posts associated with current user's parse Id are found, and them into an array. Those posts within the array to to be loaded onto table.
                NSLog(@"Loaded User's posts");
                self.feed.posts = posts;
                [self.feed reloadData];
            }
        }];
        [self.feed.refreshControl endRefreshing];
    }
    else if(self.mainSegment.selectedSegmentIndex == 1) {
        ///query for posts that have been saved
        PFQuery *favoriteQuery = [Favorite query];
        [favoriteQuery whereKey: @"userID" equalTo: [PFUser currentUser].objectId];
        [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);

            }
            else{
                NSLog(@"Loaded User's favorties");
                self.feed.posts = posts;
                [self.feed reloadData];
            }
        }];
    }
//        [self.feed.refreshControl endRefreshing];
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchPosts];
}


- (void)didTapEdit {
    EditViewController *editViewController = [[EditViewController alloc] init];
    editViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    editViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    //Clearing out current PFUser --> will now be nil
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //Take User back to LogViewController
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LogViewController *logViewController = [[LogViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
        appDelegate.window.rootViewController = navigationController;
    }];
    //logout of actual facebook account
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}

- (void) favoritePost: (NSString *)post withUser: (NSString *)user{
    
}
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user{
    
}



@end
