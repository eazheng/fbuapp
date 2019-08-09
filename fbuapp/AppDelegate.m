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
#import "EditViewController.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "CreatePostViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import "Key.h"


typedef NS_ENUM(NSUInteger, TabBarItems) {
    TabBarHome,
    TabBarCompose,
    TabBarProfile
};

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
    
    UINavigationController *homeViewNavigationController = [self initializeHomeTab];
    UINavigationController *createPostNavigationController = [self initializeCreatePostTab];
    UINavigationController *profileViewNavigationController = [self initializeProfileTab];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[homeViewNavigationController, createPostNavigationController, profileViewNavigationController];

    self.tabBarController.tabBar.items[TabBarHome].title = [self tabIdentifierForType:TabBarHome];
    self.tabBarController.tabBar.items[TabBarCompose].title = [self tabIdentifierForType:TabBarCompose];
    self.tabBarController.tabBar.items[TabBarProfile].title = [self tabIdentifierForType:TabBarProfile];
    //persisting user
    if ([PFUser currentUser] != nil) {
        NSLog(@"Logged in");
        
        self.window.rootViewController = self.tabBarController;
    }
    else {
        //If user if not logged in, take them to LogViewController
        LogViewController *logViewController = [[LogViewController alloc] init];
        logViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        logViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

        UINavigationController *logViewNavigationController = [self initializeLogView];
        self.window.rootViewController = logViewNavigationController;
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:@"PostEventComplete" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"The Action I was waiting for is complete");
        [self.tabBarController setSelectedIndex:TabBarHome];
        UINavigationController *newCreatePostNavigationController = [self initializeCreatePostTab];
        self.tabBarController.viewControllers = @[homeViewNavigationController, newCreatePostNavigationController, profileViewNavigationController];
        self.tabBarController.tabBar.items[TabBarCompose].title = [self tabIdentifierForType:TabBarCompose];

    }];
    

    return YES;
}

- (UINavigationController *) initializeHomeTab {
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *homeViewControllerNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    return homeViewControllerNavigationController;
}

- (UINavigationController *) initializeCreatePostTab {
    CreatePostViewController *createPostViewController = [[CreatePostViewController alloc] init];
    UINavigationController *createPostNavigationController = [[UINavigationController alloc] initWithRootViewController:createPostViewController];
    return createPostNavigationController;
}

- (UINavigationController *) initializeProfileTab {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    return profileNavigationController;
}

- (UINavigationController *) initializeLogView {
    LogViewController *logViewController = [[LogViewController alloc] init];
    UINavigationController *logViewNavigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
    return logViewNavigationController;
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

#pragma mark - Private

- (NSString *)tabIdentifierForType:(TabBarItems)type
{
    switch (type) {
        case TabBarHome:
            return @"Home";
        case TabBarCompose:
            return @"Create Post";
        case TabBarProfile:
            return @"Profile";
        default:
            NSLog(@"TabBarItem: I shouldn't be here");
    }
}

@end
