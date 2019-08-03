//
//  InfiniteScrollActivityView.m
//  fbuapp
//
//  Created by danielavila on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "InfiniteScrollActivityView.h"

@interface InfiniteScrollActivityView()

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicatorView;

@end


@implementation InfiniteScrollActivityView

+ (CGFloat)defaultHeight{
    return 60.0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setupActivityIndicator{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = true;
    [self addSubview:self.activityIndicatorView];
}

-(void)stopAnimating{
    [self.activityIndicatorView stopAnimating];
    self.hidden = true;
}

-(void)startAnimating{
    self.hidden = false;
    [self.activityIndicatorView startAnimating];
}


@end
