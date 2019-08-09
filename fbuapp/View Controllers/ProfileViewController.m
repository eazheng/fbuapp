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
#import "AppDelegate.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <PostTableViewDelegate, DetailsViewDelegate>

@property (strong, nonatomic) PFQuery *postQuery;
@property (strong, nonatomic) PostTableView * feed;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UISegmentedControl *mainSegment;
@property (strong, nonatomic) NSArray *favoritePosts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonDidLogOut:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(didTapEdit)];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Profile"];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];
        NSLog(@"Current user: %@", currentUser.email);
        NSLog(@"Current user profileId: %@", self.profilePictureView.profileID);
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
        self.bioLabel.text = currentUser[@"bio"];
    }
    else {
        NSLog(@"Error, user not found");
    }
    
    //update user info to profile view
    [[NSNotificationCenter defaultCenter] addObserverForName:(@"informationSaved") object:(nil) queue:(nil) usingBlock:^(NSNotification * _Nonnull note) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
        self.bioLabel.text = currentUser[@"bio"];
    }];
    
    //creating segment control bar
    self.mainSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Posts", @"Saved", nil]];
    self.segmentedControl.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.segmentedControl.layer.shadowOpacity = 0.25f;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(fetchPosts) forControlEvents: UIControlEventValueChanged];
    

    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.borderWidth = 3.0f;
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.profileView.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.profileView.layer.shadowOpacity = 1.0f;
    self.profileView.layer.shadowRadius = 0.0f;
    self.profileView.layer.cornerRadius = 4.0f;
    
    //initialize
    self.postQuery = [Post query];
    self.feed = [[PostTableView alloc] initWithUserId:[PFUser currentUser].objectId];
    [self fetchPosts];
    self.feed.delegate = self;
    [self.postView addSubview:self.feed];
    [self.feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.postView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Profile"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
}


//load user's posts to their profile
- (void)fetchPosts {
    if(self.segmentedControl.selectedSegmentIndex == 0)
    {
//        [self checkCount];
        ///query for posts that user created
        [self.postQuery orderByDescending:@"createdAt"];
        [self.postQuery whereKey:@"eventAuthor" equalTo:[PFUser currentUser].objectId];
        [self.postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            else {
                NSLog(@"Loaded User's posts");
                self.feed.posts = [NSMutableArray arrayWithArray:posts];
                [self checkCount];
                NSLog(@"%@", posts);
                [self.feed reloadData];
            }
        }];
        [self.feed.refreshControl endRefreshing];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1) {
//        [self checkCount];
        ///query for posts that have been saved
        PFQuery *favoriteQuery = [Favorite query];
        [favoriteQuery whereKey:@"userID" equalTo: [PFUser currentUser].objectId];
        [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable favoritePosts, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                NSLog(@"Accessed User's favorties");
                self.feed.posts = [NSMutableArray arrayWithArray:favoritePosts];
                NSLog(@"%@", favoritePosts);
                
                PFQuery *postQuery = [Post query];
                [postQuery orderByDescending:@"createdAt"];
                [postQuery whereKey:@"objectId" matchesKey:@"postID" inQuery: favoriteQuery];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.localizedDescription);
                    }
                    else {
                        NSLog(@"Loaded User's favorties");
                        self.feed.posts = [NSMutableArray arrayWithArray:objects];
                        [self checkCount];
                        NSLog(@"%@", objects);
                        [self.feed reloadData];
                    }
                }];
            }
            
        }];
    }
    else {
        NSLog(@"Should not have reached here");
    }
    [self.feed.refreshControl endRefreshing];
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
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}


- (void)loginButtonDidLogOut:(UIBarButtonItem *)loginButton {
    //Clearing out current PFUser --> will now be nil
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //Take User back to LogViewController
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LogViewController *logViewController = [[LogViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
        appDelegate.window.rootViewController = navigationController;
        //logout of actual facebook account
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }];

}


- (void)checkCount {
    if (self.feed.posts.count == 0) {
        NSLog(@"No posts");
        self.emptyPostsLabel.text = @"[You have no posts to display]";
    }
    else {
        NSLog(@"You have posts");
        self.emptyPostsLabel.text = @" ";
    }
}


- (void) favoritePost: (NSString *)post withUser: (NSString *)user{
    [Favorite postID: post userID: user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"Error favoriting event: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Favoriting event success!");
        }
    }];
}


- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user{
    PFQuery *favoriteQuery = [Favorite query];
    [favoriteQuery whereKey: @"postID" equalTo: post];
    [favoriteQuery whereKey: @"userID" equalTo: user];
    [favoriteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *favoritedPost, NSError *error) {
        if (favoritedPost) {
            [favoritedPost deleteInBackground];
        }
    }];
}

- (void) showDetails: (Post *)post {
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
    detailsViewController.post = post;
    detailsViewController.currentLocation = self.feed.currentLocation;
    detailsViewController.delegate = self;
    [self.navigationController pushViewController:detailsViewController animated:YES];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL HAS BEEN SELECTED");
    Post *post = self.feed.posts[indexPath.row];
    [self showDetails: post];
}


@end
