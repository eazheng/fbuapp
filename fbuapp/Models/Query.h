//
//  Query.h
//  fbuapp
//
//  Created by danielavila on 8/5/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Query : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSIndexSet *role;
@property (nonatomic, strong) NSIndexSet *level;
@property (nonatomic, strong) NSMutableArray *category;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float distance;

- (id) init;

@end

NS_ASSUME_NONNULL_END
