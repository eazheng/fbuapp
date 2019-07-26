//
//  UIViewController+Alerts.h
//  fbuapp
//
//  Created by eazheng on 7/26/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alerts)

- (void)showComposeError:(NSString *)errorTitle withMessage:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END
