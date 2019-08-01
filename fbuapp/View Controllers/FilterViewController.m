//
//  FilterViewController.m
//  fbuapp
//
//  Created by danielavila on 7/31/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "FilterViewController.h"
#import "Post.h"
#import "CategoryHeaderView.h"
#import "Masonry.h"
#import "MultiSelectSegmentedControl.h"

@interface FilterViewController () <CategoryHeaderViewDelegate>

@property NSInteger eventCategory;
@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UIView *eventCategoryView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roleControl;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *levelMultiControl;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxDistance;


@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventCategory = -1;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]init];
    cancelButton.action = @selector(presentHomeViewController:);
    cancelButton.title = @"Cancel";
    cancelButton.target = self;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]init];
    searchButton.action = @selector(presentHomeOnFilter:);
    searchButton.title = @"Search";
    searchButton.target = self;
    self.navigationItem.rightBarButtonItem = searchButton;
    
    
    CategoryHeaderView* pillSelector = [[CategoryHeaderView alloc] initWithZero];
    pillSelector.delegate = self;
    [self.view addSubview:pillSelector];
    
    [pillSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.eventCategoryView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    NSInteger authorRole = [self.roleControl selectedSegmentIndex];
    NSArray *authorLevels = self.levelMultiControl.selectedSegmentTitles;
    
}

- (IBAction)presentHomeOnFilter:(id)sender {
    PFQuery * postQuery = [Post query];
    if(![self.eventTitle.text isEqualToString:@""]){
        [postQuery whereKey: @"eventTitle" equalTo: self.eventTitle.text];
    }
    if(self.eventCategory != -1){
        [postQuery whereKey: @"eventCategory" equalTo: @(self.eventCategory)];
    }
    NSInteger authorRole = [self.roleControl selectedSegmentIndex];
    [postQuery whereKey: @"authorRole" equalTo: @(authorRole)];
    NSIndexSet *authorLevels = self.levelMultiControl.selectedSegmentIndexes;
    if([authorLevels count] != nil){
        for (NSNumber* selectedIndex in authorLevels) {
            [postQuery whereKey: @"authorSkillLevel" equalTo: selectedIndex];
        }
    }
    
    
    
    [self.delegate filterPostsWithQuery: postQuery];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)presentHomeViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCell: (NSIndexPath *)indexPath{
    self.eventCategory = indexPath.row;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
