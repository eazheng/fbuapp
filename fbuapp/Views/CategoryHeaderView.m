//
//  CategoryHeaderView.m
//  fbuapp
//
//  Created by danielavila on 7/24/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "CategoryHeaderView.h"

@interface CategoryHeaderView()

@property (strong, nonatomic) IBOutlet CategoryHeaderView *headerView;

@end

@implementation CategoryHeaderView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self customInit];
    }
    return self;
}
-(void)customInit
{
    [[NSBundle mainBundle] loadNibNamed:@"CategoryHeaderView" owner:self options:nil];
    [self addSubview:self.headerView];
    self.headerView.frame = self.bounds;
}

@end


