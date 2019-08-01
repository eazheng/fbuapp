//
//  PFFileObject+Helpers.h
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PFFileObject (Helpers)

+ (void) setImage: (UIImageView *) image withFile: (PFFileObject *) pfobj;

@end

NS_ASSUME_NONNULL_END
