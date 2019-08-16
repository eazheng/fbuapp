//
//  EditViewController.m
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "EditViewController.h"
#import "RegisterViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UIColor+Helpers.h"
#import "UIViewController+Alerts.h"

@interface EditViewController ()
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSave)];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Edit Profile"];
    
    [self formatting:self.editFirstName];
    [self formatting:self.editLastName];
    [self formatting:self.editUsername];
    [self formatting:self.editBio];
    [self formatting:self.editEmail];
    
    [self fetchInfo];
    
    NSArray *color = @[@237, @167, @114];
    self.backgroundView.backgroundColor = [UIColor colorWithRGB:color];
    self.backgroundView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.backgroundView.layer.shadowOpacity = 1.0f;
    self.backgroundView.layer.shadowRadius = 0.0f;
    self.backgroundView.layer.cornerRadius = 4.0f;
}


- (void)didTapCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
}


- (void)didTapSave {
    PFUser *currentUser = [PFUser currentUser];
    if ([PFUser currentUser] != nil) {
        [currentUser fetch];
        
        currentUser[@"firstName"] = self.editFirstName.text;
        currentUser[@"lastName"] = self.editLastName.text;
        currentUser.username = self.editUsername.text;
        currentUser.email = self.editEmail.text;
        currentUser[@"bio"] = self.editBio.text;
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [self showAlert:@"Error: %@" withMessage:error.localizedDescription];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"informationSaved" object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                [appDelegate.tabBarController.tabBar setHidden:NO];
            }

        }];
    
    }
}


- (void)fetchInfo {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];

        self.editFirstName.text = currentUser[@"firstName"];
        self.editLastName.text = currentUser[@"lastName"];
        self.editUsername.text = currentUser.username;
        self.editBio.text = currentUser[@"bio"];
        self.editEmail.text = currentUser.email;
    }
    else {
        [self showAlert:@"User not found" withMessage:@""];
    }
}


- (void)formatting:(UITextField *)textField {
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.cornerRadius = 5.0f;
}

@end
