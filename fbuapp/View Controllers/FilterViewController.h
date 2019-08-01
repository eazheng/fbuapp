//
//  FilterViewController.h
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FilterDelegate <NSObject>

- (void) filterPostsWithQuery: (PFQuery *) postQuery;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id <FilterDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
