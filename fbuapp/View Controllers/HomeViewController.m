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
#import "PillCell.h"
#import "Query.h"

@interface HomeViewController () <PostCellDelegate, PostTableViewDelegate, FilterDelegate, CategoryHeaderViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PFQuery *postQuery;
@property PostTableView * feed;
@property (strong, nonatomic) CategoryHeaderView *pillSelector;
@property (strong, nonatomic) Query *savedQuery;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feed.numberOfPosts = 0;
    self.postQuery = [Post query];
    self.feed = [[PostTableView alloc] initWithUserId:@"myuserid"];
    [self fetchPosts];
    self.feed.delegate = self;
    [self.view addSubview:self.feed];
    
    [self.feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    self.pillSelector.delegate = self;
    self.feed.tableHeaderView = self.pillSelector;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(presentFilterViewController:)];
}

- (IBAction)presentFilterViewController:(id)sender {
    [self.pillSelector resetCells];
    FilterViewController *filterVCObj =[[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    filterVCObj.currentLocation = [PFGeoPoint geoPointWithLocation: self.feed.currentLocation];
    filterVCObj.savedQuery = self.savedQuery;
    
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:filterVCObj] animated:YES completion:nil];
    filterVCObj.delegate = self;
}

- (void) fetchPosts {
    [self.postQuery orderByDescending:@"createdAt"];
    self.postQuery.skip = self.feed.numberOfPosts;
    self.postQuery.limit = 20;
    [self.postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if ([posts count] != nil) {
            if(self.feed.numberOfPosts == 0){
                self.feed.posts = [NSMutableArray arrayWithArray:posts];
            }
            else{
                [self.feed.posts addObjectsFromArray:posts];
            }
            self.feed.isMoreDataLoading = NO;
            [self.feed reloadData];
        }
        else if(posts){
            self.feed.posts = [NSMutableArray arrayWithArray:posts];
            [self.feed reloadData];
            NSLog(@"No more posts to reload.");
        }
        else{
            NSLog(@"Error fetching posts.");
        }
        [self.feed.loadingMoreView stopAnimating];
        [self.feed.refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.feed.isMoreDataLoading){
        if(scrollView.contentOffset.y > (self.feed.contentSize.height - self.feed.bounds.size.height) && self.feed.isDragging) {
            self.feed.isMoreDataLoading = YES;
            self.feed.loadingMoreView.frame = CGRectMake(0, self.feed.contentSize.height, self.feed.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            [self.feed.loadingMoreView startAnimating];
            self.feed.numberOfPosts += 20;
            [self fetchPosts];
        }
    }
}

- (void) filterPostsWithQuery: (PFQuery *) postQuery withSavedQuery:(Query *)saved{
    self.postQuery = postQuery;
    self.savedQuery = saved;
    self.feed.numberOfPosts = 0;
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
     self.feed.numberOfPosts = 0;
    [self fetchPosts];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL HAS BEEN SELECTED");
    Post *post = self.feed.posts[indexPath.row];
    [self showDetails: post];
}

@end
