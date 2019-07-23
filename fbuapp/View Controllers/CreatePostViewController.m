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

@interface CreatePostViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIPickerView *eventCategoryPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userRoleControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userLevelControl;
@property (weak, nonatomic) IBOutlet UITextField *eventStreetField;
@property (weak, nonatomic) IBOutlet UITextField *eventCityField;
@property (weak, nonatomic) IBOutlet UITextField *eventStateField;
//@property (weak, nonatomic) IBOutlet UITextField *eventZipField;
@property (weak, nonatomic) IBOutlet UITextField *pickerField;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@property (weak, nonatomic) IBOutlet UIView *pickerView;

@property (weak, nonatomic) IBOutlet UITextField *eventPriceField;
@property NSArray *categoryList;
@property NSInteger eventCategory;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Connect data:
    self.eventCategoryPicker.delegate = self;
    self.eventCategoryPicker.dataSource = self;
    self.categoryList = [NSArray arrayWithObjects: @"Outdoor Active", @"Indoor Active", @"Lifestyle", @"Arts", nil];
    self.pickerView.hidden = YES;
    self.pickerView.alpha = 0;
    self.eventCategory = -1;

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
    
    //check for errors (like error posting event)
    // check if all necessary fields are filled in
    if ([self.eventTitleField.text isEqualToString:@""]) {
        NSLog(@"Need an event title");
        [self showComposeError:@"Please enter an event title"];
        return;
    }
    if ([self.eventDescriptionField.text isEqualToString:@""]) {
        [self showComposeError:@"Please add a brief event description"];
        return;
    }
    if ([self.eventStreetField.text isEqualToString:@""]) {
        [self showComposeError:@"Invalid address: Missing street field"];
        return;
    }
    if ([self.eventCityField.text isEqualToString:@""]) {
        [self showComposeError:@"Invalid address: Missing city field"];
        return;
    }
    if ([self.eventStateField.text isEqualToString:@""]) {
        [self showComposeError:@"Invalid address: Missing state field"];
        return;
    }
    if (self.eventCategory == -1) {
        [self showComposeError:@"Please choose an event category"];
        return;
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *price = [f numberFromString:self.eventPriceField.text];
    
    NSInteger authorSkill = [self.userLevelControl selectedSegmentIndex];
    NSInteger authorRole = [self.userRoleControl selectedSegmentIndex];
    
    // create address string and convert into CLLocation
    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@", self.eventStreetField.text, self.eventCityField.text, self.eventStateField.text];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error geocoding address string: %@", error.localizedDescription);
        }
        else {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];

            CGSize size = CGSizeMake(400, 400);
            UIImage *resizedImage = [self resizeImage:self.eventImage.image withSize:size];
            //post the event
            [Post postEvent:self.eventTitleField.text withDescription:self.eventDescriptionField.text withPrice:price withSkill:authorSkill withLocation:loc withRole:authorRole withCategory: self.eventCategory withImage:resizedImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.categoryList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categoryList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.eventCategory = row;
}

// picker to choose a category
- (IBAction)onTapPicker:(id)sender {
    self.pickerView.hidden = NO;
    NSLog(@"TAPPED PICKER");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -80);
    self.pickerView.transform = transform;
    self.pickerView.alpha = 1;
    [UIView commitAnimations];
}

- (IBAction)onTapDone:(id)sender {
    NSLog(@"TAPPED DONE");
    self.pickerField.text = self.categoryList[self.eventCategory];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 80);
    self.pickerView.transform = transform;
    self.pickerView.alpha = 0;
    [UIView commitAnimations];
    [self.pickerField endEditing:YES];
}

- (IBAction)uploadImageButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

//resize image to be within 10MB
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.eventImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

//show error if missing fields for create post
- (void)showComposeError:(NSString *)errorMessage {
    //setup UIAlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Posting Event"
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Okay"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
//    [self.activityIndicator stopAnimating];
    
}
@end
