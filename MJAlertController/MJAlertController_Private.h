//
//  MJAlertController_Private.h
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertController.h"

@interface MJAlertController ()

@property (nonatomic, assign) MJAlertControllerStyle preferredStyle;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertContainerView;

@end
