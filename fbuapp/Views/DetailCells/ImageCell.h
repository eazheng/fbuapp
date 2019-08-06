//
//  ImageCell.h
//  fbuapp
//
//  Created by eazheng on 7/30/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;


@property Post *post;

@end

NS_ASSUME_NONNULL_END
