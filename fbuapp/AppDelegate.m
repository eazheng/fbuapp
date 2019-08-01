//
//  AppDelegate.m
//  fbuapp
//
//  Created by eazheng on 7/16/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "LogViewController.h"
#import "RegisterViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "CreatePostViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import "Key.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView *view;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSPlacesClient provideAPIKey:API_KEY];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    //initialize parse
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            
            configuration.applicationId = @"skillAppId";
            configuration.server = @"https://skill--app.herokuapp.com/parse";
        }];
        [Parse initializeWithConfiguration:config];
    
    //create for persisting user
    if ([PFUser currentUser] != nil) {
        //if user is already logged in, take them to HomeViewController
//        HomeViewController *homeViewController = [[HomeViewController alloc] init];
//        homeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//        homeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];

        
        ProfileViewController *logViewController = [[ProfileViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
        

    }
    else {
        //If user if not logged in, take them to LogViewController
        LogViewController *logViewController = [[LogViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
    }
    self.window.rootViewController = navigationController;
    
    

    
    

//    CreatePostViewController *createPostViewController = [[CreatePostViewController alloc] init];
//    UINavigationController *createPostNavigationController = [[UINavigationController alloc] initWithRootViewController:createPostViewController];
//
//    HomeViewController *homeViewController = [[HomeViewController alloc] init];
//    UINavigationController *homeViewControllerNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = @[homeViewControllerNavigationController, createPostNavigationController];
//
//    tabBarController.tabBar.items[0].title = @"Home";
//    tabBarController.tabBar.items[1].title = @"Create Post";
//
//    self.window.rootViewController = tabBarController;

    
    return YES;
}
    
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    return handled;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
