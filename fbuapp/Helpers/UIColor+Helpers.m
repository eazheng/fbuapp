//
//  UIColor+Helpers.m
//  fbuapp
//
//  Created by danielavila on 7/29/19.
//  Copyright © 2019 eazheng. All rights reserved.
//
#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *)colorWithRGB: (NSArray*) colorRGB {
    return [UIColor colorWithRed: [colorRGB[0] doubleValue]/255.0 green:[colorRGB[1] doubleValue]/255.0 blue:[colorRGB[2] doubleValue]/255.0 alpha:1.0];
}
@end
