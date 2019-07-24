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

static NSString *kTableViewPostCell = @"PostCell";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //make less accurate later
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewPostCell bundle:nil] forCellReuseIdentifier:kTableViewPostCell];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
//    NSString *latitudeValue = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    self.longtitudeValue.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location Services Error"
                                                                   message:[NSString stringWithFormat:@"%@", error.localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:^{}];
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
//    PFUser * cur =[PFUser currentUser];
//    double x = [eventLocation distanceInMilesTo :cur[@"userLocation"]];// may need nullable
////    NSLog([NSString stringWithFormat:@"%.20lf", x]);
////    //change location to an eventDistance here
////    cell.eventDistance.text =
//
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
    
    
//    change createdAt to a eventDaysAgo here
////    cell.eventDaysAgo.text =
//    PFUser *eventAuthor = post[@"author"];
//
////    [eventAuthor.userProfilePhoto getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
////        if (!error) {
////            cell.userProfilePhoto.image = [UIImage imageWithData:data];
////        }
////    }];//look at again, might need afnetwokring
//
//    cell.eventCategory.text = post[@"eventCategory"];//enum?
////
    cell.eventDescription.text = post[@"eventDescription"];
//
////    cell.eventAuthor.text = eventAuthor.name; need to add to user still
//

    PFFileObject *pfobj = post[@"image"];
    NSURL *eventImageURL = [NSURL URLWithString :pfobj.url];
    cell.eventImage.image = nil;
    [cell.eventImage setImageWithURL:eventImageURL];
    
////    cell.isFavorited = post[@"isFavorited"]; //set up this boolean selector
//
////  only deques
    cell.layer.shadowOpacity = 0.8;
    cell.layer.shadowRadius = 5.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);

//    //may need to clip to bounds here self.userProfilePhoto.clipsToBounds = YES;

    return cell;
}


-(void)fetchPosts {
    
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;//infinite change
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [NSArray arrayWithArray:posts] ;// step 6
            [self.tableView reloadData];// step 4 5 7
        }
        else {
            // handle error
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
