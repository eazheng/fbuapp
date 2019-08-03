//
//  EditViewController.m
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "EditViewController.h"
#import "SettingsViewController.h"
#import "RegisterViewController.h"
#import "ProfileViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSave)];
    
    [self outline];
}


- (void)didTapCancel {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion: nil];
}


- (void)didTapSave {
    
    PFUser *currentUser = [PFUser currentUser];
    if ([PFUser currentUser]) {
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
                NSLog(@"User information updated successfully");
                ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
                profileViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                profileViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
                [self presentViewController:navigationController animated:YES completion: nil];
            }
        }];
    }
}



- (void)outline {
    self.editFirstName.layer.borderWidth = 0.5f;
    self.editFirstName.layer.borderColor = [UIColor blackColor].CGColor;
    self.editFirstName.layer.cornerRadius = 5.0f;
    
    self.editLastName.layer.borderWidth = 0.5f;
    self.editLastName.layer.borderColor = [UIColor blackColor].CGColor;
    self.editLastName.layer.cornerRadius = 5.0f;
    
    self.editUsername.layer.borderWidth = 0.5f;
    self.editUsername.layer.borderColor = [UIColor blackColor].CGColor;
    self.editUsername.layer.cornerRadius = 5.0f;
    
    self.editBio.layer.borderWidth = 0.5f;
    self.editBio.layer.borderColor = [UIColor blackColor].CGColor;
    self.editBio.layer.cornerRadius = 5.0f;
    
    self.editEmail.layer.borderWidth = 0.5f;
    self.editEmail.layer.borderColor = [UIColor blackColor].CGColor;
    self.editEmail.layer.cornerRadius = 5.0f;
}


@end
