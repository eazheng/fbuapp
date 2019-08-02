//
//  SettingsViewController.m
//  fbuapp
//
//  Created by belchercd on 8/1/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "LogViewController.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(backtoProfile)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(didLogout)];
}


- (void)backtoProfile {
    //Take User back to HomeViewController
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    profileViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


-(void)didLogout {
    //currentUser will become nil
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //Take user back to LogViewController
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LogViewController *logViewController = [[LogViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
        appDelegate.window.rootViewController = navigationController;
    }];
}

@end
