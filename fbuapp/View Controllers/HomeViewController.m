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
#import "CreatePostViewController.h"

static NSString *kTableViewPostCell = @"PostCell";


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSArray * posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewPostCell bundle:nil] forCellReuseIdentifier:kTableViewPostCell];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
    
    CategoryHeaderView *pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    self.tableView.tableHeaderView = pillSelector;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"PostEventComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"The Action I was waiting for is complete");
        [self fetchPosts];
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
    
    [self showAlert:@"Location Services Error" withMessage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
    
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
    
    //if post was less than 1 day ago
    if (postWasRecentBool) {
        cell.eventDaysAgo.text = [NSString stringWithFormat:@"%@%@", date.shortTimeAgoSinceNow, @" ago"];
    }
    else {
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        cell.eventDaysAgo.text = [formatter stringFromDate:date];
    }
    cell.eventDescription.text = post[@"eventDescription"];

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


-(void)fetchPosts {
    
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;//infinite change
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [NSArray arrayWithArray:posts] ;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Failed to fetch posts from server");
        }
        [self.refreshControl endRefreshing];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
