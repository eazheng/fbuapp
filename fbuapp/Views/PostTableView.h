//
//  PostTableView.h
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "InfiniteScrollActivityView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PostTableViewDelegate <NSObject>

- (void) favoritePost: (NSString *)post withUser: (NSString *)user;
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user;
- (void) fetchPosts;

@end

@interface PostTableView : UITableView

- (instancetype)initWithUserId:(NSString *)userId;


@property (nonatomic, weak) id <PostTableViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * posts;
@property (strong, nonatomic) CLLocation * currentLocation;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int numberOfPosts;
@property (strong, nonatomic) InfiniteScrollActivityView* loadingMoreView;

@end

NS_ASSUME_NONNULL_END
