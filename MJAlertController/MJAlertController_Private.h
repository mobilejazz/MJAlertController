//
//  MJAlertController_Private.h
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertController.h"

@interface MJAlertController ()

/**
 * The preferred style.
 **/
@property (nonatomic, assign) MJAlertControllerStyle preferredStyle;

/**
 * The background view.
 **/
@property (nonatomic, strong) UIView *backgroundView;

/**
 * The alert content view.
 **/
@property (nonatomic, strong) UIView *contentView;

@end
