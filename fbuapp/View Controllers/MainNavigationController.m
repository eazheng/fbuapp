//
//  MainNavigationController.m
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (EditViewController *)editViewController {
    if (!self.editViewController) {
        self.editViewController = [[EditViewController alloc] initWithNibName:@"SavedViewController" bundle:nil];
    }
    return self.editViewController;
}


- (SavedViewController *)savedViewController {
    if (!self.savedViewController) {
        self.savedViewController = [[SavedViewController alloc] initWithNibName:@"SavedViewController" bundle:nil];
    }
    return self.savedViewController;
}


- (LogoutViewController *)logoutViewController {
    if (!self.logoutViewController) {
        self.logoutViewController = [[LogoutViewController alloc] initWithNibName:@"LogoutViewController" bundle:nil];
    }
    return self.logoutViewController;
}


- (void)showEditViewController {
    EditViewController *editViewController = [[EditViewController alloc] init];
    editViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    editViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


- (void)showSavedViewController {
    SavedViewController *savedViewController = [[SavedViewController alloc] init];
    savedViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    savedViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:savedViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


- (void)showLogoutViewContorller {
    LogoutViewController *logoutViewController = [[LogoutViewController alloc] init];
    logoutViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    logoutViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logoutViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}

@end
