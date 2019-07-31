//
//  DetailsViewController.m
//  fbuapp
//
//  Created by eazheng on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "DetailsViewController.h"
#import "ImageCell.h"
#import "TitleCell.h"
#import "DescriptionCell.h"
#import "LocationCell.h"
#import "AuthorCell.h"
#import "CategoryCell.h"

static NSUInteger const kNumberOfCellTypes = 6;
typedef NS_ENUM(NSUInteger, DetailsCellType) {
    DetailsCellTypeImageCell,
    DetailsCellTypeTitleCell,
    DetailsCellTypeDescriptionCell,
    DetailsCellTypeLocationCell,
    DetailsCellTypeAuthorCell,
    DetailsCellTypeCategoryCell
};

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.detailsTableView.dataSource = self;
    self.detailsTableView.delegate = self;
    
    for (NSUInteger i = 0; i < kNumberOfCellTypes; i++) {
        NSString *currentType = [self cellIdentifierForType:i];
        [self.detailsTableView registerNib:[UINib nibWithNibName:currentType bundle:nil] forCellReuseIdentifier:currentType];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfCellTypes;//self.cellTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSString *cellIdentifier = [self cellIdentifierForType:indexPath.item];
    switch (indexPath.row) {
        case DetailsCellTypeImageCell: {
            ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            //        cell.post = self.post;
            [self.post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    cell.eventImageView.image = [UIImage imageWithData:data];
                }
            }];
            return cell;
        }
        case DetailsCellTypeTitleCell: {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = self.post.eventTitle;
            return cell;
        }
        case DetailsCellTypeDescriptionCell: {
            DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.descriptionLabel.text = self.post.description;
            return cell;
        }
        case DetailsCellTypeLocationCell: {
            LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.locationNameLabel.text = self.post.eventLocationName;
            //        cell.locationDistanceLabel.text = [NSString stringWithFormat:@"About %@ miles away", self.post.]
            return cell;
        }
        case DetailsCellTypeAuthorCell: {
            AuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            //cell.authorNameLabel.text = self.post.eventAuthor.username;
            return cell;
        }
        case DetailsCellTypeCategoryCell: {
            CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }
        default:
            NSLog(@"I shouldn't have reached here");
            return nil;
            break;
            
    };
}


#pragma mark - Private

- (NSString *)cellIdentifierForType:(DetailsCellType)type
{
    switch (type) {
        case DetailsCellTypeImageCell:
            return @"ImageCell";
        case DetailsCellTypeTitleCell:
            return @"TitleCell";
        case DetailsCellTypeDescriptionCell:
            return @"DescriptionCell";
        case DetailsCellTypeLocationCell:
            return @"LocationCell";
        case DetailsCellTypeAuthorCell:
            return @"AuthorCell";
        case DetailsCellTypeCategoryCell:
            return @"CategoryCell";
        default:
            NSLog(@"I shouldn't be here");
    }
}

@end
