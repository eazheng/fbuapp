//
//  RegisterViewController.h
//  fbuapp
//
//  Created by belchercd on 7/22/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PFUserAuthenticationDelegate;

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signupButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;


@end

NS_ASSUME_NONNULL_END
