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
#import "CategoryHeaderView.h"
#import "PostTableView.h"
#import "Masonry.h"


@interface HomeViewController ()

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PostTableView *feed = [[PostTableView alloc] initWithUserId:@"myuserid"]; //[PFUser currentUser].username
    
    [self.view addSubview:feed];
    
    [feed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    CategoryHeaderView *pillSelector = [[CategoryHeaderView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
    feed.tableHeaderView = pillSelector;
    
}

@end
