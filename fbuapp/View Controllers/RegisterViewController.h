//
//  RegisterViewController.h
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol PFUserAuthenticationDelegate;
@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
//user interaction disabled
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
- (IBAction)signupButton:(id)sender;
//edit button design
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@end

NS_ASSUME_NONNULL_END
