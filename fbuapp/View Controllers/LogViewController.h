//
//  LogViewController.h
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogViewController : UIViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginButtonView;
@property (copy, nonatomic) NSArray<NSString *> *permissions;

//register thirdparty authentication
//+ (void)registerAuthenticationDelegate:(id<PFUserAuthenticationDelegate>)delegate forAuthType:(NSString *)authType;

//login user with third party authentication
//+ (BFTask<__kindof PFUser *> *)logInWithAuthTypeInBackground:(NSString *)authType



@end

NS_ASSUME_NONNULL_END
