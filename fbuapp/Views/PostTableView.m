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
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "CategoryHeaderView.h"
#import "PostTableView.h"
#import "EventCategory.h"


static NSString *kTableViewPostCell = @"PostCell";

@interface PostTableView() <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray * posts;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation PostTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    self.frame = self.bounds;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self registerNib:[UINib nibWithNibName:kTableViewPostCell bundle:nil] forCellReuseIdentifier:kTableViewPostCell];
    self.dataSource = self;
    self.delegate = self;
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    
}

-(void)fetchPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [NSArray arrayWithArray:posts] ;
            [self reloadData];
        }
        else {
            NSLog(@"Failed to fetch posts from server");
        }
        [self.refreshControl endRefreshing];
    }];
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
    Post *post = self.posts[indexPath.row];
    
    cell.eventTitle.text = post[@"eventTitle"];
    PFGeoPoint *eventLocation = post[@"eventLocation"];
    double dist = [eventLocation distanceInMilesTo :[PFGeoPoint geoPointWithLocation :self.currentLocation]];
    cell.eventDistance.text = [NSString stringWithFormat:@"%.2f", dist];
    cell.eventPrice.text = [post[@"eventPrice"] stringValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    NSDate *date = post.createdAt;
    NSDate *now = [[NSDate date] dateByAddingDays:-1];
    BOOL postWasRecentBool = [date isLaterThan:now];
    if (postWasRecentBool) {
        cell.eventDaysAgo.text = [NSString stringWithFormat:@"%@%@", date.shortTimeAgoSinceNow, @" ago"];
    }
    else {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        cell.eventDaysAgo.text = [formatter stringFromDate:date];
    }
    
    cell.eventDescription.text = post[@"eventDescription"];
    
//    PFUser *eventAuthor = post[@"author"];
//    cell.eventAuthor.text = eventAuthor[@"firstName"];
    
//    cell.eventCategory =
    PFQuery *postQuery = [EventCategory query];
    [postQuery whereKey: @"idNumber" equalTo: post[@"eventCategory"]];//might need object key
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<EventCategory *> * _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            cell.eventCategory.text = categories[0].name;// = [NSArray arrayWithArray:categories] ;
        }
        else {
            NSLog(@"Failed to fetch categories.");
        }
    }];
    
//    - (instancetype)whereKey:(NSString *)key equalTo:(id)object;
    
    PFFileObject *pfobj = post[@"image"];
    NSURL *eventImageURL = [NSURL URLWithString :pfobj.url];
    cell.eventImage.image = nil;
    [cell.eventImage setImageWithURL:eventImageURL];
    
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shadowRadius = 5.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    
    return cell;
}

@end
