//
//  FilterViewController.h
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Query.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FilterDelegate <NSObject>

- (void) filterPostsWithQuery: (PFQuery *) postQuery withSavedQuery: (Query *)saved;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id <FilterDelegate> delegate;
@property (strong, nonatomic) PFGeoPoint *currentLocation;
@property (strong, nonatomic) Query *savedQuery;

@end



NS_ASSUME_NONNULL_END
