//
//  CategoryHeaderView.h
//  fbuapp
//
//  Created by danielavila on 7/24/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CategoryHeaderViewDelegate

- (void)didSelectCell: (NSIndexPath *)indexPath;
- (void)didDeselectCell: (NSIndexPath *)indexPath;

@end

@interface CategoryHeaderView : UIView

@property (nonatomic, weak) id<CategoryHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
 -(instancetype)initWithZero;



@end

NS_ASSUME_NONNULL_END

