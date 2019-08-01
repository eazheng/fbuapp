//
//  PostTableView.h
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PostTableViewDelegate <NSObject>

- (void) favoritePost: (NSString *)post withUser: (NSString *)user;
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user;
- (void) showDetails: (Post *)post;
- (void) fetchPosts;

@end

@interface PostTableView : UITableView

- (instancetype)initWithUserId:(NSString *)userId;

@property (nonatomic, weak) id <PostTableViewDelegate> delegate;
@property (strong, nonatomic) NSArray * posts;
//@property (nonatomic) NSArray<Post *> *posts;

@end

NS_ASSUME_NONNULL_END
