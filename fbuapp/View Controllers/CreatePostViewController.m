//
//  CreatePostViewController.m
//  fbuapp
//
//  Created by eazheng on 7/19/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "CreatePostViewController.h"
#import "Post.h"
#import "CLLocation.h"

@interface CreatePostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionField;
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
}
- (IBAction)postEventAction:(id)sender {
    
    //check for errors
    //TODO: check if all fields are filled in
    
    NSNumber *price = self.eventPriceField;
    CLLocation *loc = self.eventLocation;
    NSString *authorSkill = self.userLevelControl;
    
    [Post postEvent:self.eventTitleField.text withDescription:self.eventDescriptionField.text withPrice:price withSkill:authorSkill withLocation:loc withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"Error composing Event: %@", error.localizedDescription);
        }
        else{
            //refreshes timeline
            //[self.delegate didPost];
            
            NSLog(@"Compose Event Success!");
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
