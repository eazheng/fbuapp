//
//  CreatePostViewController.m
//  fbuapp
//
//  Created by eazheng on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "CreatePostViewController.h"
#import "Post.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface CreatePostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionField;
@property (weak, nonatomic) IBOutlet UIPickerView *eventCategoryPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userRoleControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userLevelControl;
@property (weak, nonatomic) IBOutlet UITextField *eventStreetField;
@property (weak, nonatomic) IBOutlet UITextField *eventCityField;
@property (weak, nonatomic) IBOutlet UITextField *eventStateField;
@property (weak, nonatomic) IBOutlet UITextField *eventZipField;
@property (weak, nonatomic) IBOutlet UITextField *eventPriceField;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *userTimeAvailabilityControl;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *userDayAvailabilityControl;


@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Create an Event";
    
    // first we create a button and set it's properties
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    myButton.action = @selector(postEventAction:);
    myButton.title = @"Post Event!";
    myButton.target = self;
    
    // then we add the button to the navigation bar
    self.navigationItem.rightBarButtonItem = myButton;
}
- (IBAction)postEventAction:(id)sender {
    
    //check for errors
    //TODO: check if all fields are filled in
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *price = [f numberFromString:self.eventPriceField.text];
    
    NSInteger authorSkill = [self.userLevelControl selectedSegmentIndex];
    NSInteger authorRole = [self.userRoleControl selectedSegmentIndex];
    
    NSInteger eventCategory = 0;
    //NSInteger eventCategory = [self.eventCategoryPicker selectedRowInComponent:0];
    
    // create address string and convert into CLLocation
    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@", self.eventStreetField.text, self.eventCityField.text, self.eventStateField.text];
    NSLog(@"HERE IS STRING: %@", addressString);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error geocoding address string: %@", error.localizedDescription);
        }
        else {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            
            //post the event
            [Post postEvent:self.eventTitleField.text withDescription:self.eventDescriptionField.text withPrice:price withSkill:authorSkill withLocation:loc withRole:authorRole withCategory: eventCategory withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(!succeeded){
                    NSLog(@"Error posting Event: %@", error.localizedDescription);
                }
                else{
                    //refreshes timeline (delegate of createpostvc)
                    //[self.delegate didPost];
                    NSLog(@"Post Event Success!");
                }
            }];
        }
    }];
    
    //[self presentViewController:homeVC animated:YES completion:nil];
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
