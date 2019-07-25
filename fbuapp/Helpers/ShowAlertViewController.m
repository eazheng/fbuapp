//
//  ShowAlertViewController.m
//  fbuapp
//
//  Created by eazheng on 7/25/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ShowAlertViewController.h"

@interface ShowAlertViewController ()

@end

@implementation ShowAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
