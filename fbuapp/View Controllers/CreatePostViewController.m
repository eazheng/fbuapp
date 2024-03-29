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
#import "HomeViewController.h"
#import "PostCell.h"
#import "CategoryHeaderView.h"
#import "Masonry.h"


@interface CreatePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate, CategoryHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *pillLocationView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property (strong, nonatomic) NSString *addressString;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userRoleControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userLevelControl;
@property (weak, nonatomic) IBOutlet UITextField *eventPriceField;

@property (nonatomic, assign) NSInteger eventCategory;
@property (nonatomic, assign) BOOL pickedImage;
@property (strong, nonatomic) CategoryHeaderView *pillSelector;
@property (nonatomic, assign) BOOL editingPrice;
@property (nonatomic, assign) CGFloat prevY;

@end

@implementation CreatePostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.pickedImage = false;
    self.eventCategory = -1;
    self.editingPrice = NO;
    self.prevY = self.view.frame.origin.y;

    self.eventTitleField.font =[UIFont systemFontOfSize:50.0f weight:UIFontWeightLight];

    self.eventTitleField.borderStyle = UITextBorderStyleNone;
    self.eventTitleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if ([self.eventTitleField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        self.eventTitleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event Title" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    CGRect frameRect = self.eventTitleField.frame;
    frameRect.size.height = 60;
    self.eventTitleField.frame = frameRect;
    
    self.eventDescriptionField.placeholder = @"Write a brief description of your event here!";
    self.eventDescriptionField.placeholderColor = [UIColor lightGrayColor];
    self.eventDescriptionField.font = [UIFont systemFontOfSize:16.0f];
    
    [self.eventDescriptionField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.eventDescriptionField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.eventDescriptionField.layer setBorderWidth: 0.0];

    self.navigationItem.title=@"Create an Event";
    self.navigationController.navigationBar.translucent = NO;
    
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
    priceImage.image = [UIImage imageNamed:@"money"];
    priceImage.contentMode = UIViewContentModeScaleAspectFit;
    self.eventPriceField.leftViewMode = UITextFieldViewModeAlways;
    self.eventPriceField.leftView = priceImage;
    
    self.eventPriceField.delegate= self;
    [self.eventPriceField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.pillSelector = [[CategoryHeaderView alloc] initWithZero];
    self.pillSelector.delegate = self;
    [self.view addSubview:self.pillSelector];
    
    [self.pillSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pillLocationView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (IBAction)onTapPriceField:(id)sender {
    self.editingPrice = YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

// Present the autocomplete view controller when the button is pressed.
- (void)searchClicked {
    GMSAutocompleteViewController *locationController = [[GMSAutocompleteViewController alloc] init];
    locationController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldFormattedAddress);
    locationController.placeFields = fields;
    
    // Specify a filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    locationController.autocompleteFilter = filter;
    
    // Display the autocomplete view controller.
    [self presentViewController:locationController animated:YES completion:nil];
}


- (IBAction)postEventAction:(id)sender {
    
    //TODO - check for errors (like error posting event)
    
    // check if all necessary fields are filled in
    if ([self.eventTitleField.text isEqualToString:@""]) {
        NSLog(@"Need an event title");
        [self showAlert:@"Error Posting Event" withMessage:@"Please enter an event title"];
        return;
    }
    if ([self.eventDescriptionField.text isEqualToString:@""]) {
        [self showAlert:@"Error Posting Event" withMessage:@"Please add a brief event description"];
        return;
    }
    if (self.eventCategory == -1) {
        [self showAlert:@"Error Posting Event" withMessage:@"Please choose an event category"];
        return;
    }
    if ([self.eventLocationTextField.text isEqualToString:@""]) {
        [self showAlert:@"Error Posting Event" withMessage:@"Please specify a location for your event"];
        return;
    }
    if (!self.pickedImage) {
        [self showAlert:@"Error Posting Event" withMessage:@"Please upload an event picture"];
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
    
    NSString *authorName = [PFUser currentUser][@"firstName"];
    NSString *authorPhoto = [PFUser currentUser][@"fbUserId"];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            [self showAlert:@"Error" withMessage:@"Error geocoding address string"];
        }
        else {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];

            CGSize size = CGSizeMake(390, 260);
            UIImage *resizedImage = [self resizeImage:self.eventImage.image withSize:size];
            //post the event
            [Post postEvent:self.eventTitleField.text withDescription:self.eventDescriptionField.text withPrice:price withSkill:authorSkill withLocation:loc withLocationName: self.eventLocationTextField.text withRole:authorRole withCategory: self.eventCategory withImage:resizedImage withAuthorName:authorName withAuthorPhoto:authorPhoto withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(!succeeded){
                    [self showAlert:@"Error Posting Event" withMessage:error.localizedDescription];
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostEventComplete" object:nil userInfo:nil];
                    [self showAlert:@"Event Succesfully Posted!" withMessage:@""];
                }
            }];
        }
    }];
}


- (IBAction)uploadImageButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    self.pickedImage = true;
    
    // Get the image captured by the UIImagePickerController
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
    self.addressString = place.formattedAddress;
    self.eventLocationTextField.text = place.name;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];\
    [self showAlert:@"Failed Autocomplete" withMessage:[error description]];
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
    //disallow first input to be 0
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@"0"]) {
        return NO;
    }

    // allow empty field or digit 0 to 9 for price field
    if (!string.length || [string intValue] || [string isEqualToString:@"0"])
    {
        return YES;
    }
    
    return NO;
}

// delegate for categoryHeaderView
-(void)didSelectCell: (NSIndexPath *)indexPath {
    self.eventCategory = indexPath.row;
}

- (void)didDeselectCell: (NSIndexPath *)indexPath{
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.editingPrice == YES) {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            self.prevY = self.view.frame.origin.y;
            f.origin.y = self.view.frame.origin.y - keyboardSize.height;
            self.view.frame = f;
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification {
    if (self.editingPrice == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = self.prevY;
            self.view.frame = f;

        }];
    self.editingPrice = NO;
    }
}

@end
