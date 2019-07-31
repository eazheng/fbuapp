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
#import "Masonry.h"
#import "Favorite.h"
#import "FilterViewController.h"

@interface HomeViewController () <PostCellDelegate, PostTableViewDelegate, FilterDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PostTableView *feed = [[PostTableView alloc] initWithUserId:@"myuserid"]; //[PFUser currentUser].username
    feed.postTableViewDelegate = self;
    self.homeDelegate = feed;
    [self.view addSubview:feed];
    [feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CategoryHeaderView *pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    feed.tableHeaderView = pillSelector;
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    
    myButton.action = @selector(presentFilterViewController:);
    myButton.title = @"Filter";
    myButton.target = self;
    self.navigationItem.rightBarButtonItem = myButton;
}

- (IBAction)presentFilterViewController:(id)sender {
    FilterViewController *filterVCObj =[[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:filterVCObj] animated:YES completion:nil];
    filterVCObj.filterDelegate = self;
//    self.delegate = filterVCObj;
}

- (void) filterPostsWithQuery: (PFQuery *) postQuery{
    [self.homeDelegate filterPostsWithQuery: postQuery];
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
@end
