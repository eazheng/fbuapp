//
//  PostCell.h
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *favorited;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;

@end

NS_ASSUME_NONNULL_END
