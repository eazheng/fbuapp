//
//  PostTableView.h
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TableViewDelegate <NSObject>

- (void) favoritePost: (NSString *)post withUser: (NSString *)user;
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user;

@end

@interface PostTableView : UITableView

- (instancetype)initWithUserId:(NSString *)userId;

@property (nonatomic, weak) id <TableViewDelegate> tableViewDelegate;



@end

NS_ASSUME_NONNULL_END
