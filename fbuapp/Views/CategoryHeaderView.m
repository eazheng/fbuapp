//
//  CategoryHeaderView.m
//  fbuapp
//
//  Created by danielavila on 7/24/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "CategoryHeaderView.h"
#import "PillCell.h"
#import "Category.h"

static NSString *kCollectionViewPillCell = @"PillCell";

@interface CategoryHeaderView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray * categories;
@property (strong, nonatomic) IBOutlet CategoryHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[PillCell class] forCellWithReuseIdentifier:kCollectionViewPillCell];
    UINib *cellNib = [UINib nibWithNibName:kCollectionViewPillCell bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kCollectionViewPillCell];
    
    PFQuery *postQuery = [Category query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Category *> * _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.categories = [NSArray arrayWithArray:categories] ;
            [self.collectionView reloadData];
            }
            else {
                NSLog(@"Failed to fetch categories");
            }
        }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, (CGRectGetHeight(collectionView.frame)));
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewPillCell forIndexPath:indexPath];
    Category* category = self.categories[indexPath.row];
    
    NSArray *colorRGB = category.eventCategoryColor;
    cell.pillBackground.backgroundColor = [UIColor colorWithRed: [colorRGB[0] doubleValue]/255.0 green:[colorRGB[1] doubleValue]/255.0 blue:[colorRGB[2] doubleValue]/255.0 alpha:1.0];

    cell.eventCategory.text = category.eventCategory;
    cell.pillBackground.layer.cornerRadius = 17;
    
    return cell;
}


@end


