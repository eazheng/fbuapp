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

static NSString *kTableViewPostCell = @"PostCell";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray * posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewPostCell bundle:nil] forCellReuseIdentifier:kTableViewPostCell];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    [self fetchPosts]; dka
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.posts.count; dka
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewPostCell];

//    Post *post = self.posts[indexPath.row];
//    
//
//    cell.eventTitle.text = post[@"eventTitle"];
//    CLLocation *eventLocation = post[@"eventLocation"];
//    //change location to an eventDistance here
//    cell.eventDistance.text =
//
//    cell.eventPrice = post[@"eventPrice"];
//    
//    NSDate postCreatedAt = post[@"createdAt"];
//    //change createdAt to a eventDaysAgo here
//    cell.eventDaysAgo.text =
//
//    [post[@"userProfilePhoto"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//        if (!error) {
//            cell.userProfilePhoto.image = [UIImage imageWithData:data];
//        }
//    }];//look at again, might need afnetwokring
//    
//    cell.eventCategory.text = post[@"eventCategory"];
//    
//    cell.eventDescription.text = post[@"eventDescription"];
//    
//    cell.eventAuthor.text = post[@"eventAuthor"];
//    
//    [post[@"eventImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//        if (!error) {
//            cell.eventImage.image = [UIImage imageWithData:data];
//        }
//    }];//look at again, might need afnetwokring
//    
//    cell.isFavorited = post[@"isFavorited"]; //set up this boolean selector
//
//
//
//
//    //may need to clip to bounds here self.userProfilePhoto.clipsToBounds = YES;

    return cell;
}


//-(void)fetchPosts {
//    PFQuery *postQuery = [Post query];
//    [postQuery orderByDescending:@"createdAt"];
//    postQuery.limit = 20;
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
//        if (posts) {
//            self.posts = [NSArray arrayWithArray:posts] ;// step 6
//            [self.tableView reloadData];// step 4 5 7
//        }
//        else {
//            // handle error
//        }
//        [self.refreshControl endRefreshing];
//    }];
//}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
