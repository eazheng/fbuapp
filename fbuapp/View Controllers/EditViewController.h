//
//  EditViewController.h
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *changeImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)didEdit:(id)sender;
- (IBAction)didCancel:(id)sender;
- (IBAction)doneEditing:(id)sender;

@end

NS_ASSUME_NONNULL_END
