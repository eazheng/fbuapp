//
//  MainNavigationController.h
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "ProfileViewController.h"
#import "SavedViewController.h"
#import "LogoutViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainNavigationController : UINavigationController

@property (nonatomic, strong) EditViewController *editViewController;
@property (nonatomic, strong) SavedViewController *savedViewController;
@property (nonatomic, strong) LogoutViewController *logoutViewController;

- (void)showEditViewController;
- (void)showSavedViewController;
- (void)showLogoutViewContorller;



@end

NS_ASSUME_NONNULL_END
