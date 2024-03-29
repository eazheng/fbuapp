//
//  AuthorCell.h
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "FBSDKProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorPriceLabel;
@property Post *post;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbProfileView;

@end

NS_ASSUME_NONNULL_END
