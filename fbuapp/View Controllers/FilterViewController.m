//
//  FilterViewController.m
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "FilterViewController.h"
#import "Post.h"



@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    
    myButton.action = @selector(presentHomeViewController:);
    myButton.title = @"Cancel";
    myButton.target = self;
    self.navigationItem.leftBarButtonItem = myButton;
}

- (IBAction)presentHomeViewController:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
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
