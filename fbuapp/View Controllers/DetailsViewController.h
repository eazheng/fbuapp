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

- (void) favoritePost: (NSString *)post withUser: (NSString *)user;
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user;

@end

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) Post *post;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (nonatomic, weak) id <DetailsViewDelegate> delegate;
@property (nonatomic, assign) BOOL isFavorited;

@end

NS_ASSUME_NONNULL_END
