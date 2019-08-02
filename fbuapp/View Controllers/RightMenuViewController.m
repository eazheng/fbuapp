//
//  RightMenuViewController.m
//  fbuapp
//
//  Created by belchercd on 8/2/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "RightMenuViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "MainNavigationController.h"
#import "LMSideBarController.h"


@interface RightMenuViewController ()
@property (nonatomic, strong) NSArray *menuTitles;


@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuTitles = @[@"Edit", @"Favorites", @"Logout"];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.menuTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.11 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.sideBarController hideMenuViewController:YES];
    
    MainNavigationController *navigationController = [[MainNavigationController alloc] init];
    navigationController = self.sideBarController.contentViewController;
    
    NSString *menuTitle = self.menuTitles[indexPath.row];
    if ([menuTitle isEqualToString:@"Edit"]) {
        [navigationController showEditViewController];
    }
    else if ([menuTitle isEqualToString:@"Favorites"]) {
        [navigationController showSavedViewController];

    }
    else if ([menuTitle isEqualToString:@"Logout"]) {
        [navigationController showLogoutViewContorller];
    }
}
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
