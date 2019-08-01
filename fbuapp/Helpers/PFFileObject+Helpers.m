//
//  PFFileObject+Helpers.m
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PFFileObject+Helpers.h"
#import "UIImageView+AFNetworking.h"

@implementation PFFileObject (Helpers)

+ (void) setImage: (UIImageView *) imageView withFile: (PFFileObject *) pfobj{
    NSURL *eventImageURL = [NSURL URLWithString :pfobj.url];
    imageView.image = nil;
    [imageView setImageWithURL:eventImageURL];
}

@end
