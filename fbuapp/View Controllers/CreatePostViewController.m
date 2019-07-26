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
#import "UITextView+Placeholder.h"
#import <GooglePlaces/GooglePlaces.h>
#import "UIViewController+Alerts.h"


@interface CreatePostViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property  NSString *addressString;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIPickerView *eventCategoryPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userRoleControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userLevelControl;
@property (weak, nonatomic) IBOutlet UITextField *pickerField;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;
@property (weak, nonatomic) IBOutlet UIView *pickerView;


@property (weak, nonatomic) IBOutlet UITextField *eventPriceField;
@property NSArray *categoryList;
@property NSInteger eventCategory;


@end

@implementation CreatePostViewController

// Present the autocomplete view controller when the button is pressed.
- (void)searchClicked {
    NSLog(@"Clicked on search");
    GMSAutocompleteViewController *locationController = [[GMSAutocompleteViewController alloc] init];
    locationController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldFormattedAddress);
    locationController.placeFields = fields;
    
    // Specify a filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    locationController.autocompleteFilter = filter;
    
    // Display the autocomplete view controller.
    [self presentViewController:locationController animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);

    // Connect data:
    self.eventCategoryPicker.delegate = self;
    self.eventCategoryPicker.dataSource = self;
    
    self.categoryList = [NSArray arrayWithObjects: @"Outdoor Active", @"Indoor Active", @"Lifestyle", @"Arts", @"Business", @"Finance", @"Music", @"Photography", nil];
    
    
    self.pickerView.hidden = YES;
    self.pickerView.alpha = 0;
    self.eventCategory = -1;
    
    //var myMutableStringTitle = NSMutableAttributedString()
    //let Name  = "Enter Title" // PlaceHolderText
    
    //myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 20.0)!]) // Font
    
    //NSAttributedString *titlePlaceholderString = [[NSAttributedString alloc] initWithString:@"Event Title" attributes:@{NSFontAttributeName: [UIFont name]}];
    //self.eventTitleField.attributedPlaceholder = titlePlaceholderString;
    //[self.eventTitleField setValue:[UIColor colorWithRed:97.0/255.0 green:1.0/255.0 blue:17.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    //self.myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.eventTitleField.font = [UIFont boldSystemFontOfSize:50.0f];
