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
    
    //display old informaiton first before user changes
    [self fetchInfo];
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
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"informationSaved" object:nil userInfo:nil];
                NSLog(@"User information updated! %@", [PFUser currentUser]);
            }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController.tabBar setHidden:NO];
}


- (void)fetchInfo {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        [currentUser fetch];
        NSLog(@"Current user: %@", currentUser.email);
        self.editFirstName.text = currentUser[@"firstName"];
        self.editLastName.text = currentUser[@"lastName"];
        self.editUsername.text = currentUser.username;
        self.editBio.text = currentUser[@"bio"];
        self.editEmail.text = currentUser.email;
    }
    else {
        NSLog(@"No information to display");
    }
}


- (void)formatting:(UITextField *)textField {
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.cornerRadius = 5.0f;
}







@end
