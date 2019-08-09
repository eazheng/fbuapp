//
//  EditViewController.h
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *editFirstName;
@property (weak, nonatomic) IBOutlet UITextField *editLastName;
@property (weak, nonatomic) IBOutlet UITextField *editUsername;
@property (weak, nonatomic) IBOutlet UITextView *editBio;
@property (weak, nonatomic) IBOutlet UITextField *editEmail;


@end

NS_ASSUME_NONNULL_END
