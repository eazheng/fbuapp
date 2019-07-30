//
//  RegisterViewController.h
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PFUserAuthenticationDelegate;

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signupButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (strong, nonatomic) IBOutlet UITextField *emailField;



@end

NS_ASSUME_NONNULL_END
