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
#import "Query.h"

@interface FilterViewController () <CategoryHeaderViewDelegate>

@property NSIndexPath *eventCategory;
@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UIView *eventCategoryView;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *roleControl;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *levelMultiControl;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxDistance;
@property (strong, nonatomic) PFQuery *postQuery;
@property (strong, nonatomic) CategoryHeaderView* pillSelector;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearFilters:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(presentHomeOnFilter:)];
    
    [self.maxPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.maxDistance setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.pillSelector = [[CategoryHeaderView alloc] initWithZero];
    self.pillSelector.delegate = self;
    [self.view addSubview:self.pillSelector];
    
    [self.pillSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.eventCategoryView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if(self.savedQuery != nil){
        [self initializeWithQuery];
    }
    
}

-(void) initializeWithQuery{
    self.eventTitle.text = self.savedQuery.name;
    self.roleControl.selectedSegmentIndexes = self.savedQuery.role;
    self.levelMultiControl.selectedSegmentIndexes = self.savedQuery.level;
    if(self.savedQuery.price >= 0){
        self.maxPrice.text = @(self.savedQuery.price).stringValue;
    }
    if(self.savedQuery.distance >= 0){
        self.maxDistance.text = @(self.savedQuery.distance).stringValue;
    }
    
}

- (IBAction)presentHomeOnFilter:(id)sender {
    self.postQuery = [Post query];
    Query *filterQuery = [[Query alloc] init];
    if(![self.eventTitle.text isEqualToString:@""]){
        [self.postQuery whereKey: @"eventTitle" matchesRegex: self.eventTitle.text modifiers: @"i"];
        filterQuery.name = self.eventTitle.text;
    }
    if(self.eventCategory != nil){
        [self.postQuery whereKey: @"eventCategory" equalTo: @(self.eventCategory.row)];
        filterQuery.category = self.eventCategory;
    }
    
    [self queryWithArray: self.levelMultiControl.selectedSegmentTitles withValueArray: @[@"Beginner", @"Intermediate", @"Expert"] withKey: @"authorSkillLevel"];
    filterQuery.level = [[NSIndexSet alloc] initWithIndexSet: self.levelMultiControl.selectedSegmentIndexes];
    [self queryWithArray: self.roleControl.selectedSegmentTitles withValueArray: @[@"Learn", @"Teach", @"Collaborate"] withKey: @"authorRole"];
    filterQuery.role = [[NSIndexSet alloc] initWithIndexSet: self.roleControl.selectedSegmentIndexes];
    
    if(![self.maxPrice.text isEqualToString:@""]){
        if ([self isValidNumber: self.maxPrice.text]){
            [self.postQuery whereKey:@"eventPrice" lessThanOrEqualTo:@([self.maxPrice.text floatValue])];
            filterQuery.price = [self.maxPrice.text floatValue];
        }
    }
    if(![self.maxDistance.text isEqualToString:@""]){
        if([self isValidNumber: self.maxDistance.text]){
            [self.postQuery whereKey:@"eventLocation" nearGeoPoint:self.currentLocation withinMiles: [self.maxDistance.text floatValue]];
            filterQuery.distance = [self.maxDistance.text floatValue];
        }
    }
    
    [self.delegate filterPostsWithQuery: self.postQuery withSavedQuery:filterQuery];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearFilters:(id)sender {
    self.eventTitle.text = @"";
    
    //eventCategory clear here
    self.eventTitle.text = @"";
    self.levelMultiControl.selectedSegmentIndexes = [NSIndexSet indexSet];
    self.roleControl.selectedSegmentIndexes = [NSIndexSet indexSet];
    self.maxPrice.text = @"";
    self.maxDistance.text = @"";
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
                NSLog(@"Error: Invalid multipane selection.");
            }
        }
        [self.postQuery whereKey:key containedIn: queryArray];
    }
}

-(BOOL)isValidNumber: (NSString *) string{
    NSMutableCharacterSet *alphaNums = [NSMutableCharacterSet decimalDigitCharacterSet];
    [alphaNums addCharactersInString: @"."];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString: string];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (void)didSelectCell: (NSIndexPath *)indexPath{
    self.eventCategory = indexPath;
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
