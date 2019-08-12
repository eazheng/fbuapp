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
#import "UIViewController+Alerts.h"

@interface FilterViewController () <CategoryHeaderViewDelegate>

@property NSMutableArray *eventCategory;
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

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearFilters:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(presentHomeOnFilter:)];
    
    [self.maxPrice setKeyboardType:UIKeyboardTypeNumberPad];
    [self.maxDistance setKeyboardType:UIKeyboardTypeNumberPad];
    self.eventCategory = [[NSMutableArray alloc] init];
    
    self.pillSelector = [[CategoryHeaderView alloc] initWithZero];
    self.pillSelector.delegate = self;
    self.pillSelector.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.pillSelector];
    [self.pillSelector.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    
    [self.pillSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.eventCategoryView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self initializeWithSavedQuery];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    for(NSNumber *indexPathRow in self.eventCategory){
        [self.pillSelector.collectionView selectItemAtIndexPath : [NSIndexPath indexPathForItem:[indexPathRow intValue] inSection:0] animated: NO scrollPosition: UICollectionViewScrollPositionNone];
    }
}

- (void)dealloc
{
    [self.pillSelector.collectionView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

-(void) initializeWithSavedQuery{
    if(![self.savedQuery.name isEqualToString:@""]){
        self.eventTitle.text = self.savedQuery.name;
    }
    if([self.savedQuery.category count] > 0){
        self.eventCategory = [NSMutableArray arrayWithArray:self.savedQuery.category];
        for (NSNumber *indexPathRow in self.savedQuery.category){
            [self.pillSelector.collectionView selectItemAtIndexPath :[NSIndexPath indexPathForItem:[indexPathRow intValue] inSection:0] animated: NO scrollPosition: UICollectionViewScrollPositionNone];
        }
    }
    if(self.savedQuery.role != nil){
        self.roleControl.selectedSegmentIndexes = self.savedQuery.role;
    }
    if(self.savedQuery.level != nil){
        self.levelMultiControl.selectedSegmentIndexes = self.savedQuery.level;
    }
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
    if([self.eventCategory count] > 0){
        [self.postQuery whereKey: @"eventCategory" containedIn: self.eventCategory];
        filterQuery.category = [NSMutableArray arrayWithArray:self.eventCategory];
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
    for (NSNumber *indexPathRow in self.savedQuery.category){
        [self.pillSelector.collectionView deselectItemAtIndexPath: [NSIndexPath indexPathForItem:[indexPathRow intValue] inSection:0] animated:NO];
    }
    [self.eventCategory removeAllObjects];
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
                [self showAlert:@"Error" withMessage:@"Invalid multipane selection."];
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
    [self.eventCategory addObject:@(indexPath.row)];
}

- (void)didDeselectCell: (NSIndexPath *)indexPath{
    [self.eventCategory removeObject:@(indexPath.row)];
    if([self.eventCategory count] > 0)
    {
        [self.postQuery whereKey: @"eventCategory" containedIn:self.eventCategory];
    }
    else{
        [self.postQuery whereKey: @"eventCategory" containedIn:@[@0, @1, @2, @3, @4, @5, @6, @7]];
    }
}

@end
