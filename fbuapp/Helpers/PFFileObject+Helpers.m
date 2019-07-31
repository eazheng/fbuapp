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

+ (void) setImage: (UIImageView *) image withFile: (PFFileObject *) pfobj{
    NSURL *eventImageURL = [NSURL URLWithString :pfobj.url];
    image.image = nil;
    [image setImageWithURL:eventImageURL];
}

@end
