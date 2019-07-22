//
//  PostCell.h
//  fbuapp
//
//  Created by danielavila on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventDistance;
@property (weak, nonatomic) IBOutlet UILabel *eventPrice;
@property (weak, nonatomic) IBOutlet UILabel *eventDaysAgo;
@property (weak, nonatomic) IBOutlet UILabel *postUserSkillLevel;
@property (weak, nonatomic) IBOutlet UIButton *isFavorited;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePhoto;



@end

NS_ASSUME_NONNULL_END
