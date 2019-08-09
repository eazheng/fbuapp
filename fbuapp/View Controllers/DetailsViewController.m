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
#import "PostCell.h"
#import "Favorite.h"
#import "UIViewController+Alerts.h"
#import "EventCategory.h"
#import "FBSDKProfile.h"
#import <GoogleMaps/GoogleMaps.h>

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
@property (strong, nonatomic) UIBarButtonItem *navButton;
@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSString *currentPost;
@property (strong, nonatomic) PFUser *postAuthor;
@property (strong, nonatomic) PFQuery *postQuery;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser].objectId;
    self.currentPost = self.post.objectId;
    self.postAuthor = [PFQuery getUserObjectWithId: self.post.eventAuthor];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = screenBounds;
    
    // Do any additional setup after loading the view from its nib.
    self.detailsTableView = [[UITableView alloc] init];
    [self.view addSubview:self.detailsTableView];

    self.detailsTableView.dataSource = self;
    self.detailsTableView.delegate = self;
    for (NSUInteger i = 0; i < kNumberOfCellTypes; i++) {
        NSString *currentType = [self cellIdentifierForType:i];
        [self.detailsTableView registerNib:[UINib nibWithNibName:currentType bundle:nil] forCellReuseIdentifier:currentType];
    }
    self.detailsTableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
    
    self.navButton = [[UIBarButtonItem alloc]init];
    if ([self.currentUser isEqualToString:self.postAuthor.objectId]) {
        [self.detailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.navButton setImage:[UIImage imageNamed:@"basket"]];
        self.navButton.action = @selector(onTapDelete:);
    }
    else {
        [self.navButton setImage:[UIImage imageNamed:@"staroutline"]];
        self.navButton.action = @selector(onTapFavorited:);
        
        PFQuery *favoriteQuery = [Favorite query];
        [favoriteQuery whereKey: @"postID" equalTo: self.post.objectId];
        [favoriteQuery whereKey: @"userID" equalTo: self.currentUser];
        [favoriteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *favoritedPost, NSError *error) {
            if (favoritedPost) {
                [self.navButton setImage:[UIImage imageNamed:@"favorited"]];
                self.isFavorited = YES;
            }
            else{
                [self.navButton setImage:[UIImage imageNamed:@"staroutline"]];
                self.isFavorited = NO;
            }
        }];
        CGFloat buttonHeight = 50;
        [self.detailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, buttonHeight, 0));
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, self.view.frame.size.height - buttonHeight, self.view.frame.size.width, buttonHeight);
        [button addTarget:self
                   action:@selector(contactAuthorButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Send a message" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSArray *buttonColor = @[@0, @100, @255];
        button.backgroundColor = [UIColor colorWithRGB:buttonColor];
        [self.view addSubview:button];
    }
    
    self.navButton.target = self;
    // then we add the button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.navButton;
}

- (IBAction)onTapFavorited:(id)sender {
    if (self.isFavorited == NO){
        [self.delegate favoritePost:self.post.objectId withUser:self.currentUser];
        [self.navButton setImage:[UIImage imageNamed:@"favorited"]];
        self.isFavorited = YES;
    }
    else {
        [self.delegate unFavoritePost: self.post.objectId withUser:self.currentUser];
        [self.navButton setImage:[UIImage imageNamed:@"staroutline"]];
        self.isFavorited = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeEventComplete" object:nil userInfo:nil];
}

- (IBAction)onTapDelete:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you sure you want to delete this post?"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        [self.post deleteInBackground];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeEventComplete" object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    // add actions to the alert controller
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
            cell.post = self.post;
            [cell.locationButton setTitle:self.post.eventLocationName forState:UIControlStateNormal];
            
            NSString *dist = [PFGeoPoint distanceToPoint: self.post.eventLocation fromLocation: self.currentLocation];
            cell.locationDistanceLabel.text = [NSString stringWithFormat:@"About %@ miles away", dist];
            
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.post.eventLocation.latitude longitude:self.post.eventLocation.longitude zoom:12];

            cell.mapLocationView.camera = camera;
            cell.mapLocationView.myLocationEnabled = YES;

            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(self.post.eventLocation.latitude, self.post.eventLocation.longitude);
            marker.map = cell.mapLocationView;
            
            return cell;
        }
        case DetailsCellTypeAuthorCell: {
            AuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            cell.authorNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.postAuthor[@"firstName"], self.postAuthor[@"lastName"]];
            cell.usernameLabel.text = self.postAuthor[@"username"];
            
            cell.fbProfileView.profileID = self.postAuthor[@"fbUserId"];
            
            if (self.post.authorRole != LearnRole && ![self.post.eventPrice isEqual:@0]) { //author wants to teach
                cell.authorPriceLabel.text = [NSString stringWithFormat:@"Your cost: $%@", self.post.eventPrice];
                NSArray *redColor = @[@180, @0, @0];
                cell.authorPriceLabel.textColor = [UIColor colorWithRGB: redColor];
            }
            else if (self.post.authorRole != TeachRole && ![self.post.eventPrice isEqual:@0]) { //author wants to learn
                cell.authorPriceLabel.text = [NSString stringWithFormat:@"You'll earn: $%@", self.post.eventPrice];
                NSArray *greenColor = @[@0, @102, @51];
                cell.authorPriceLabel.textColor = [UIColor colorWithRGB: greenColor];
            }
            else {
                cell.authorPriceLabel.text = @"";
            }
            
            NSString *role = [self roleIdentifierForType:self.post.authorRole];
            NSString *skill = [self skillIdentifierForType:self.post.authorSkillLevel];

            cell.authorRoleLabel.text = [NSString stringWithFormat:@"%@ has %@ skill level, looking to %@.", self.postAuthor[@"firstName"], skill, role];
            
            return cell;
        }
            
        case DetailsCellTypeCategoryCell: {
            CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            PFQuery *postQuery = [EventCategory query];
            [postQuery whereKey: @"idNumber" equalTo: self.post[@"eventCategory"]];
            [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *category, NSError *error) {
                if (category) {
                    cell.categoryLabel.text = [NSString stringWithFormat:@"Category: %@", category[@"name"]];
                    cell.labelbgView.backgroundColor = [UIColor colorWithRGB: category[@"color"]];
                }
                else {
                    NSLog(@"Failed to fetch categories.");
                }
            }];
            return cell;
        }
        default:
            NSLog(@"I shouldn't have reached here");
            return nil;
    };
}

- (IBAction)contactAuthorButtonAction:(id)sender {
    NSString *userId = self.postAuthor[@"fbUsername"];
    NSString *linkString = [NSString stringWithFormat:@"http://m.me/%@", userId];

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
