//
//  EditViewController.m
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "EditViewController.h"
#import "Parse/Parse.h"

@interface EditViewController ()
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        NSLog(@"Current user: %@", currentUser.email);
        [currentUser fetch];
        self.changeImageView.image = currentUser[@"profilePicture"];
        self.changeImageView.layer.cornerRadius = self.changeImageView.frame.size.width / 2;
        self.changeImageView.clipsToBounds = YES;
        self.firstName.text = currentUser[@"firstName"];
        self.lastName.text = currentUser[@"lastName"];
        self.username.text = currentUser.username;
        self.email.text = currentUser.email;
        self.password.text = currentUser.password;
        
        NSLog(@"First: %@", currentUser[@"firstName"]);
    }
}


//activate a camera for user to select profile image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    //get image
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = info[UIImagePickerControllerEditedImage];
    self.changeImageView.image = self.editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//access camera for user to change profile image
- (IBAction)didEdit:(id)sender {
    NSLog(@"User pressed the edit button");
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //check if device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"No camera was found. Must use photolibrary instead.");
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}


//user can go back to original profile
- (IBAction)didCancel:(id)sender {
}


//user completed editiing thier profile 
- (IBAction)doneEditing:(id)sender {
}




@end
