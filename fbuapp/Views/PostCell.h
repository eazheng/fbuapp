//
//  PostCell.h
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "FBSDKProfile.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate <NSObject>

- (void) favoritePost: (NSString *)post withUser: (NSString *)user;
- (void) unFavoritePost: (NSString *)post withUser: (NSString *)user;

@end

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDistance;
@property (weak, nonatomic) IBOutlet UILabel *eventPrice;
@property (weak, nonatomic) IBOutlet UILabel *eventDaysAgo;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbProfilePhoto;

@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *dollarSign;

@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (nonatomic, assign) BOOL isFavorited;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSString *currentUserId;

@property (nonatomic, weak) id <PostCellDelegate> delegate;

@end


NS_ASSUME_NONNULL_END
