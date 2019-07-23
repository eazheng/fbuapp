//
//  EditViewController.m
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//activate a camera for user to select profile image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    //get image
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = info[UIImagePickerControllerEditedImage];
    self.changeImageView.image = self.editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//user can change profile image
- (IBAction)didEdit:(id)sender {
    NSLog(@"Button was clicked");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        //for devices with no camera
        NSLog(@"No Camera Found");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

//user can go back to original profile
- (IBAction)didCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//user completed editiing thier profile image
- (IBAction)doneEditing:(id)sender {
}




@end