//    self.eventTitleField.placeholder = @"Event Title";
    self.eventTitleField.borderStyle = UITextBorderStyleNone;
    self.eventTitleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if ([self.eventTitleField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor blackColor];
        self.eventTitleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event Title" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    CGRect frameRect = self.eventTitleField.frame;
    frameRect.size.height = 60;
    self.eventTitleField.frame = frameRect;
    
    //self.eventDescriptionField.layer.borderWidth = 0.3f;
    //self.eventDescriptionField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //self.eventDescriptionField.layer.cornerRadius = 8;
    self.eventDescriptionField.placeholder = @"Write a brief description of your event here!";
    self.eventDescriptionField.placeholderColor = [UIColor lightGrayColor];
    self.eventDescriptionField.font = [UIFont systemFontOfSize:16.0f];
    
    [self.eventDescriptionField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.eventDescriptionField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.eventDescriptionField.layer setBorderWidth: 0.0];
    //[txt.layer setCornerRadius:12.0f];
//    [self.eventDescriptionField.layer setMasksToBounds:NO];
//    [self.eventDescriptionField.layer setShadowRadius:2.0f];
//    self.eventDescriptionField.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.eventDescriptionField.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    self.eventDescriptionField.layer.shadowOpacity = 1.0f;
//    self.eventDescriptionField.layer.shadowRadius = 1.0f;
    
//    CALayer *bottomLine = [[CALayer alloc] init];
//    bottomLine.frame = CGRectMake(0.0, self.eventLocationTextField.frame.size.height - 1, self.eventLocationTextField.frame.size.width, 0.3);
//    bottomLine.backgroundColor =[[UIColor lightGrayColor] CGColor];
////    self.eventDescriptionField.frame border
//    //self.eventDescriptionField.border
//    //self.eventDescriptionField.borderStyle = UITextBorderStyleNone;
//    [self.eventLocationTextField.layer addSublayer:bottomLine];
 
    self.navigationItem.title=@"Create an Event";
    
    // first we create a button and set it's properties
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    myButton.action = @selector(postEventAction:);
    myButton.title = @"Post Event!";
    myButton.target = self;
    
    // then we add the button to the navigation bar
    self.navigationItem.rightBarButtonItem = myButton;
    
    //button on search location field
    UIButton* overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [overlayButton addTarget:self action:NSSelectorFromString(@"searchClicked") forControlEvents:UIControlEventTouchUpInside];
    [self.eventLocationTextField addTarget:self action:NSSelectorFromString(@"searchClicked") forControlEvents:UIControlEventEditingDidBegin];

    
    [overlayButton setTitle:@"Launch location search" forState:UIControlStateNormal];
    overlayButton.frame = CGRectMake(0, 0, self.eventLocationTextField.frame.size.height, self.eventLocationTextField.frame.size.height);
    
    // Assign the overlay button to a stored text field
    self.eventLocationTextField.leftView = overlayButton;
    self.eventLocationTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *priceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.eventPriceField.font.pointSize, self.eventPriceField.font.pointSize)];
    priceImage.image = [UIImage imageNamed:@"dollar_sign"];
    priceImage.contentMode = UIViewContentModeScaleAspectFit;
    self.eventPriceField.leftViewMode = UITextFieldViewModeAlways;
    self.eventPriceField.leftView = priceImage;
    
    self.eventPriceField.delegate= self;
    self.pickerField.delegate = self;
}


- (IBAction)postEventAction:(id)sender {
    
    //TODO - check for errors (like error posting event)
    
    // check if all necessary fields are filled in
    if ([self.eventTitleField.text isEqualToString:@""]) {
        NSLog(@"Need an event title");
        [self showComposeError:@"Error Posting Event" withMessage:@"Please enter an event title"];
        return;
    }
    if ([self.eventDescriptionField.text isEqualToString:@""]) {
        [self showComposeError:@"Error Posting Event" withMessage:@"Please add a brief event description"];
        return;
    }
    if (self.eventCategory == -1) {
        [self showComposeError:@"Error Posting Event" withMessage:@"Please choose an event category"];
        return;
    }
    if ([self.eventLocationTextField.text isEqualToString:@""]) {
        [self showComposeError:@"Error Posting Event" withMessage:@"Please specify a location for your event"];
        return;
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    if ([self.eventPriceField.text isEqualToString:@""]) {
        self.eventPriceField.text = @"0";
    }
    NSNumber *price = [f numberFromString:self.eventPriceField.text];
    
    NSInteger authorSkill = [self.userLevelControl selectedSegmentIndex];
    NSInteger authorRole = [self.userRoleControl selectedSegmentIndex];
    

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error geocoding address string: %@", error.localizedDescription);
        }
        else {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];

            CGSize size = CGSizeMake(400, 400);
            UIImage *resizedImage = [self resizeImage:self.eventImage.image withSize:size];
            //post the event
            [Post postEvent:self.eventTitleField.text withDescription:self.eventDescriptionField.text withPrice:price withSkill:authorSkill withLocation:loc withLocationName: self.eventLocationTextField.text withRole:authorRole withCategory: self.eventCategory withImage:resizedImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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
    if (self.eventCategory == -1) {
        self.eventCategory = 0;
    }
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

// for GMSAutocompleteViewControllerDelegate
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Formatted Address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    self.addressString = place.formattedAddress;
    self.eventLocationTextField.text = place.name;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
    [self showComposeError:@"Failed Autocomplete" withMessage:[error description]];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.pickerField) {
        return NO;
    }
    
    // allow empty field or digit 0 to 9 for price field
    if (!string.length || [string intValue])
    {
        return YES;
    }
    return NO;
}

@end
