//
//  InfiniteScrollActivityView.h
//  fbuapp
//
//  Created by danielavila on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfiniteScrollActivityView : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
