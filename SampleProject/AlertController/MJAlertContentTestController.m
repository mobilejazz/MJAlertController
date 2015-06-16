//
//  MJAlertContentTestController.m
//  AlertController
//
//  Created by Joan Martin on 08/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertContentTestController.h"

#import "MJAlertController.h"

@interface MJAlertContentTestController () <MJAlertControllerContainment, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation MJAlertContentTestController


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_textField becomeFirstResponder];
}

- (CGFloat)alertControllerWithStyle:(MJAlertControllerStyle)style preferredHeightForTargetWidth:(CGFloat)width
{
    // Constant height
    return 121;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
