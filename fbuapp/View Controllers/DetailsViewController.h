//
//  DetailsViewController.h
//  fbuapp
//
//  Created by eazheng on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewDelegate <NSObject>



@end

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) Post *post;
@property (strong, nonatomic) CLLocation * currentLocation;

@end

NS_ASSUME_NONNULL_END
