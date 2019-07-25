//
//  CategoryHeaderView.m
//  fbuapp
//
//  Created by danielavila on 7/24/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "CategoryHeaderView.h"
#import "PillCell.h"

static NSString *kCollectionViewPillCell = @"PillCell";

@interface CategoryHeaderView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray * categories;
@property (strong, nonatomic) IBOutlet CategoryHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    [self.collectionView registerNib:[UINib nibWithNibName:kCollectionViewPillCell bundle:nil] forCellReuseIdentifier:kCollectionViewPillCell];
//    PFQuery *postQuery = [EventCategory query];
//    [postQuery orderByDescending:@"createdAt"];
//    postQuery.limit = 20;//infinite change
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
//        if (posts) {
            self.categories = @[@"Sports", @"Outdoors", @"Education", @"Lifestyle"];//[NSArray arrayWithArray:posts] ;// step 6
            [self.collectionView reloadData];// step 4 5 7
//        }
//        else {
//            // handle error
//        }
//    }];
}

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

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;//return actual number of categories
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PillCell" forIndexPath:indexPath];
//    NSString *name = categories[indexPath.row];
    
//    UIColor *cellColor = [self colorForIndexPath:indexPath];
    cell.eventCategory.text = @"Lifestyle";
    
//    if(CGColorGetNumberOfComponents(cellColor.CGColor) == 4){
//        float redComponent = CGColorGetComponents(cellColor.CGColor)[0] * 255;
//        float greenComponent = CGColorGetComponents(cellColor.CGColor)[1] * 255;
//        float blueComponent = CGColorGetComponents(cellColor.CGColor)[2] * 255;
//        cell.colorLabel.text = [NSString stringWithFormat:@"%.0f, %.0f, %.0f", redComponent, greenComponent, blueComponent];
//    }
//    
    return cell;
}


@end


