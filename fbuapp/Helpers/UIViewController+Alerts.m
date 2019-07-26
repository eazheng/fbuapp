//
//  UIViewController+Alerts.m
//  fbuapp
//
//  Created by eazheng on 7/26/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

//show error if missing fields for create post
- (void)showComposeError:(NSString *)errorTitle withMessage:(NSString *)errorMessage {
    //setup UIAlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    
}

@end
