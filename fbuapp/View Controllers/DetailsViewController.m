//
//  DetailsViewController.m
//  fbuapp
//
//  Created by eazheng on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "DetailsViewController.h"
#import "Post.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"In detailsView, %@", self.post.eventTitle);
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
