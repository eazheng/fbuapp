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
#import "UIViewController+Alerts.h"


@interface HomeViewController () <PostCellDelegate, PostTableViewDelegate, FilterDelegate, CategoryHeaderViewDelegate, DetailsViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PFQuery *postQuery;
@property PostTableView *feed;
@property (strong, nonatomic) CategoryHeaderView *pillSelector;
@property (strong, nonatomic) Query *savedQuery;
@property float verticalContentOffset;

@end


@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.feed.numberOfPosts = 0;
    self.postQuery = [Post query];
    self.savedQuery = [[Query alloc] init];
    
    self.feed = [[PostTableView alloc] initWithUserId:[PFUser currentUser].objectId];
    [self fetchPosts];
    self.feed.delegate = self;
    [self.view addSubview:self.feed];
    
    [self.feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    self.pillSelector.delegate = self;
    self.pillSelector.collectionView.allowsMultipleSelection = YES;
    self.feed.tableHeaderView = self.pillSelector;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(presentFilterViewController:)];
    self.verticalContentOffset = 0;
}

- (IBAction)presentFilterViewController:(id)sender{
    FilterViewController *filterVCObj =[[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    filterVCObj.currentLocation = [PFGeoPoint geoPointWithLocation: self.feed.currentLocation];
    filterVCObj.savedQuery = self.savedQuery;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:filterVCObj] animated:YES completion:nil];
    filterVCObj.delegate = self;
}

- (void)fetchPosts{
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
        else if(posts && self.feed.numberOfPosts == 0){
            self.feed.posts = [NSMutableArray arrayWithArray:posts];
            [self.feed reloadData];
        }
        else{
            [self showAlert:@"Error" withMessage:@"Could not fetch posts."];
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

- (void)filterPostsWithQuery:(PFQuery *)postQuery withSavedQuery:(Query *)savedQuery{
    self.postQuery = postQuery;
    for (NSNumber *indexPathRow in self.savedQuery.category){
        [self.pillSelector.collectionView deselectItemAtIndexPath: [NSIndexPath indexPathForItem: [indexPathRow intValue] inSection:0] animated:NO];
    }
    self.savedQuery = savedQuery;
    for (NSNumber *indexPathRow in self.savedQuery.category){
        [self.pillSelector.collectionView selectItemAtIndexPath: [NSIndexPath indexPathForItem: [indexPathRow intValue] inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    self.feed.numberOfPosts = 0;
    [self fetchPosts];
    [self.feed setContentOffset:CGPointMake(0, -self.view.safeAreaLayoutGuide.layoutFrame.origin.y)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
}

- (void)favoritePost:(NSString *)post withUser:(NSString *)user{
    [Favorite postID: post userID: user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"Error favoriting event: %@", error.localizedDescription);
        }
    }];
}

- (void) unFavoritePost:(NSString *)post withUser:(NSString *)user{
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

-(void)didSelectCell: (NSIndexPath *)indexPath {
    [self.savedQuery.category addObject:@(indexPath.row)];
    [self.postQuery whereKey: @"eventCategory" containedIn:self.savedQuery.category];
    self.feed.numberOfPosts = 0;
    [self fetchPosts];
}

- (void)didDeselectCell: (NSIndexPath *)indexPath{
    [self.savedQuery.category removeObject:@(indexPath.row)];
    if([self.savedQuery.category count] > 0)
    {
        [self.postQuery whereKey: @"eventCategory" containedIn:self.savedQuery.category];

    }
    else{
        [self.postQuery whereKey: @"eventCategory" containedIn:@[@0, @1, @2, @3, @4, @5, @6, @7]];
    }
    self.feed.numberOfPosts = 0;
    [self fetchPosts];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.feed.posts[indexPath.row];
    [self showDetails: post];
}

@end
