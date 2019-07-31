//
//  HomeViewController.m
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "HomeViewController.h"
#import "PostCell.h"
#import "Parse/Parse.h"
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

@interface HomeViewController () <PostCellDelegate, TableViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PostTableView *feed = [[PostTableView alloc] initWithUserId:@"myuserid"]; //[PFUser currentUser].username
    feed.tableViewDelegate = self;
    [self.view addSubview:feed];
    
    [feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CategoryHeaderView *pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    feed.tableHeaderView = pillSelector;
    
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
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
    detailsViewController.post = post;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

@end
