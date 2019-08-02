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
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *roleControl;

@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *levelMultiControl;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxDistance;
@property (strong, nonatomic) PFQuery *postQuery;

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
    
    
    
    
}

- (IBAction)presentHomeOnFilter:(id)sender {
    self.postQuery = [Post query];
    if(![self.eventTitle.text isEqualToString:@""]){
        [self.postQuery whereKey: @"eventTitle" equalTo: self.eventTitle.text];
    }
    if(self.eventCategory != -1){
        [self.postQuery whereKey: @"eventCategory" equalTo: @(self.eventCategory)];
    }
    
    [self queryWithArray: self.roleControl.selectedSegmentTitles withValueArray: @[@"Beginner", @"Intermediate", @"Expert"] withKey: @"authorSkillLevel"];
    [self queryWithArray: self.levelMultiControl.selectedSegmentTitles withValueArray: @[@"Learn", @"Teach", @"Collaborate"] withKey: @"authorRole"];
    
    [self.delegate filterPostsWithQuery: self.postQuery];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) queryWithArray: (NSArray *) arrayToQuery withValueArray: (NSArray *) valueArray withKey: (NSString *) key{
    if([arrayToQuery count] != nil){
        NSMutableArray * queryArray = [NSMutableArray array];
        for (NSString* selectedIndex in arrayToQuery) {
            if([selectedIndex isEqualToString: valueArray[0]]){
                [queryArray addObject:@0];
            }
            else if([selectedIndex isEqualToString: valueArray[1]]){
                [queryArray addObject:@1];
            }
            else if([selectedIndex isEqualToString: valueArray[2]]){
                [queryArray addObject:@2];
            }
            else{
                NSLog(@"Error: Invalid selection.");
            }
        }
        [self.postQuery whereKey:key containedIn: queryArray];
    }
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
