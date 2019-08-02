//
//  HomeViewController.m
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "HomeViewController.h"
#import "PostCell.h"
#import "Post.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "UIViewController+Alerts.h"
#import "CategoryHeaderView.h"
#import "PostTableView.h"
#import "DetailsViewController.h"
#import "Masonry.h"
#import "Favorite.h"
#import "AppDelegate.h"
#import "FilterViewController.h"

@interface HomeViewController () <PostCellDelegate, PostTableViewDelegate, FilterDelegate, CategoryHeaderViewDelegate>

@property (strong, nonatomic) PFQuery *postQuery;
@property PostTableView * feed;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postQuery = [Post query];
    self.feed = [[PostTableView alloc] initWithUserId:@"myuserid"]; //[PFUser currentUser].username
    [self fetchPosts];
    self.feed.delegate = self;
    [self.view addSubview:self.feed];
    
    [self.feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CategoryHeaderView *pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    pillSelector.delegate = self;
    self.feed.tableHeaderView = pillSelector;
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    myButton.action = @selector(presentFilterViewController:);
    myButton.title = @"Filter";
    myButton.target = self;
    self.navigationItem.rightBarButtonItem = myButton;
}





- (IBAction)presentFilterViewController:(id)sender {
    FilterViewController *filterVCObj =[[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:filterVCObj] animated:YES completion:nil];
    
    filterVCObj.delegate = self;
}

- (void) filterPostsWithQuery: (PFQuery *) postQuery{
    self.postQuery = postQuery;
    [self fetchPosts];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
}

- (void) favoritePost: (NSString *)post withUser: (NSString *)user {
    [Favorite postID: post userID: user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"Error favoriting event: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Favoriting event success!");
        }
    }];
}

- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user {
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
    NSLog(@"HELLO");
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
    detailsViewController.post = post;
    [self.navigationController pushViewController:detailsViewController animated:YES];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}

-(void)didSelectCell: (NSIndexPath *)indexPath {
    NSLog(@"EVENT CATEGORY RECEIVED by homeView");
    [self.postQuery whereKey: @"eventCategory" equalTo: @(indexPath.row)];
    [self fetchPosts];
}

- (void) fetchPosts {
    [self.postQuery orderByDescending:@"createdAt"];
    self.postQuery.limit = 20;
    [self.postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.feed.posts = [NSArray arrayWithArray:posts] ;
            [self.feed reloadData];
        }
        else {
            NSLog(@"Failed to fetch posts from server");
        }
    }];
    [self.feed.refreshControl endRefreshing];

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL HAS BEEN SELECTED");
    Post *post = self.feed.posts[indexPath.row];
    [self showDetails: post];
}

@end
