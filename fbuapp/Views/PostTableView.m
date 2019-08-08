//
//  PostTableView.m
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PostTableView.h"
#import "Post.h"
#import "PostCell.h"
#import "Parse/Parse.h"
#import <CoreLocation/CoreLocation.h>
#import "CategoryHeaderView.h"
#import "PostTableView.h"
#import "DetailsViewController.h"
#import "RegisterViewController.h"
#import "EventCategory.h"
#import "UIColor+Helpers.h"
#import "Favorite.h"
#import "HomeViewController.h"
#import "PFGeoPoint+Helpers.h"
#import "NSDate+Helpers.h"
#import "PFFileObject+Helpers.h"


static NSString *kTableViewPostCell = @"PostCell";

@interface PostTableView() <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, PostCellDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString * currentUserId;
@property (strong, nonatomic) PFQuery *postQuery;

@end


@implementation PostTableView

- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.currentUserId = userId;
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    self.frame = self.bounds;
    self.isMoreDataLoading = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setShowsVerticalScrollIndicator:NO];
    
    [self registerNib:[UINib nibWithNibName:kTableViewPostCell bundle:nil] forCellReuseIdentifier:kTableViewPostCell];
    self.dataSource = self;
    self.postQuery = [Post query];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"PostEventComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self fetchPosts];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ChangeEventComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"fetching posts after deletion...");
        [self fetchPosts];
    }];

    CGRect frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self addSubview:self.loadingMoreView];

    UIEdgeInsets insets = self.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.contentInset = insets;
}

-(void)fetchPosts{
    [self.delegate fetchPosts];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",error.description);
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewPostCell];
    cell.delegate = self;
    Post *post = self.posts[indexPath.row];
    
    
    cell.post = post;
    cell.currentUserId = self.currentUserId;
    cell.eventAuthor.text = [PFQuery getUserObjectWithId: post[@"eventAuthor"]][@"firstName"];
    [[NSNotificationCenter defaultCenter] addObserverForName:(@"informationSaved") object:(nil) queue:(nil) usingBlock:^(NSNotification * _Nonnull note) {
        cell.eventAuthor.text = [PFQuery getUserObjectWithId: post[@"eventAuthor"]][@"firstName"];

    }];
    
    cell.fbProfilePhoto.profileID = [PFQuery getUserObjectWithId: post.eventAuthor][@"fbUserId"];
    
    
    PFQuery *favoriteQuery = [Favorite query];
    [favoriteQuery whereKey: @"postID" equalTo: post.objectId];
    [favoriteQuery whereKey: @"userID" equalTo: self.currentUserId];
    [favoriteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *favoritedPost, NSError *error) {
        if (favoritedPost) {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateNormal];
            cell.isFavorited = YES;
        }
        else{
            [cell.favoriteButton setImage:[UIImage imageNamed:@"notfavorited"] forState:UIControlStateNormal];
            cell.isFavorited = NO;
        }
    }];
    
    PFQuery *postQuery = [EventCategory query];
    [postQuery whereKey: @"idNumber" equalTo: post[@"eventCategory"]];
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *category, NSError *error) {
        if (category) {
            cell.eventCategory.text = category[@"name"];
            cell.categoryView.backgroundColor = [UIColor colorWithRGB: category[@"color"]];
        }
        else {
            NSLog(@"Failed to fetch categories.");
        }
    }];
    cell.eventTitle.text = post.eventTitle;
    cell.eventDistance.text = [PFGeoPoint distanceToPoint: post.eventLocation fromLocation: self.currentLocation];
    cell.eventPrice.text = [post.eventPrice stringValue];
    cell.eventDaysAgo.text = [NSDate daysAgoSince: post.createdAt];
    cell.eventDescription.text = post.eventDescription;

    [PFFileObject setImage: cell.eventImage withFile: post.image];

    cell.layer.shadowOffset = CGSizeMake(1, 0);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = .25;
    
    return cell;
}

#pragma mark - PostTableViewDelegate

- (void) favoritePost: (NSString *)post withUser: (NSString *)user{
    [self.delegate favoritePost: post withUser: user];
}

- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user{
    [self.delegate unFavoritePost: post withUser: user];

}


@end
