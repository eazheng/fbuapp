//
//  EditViewController.h
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController <UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *changeImageView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)didEdit:(id)sender;
- (IBAction)didCancel:(id)sender;
- (IBAction)doneEditing:(id)sender;

@end

NS_ASSUME_NONNULL_END
