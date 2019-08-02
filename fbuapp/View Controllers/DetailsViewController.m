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
#import "Masonry.h"
#import "PFGeoPoint+Helpers.h"
#import "UIColor+Helpers.h"

static NSUInteger const kNumberOfCellTypes = 6;
typedef NS_ENUM(NSUInteger, DetailsCellType) {
    DetailsCellTypeImageCell,
    DetailsCellTypeTitleCell,
    DetailsCellTypeDescriptionCell,
    DetailsCellTypeLocationCell,
    DetailsCellTypeAuthorCell,
    DetailsCellTypeCategoryCell
};

typedef NS_ENUM(NSUInteger, RoleType) {
    LearnRole,
    TeachRole,
    CollabRole
};

typedef NS_ENUM(NSUInteger, SkillLevel) {
    BeginnerSkill,
    IntermediateSkill,
    ExpertSkill
};

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = screenBounds;
    
    // Do any additional setup after loading the view from its nib.
    self.detailsTableView = [[UITableView alloc] init]; //[PFUser currentUser].username
    [self.view addSubview:self.detailsTableView];
    CGFloat buttonHeight = 50;
    [self.detailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, buttonHeight, 0));
    }];
    self.detailsTableView.dataSource = self;
    self.detailsTableView.delegate = self;
    for (NSUInteger i = 0; i < kNumberOfCellTypes; i++) {
        NSString *currentType = [self cellIdentifierForType:i];
        [self.detailsTableView registerNib:[UINib nibWithNibName:currentType bundle:nil] forCellReuseIdentifier:currentType];
    }
    self.detailsTableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    NSLog(@"Height: %f Width: %f", self.view.frame.size.height, self.view.frame.size.width);
    button.frame = CGRectMake(0, self.view.frame.size.height - buttonHeight, self.view.frame.size.width, buttonHeight);
    [button addTarget:self
               action:@selector(contactAuthorButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Send a message" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
//    UIImage *buttonImage = [UIImage imageNamed:@"messenger_icon"];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    button.imageEdgeInsets = UIEdgeInsetsMake(0., button.frame.size.width - (buttonImage.size.width + 15.), 0., 0.);
    [self.view addSubview:button];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfCellTypes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [self cellIdentifierForType:indexPath.item];
    switch (indexPath.row) {
        case DetailsCellTypeImageCell: {
            ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
            cell.descriptionLabel.text = self.post.eventDescription;
            return cell;
        }
        case DetailsCellTypeLocationCell: {
            LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.locationNameLabel.text = self.post.eventLocationName;

            
            NSString *dist = [PFGeoPoint distanceToPoint: self.post.eventLocation fromLocation: self.currentLocation];
            cell.locationDistanceLabel.text = [NSString stringWithFormat:@"About %@ miles away", dist];
            return cell;
        }
        case DetailsCellTypeAuthorCell: {
            AuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            cell.usernameLabel.text = self.post.eventAuthor.username;
            
            if (self.post.authorRole == 1 && ![self.post.eventPrice isEqual:@0]) { //author wants to teach
                cell.authorPriceLabel.text = [NSString stringWithFormat:@"Your cost: $%@", self.post.eventPrice];
            }
            else if (self.post.authorRole == 0 && ![self.post.eventPrice isEqual:@0]) { //author wants to learn
                cell.authorPriceLabel.text = [NSString stringWithFormat:@"You'll earn: $%@", self.post.eventPrice];
            }
            else {
                cell.authorPriceLabel.text = @"";
            }
            
            NSString *role = [self roleIdentifierForType:self.post.authorRole];
            NSString *skill = [self skillIdentifierForType:self.post.authorSkillLevel];
            cell.authorRoleLabel.text = [NSString stringWithFormat:@"%@ is of %@ skill level, looking to %@.", self.post.eventAuthor.username, skill, role];
            return cell;
        }
            
        case DetailsCellTypeCategoryCell: {
            CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }
        default:
            NSLog(@"I shouldn't have reached here");
            return nil;
    };
}

- (IBAction)contactAuthorButtonAction:(id)sender {
    NSLog(@"I want to contact the author!");
    NSString *userId = @"emily.zheng.96780";
//    NSString *linkString = [NSString stringWithFormat:@"google.com"];

    NSString *linkString = [NSString stringWithFormat:@"http://m.me/%@", userId];
    NSLog(@"Line string: %@", linkString);
//    NSURL *linkUrl = [NSURL URLWithString:linkString];
//    UIApplication *application = [UIApplication sharedApplication];
//    [application openURL:linkUrl options:@{} completionHandler:nil];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: linkString] options:@{} completionHandler:nil];
    
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

- (NSString *)roleIdentifierForType:(RoleType)type
{
    switch (type) {
        case LearnRole:
            return @"learn";
        case TeachRole:
            return @"teach";
        case CollabRole:
            return @"collaborate";
        default:
            NSLog(@"Role: I shouldn't be here");
    }
}

- (NSString *)skillIdentifierForType:(SkillLevel)type
{
    switch (type) {
        case BeginnerSkill:
            return @"beginner";
        case IntermediateSkill:
            return @"intermediate";
        case ExpertSkill:
            return @"expert";
        default:
            NSLog(@"Skill Level: I shouldn't be here");
    }
}

@end
