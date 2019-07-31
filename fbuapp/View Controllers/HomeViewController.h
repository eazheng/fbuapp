//
//  HomeViewController.h
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomeDelegate <NSObject>

- (void) filterPostsWithQuery: (PFQuery *) postQuery;
- (void) filterPostsWithCategory: (NSInteger) category;

@end

@interface HomeViewController : UIViewController

@property(strong,nonatomic)IBOutlet UITableView *tableView;

@property (nonatomic, weak) id <HomeDelegate> homeDelegate;

@end

NS_ASSUME_NONNULL_END
