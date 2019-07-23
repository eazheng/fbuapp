//
//  ProfileViewController.h
//  fbuapp
//
//  Created by belchercd on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)didEdit:(id)sender;
- (IBAction)didLogout:(id)sender;


@end

NS_ASSUME_NONNULL_END
