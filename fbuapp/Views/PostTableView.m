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


static NSString *kTableViewPostCell = @"PostCell";

@interface PostTableView() <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray * posts;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation * currentLocation;

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
        //refreshing
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
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location Services Error"
//                                                                   message:[NSString stringWithFormat:@"%@", error.localizedDescription]
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:^{}];
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

@end
