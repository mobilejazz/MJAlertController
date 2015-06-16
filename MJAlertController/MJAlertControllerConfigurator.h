//
//  MJAlertControllerConfigurator.h
//  AlertController
//
//  Created by Joan Martin on 08/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJAlertController.h"

typedef NS_ENUM (NSUInteger, MJAlertControllerConfiguratorStyle)
{
    MJAlertControllerConfiguratorStyleText,
    MJAlertControllerConfiguratorStyleBackground,
};

@interface MJAlertControllerConfigurator : NSObject

+ (MJAlertControllerConfigurator*)defaultConfigurator;

/** ************************************************************************ **
 * @name Configuring style
 ** ************************************************************************ **/

@property (nonatomic, assign) MJAlertControllerConfiguratorStyle configurationStyle;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *destructiveColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *backColor;

- (UIColor*)titleColorForStyle:(MJAlertControllerStyle)style;
- (void)setTitleColor:(UIColor*)color forStyle:(MJAlertControllerStyle)style;

- (UIColor*)textColorForStyle:(MJAlertControllerStyle)style;
- (void)setTextColor:(UIColor*)color forStyle:(MJAlertControllerStyle)style;

- (UIFont*)titleFontForStyle:(MJAlertControllerStyle)style;
- (void)setTitleFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style;

- (UIFont*)textFontForStyle:(MJAlertControllerStyle)style;
- (void)setTextFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style;

- (UIFont*)defaultButtonFontForStyle:(MJAlertControllerStyle)style;
- (void)setDefaultButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style;

- (UIFont*)destructiveButtonFontForStyle:(MJAlertControllerStyle)style;
- (void)setDestructiveButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style;

- (UIFont*)cancelButtonFontForStyle:(MJAlertControllerStyle)style;
- (void)setCancelButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style;

/** ************************************************************************ **
 * @name Configuring Layout
 ** ************************************************************************ **/

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat cancelButtonPadding;

- (CGFloat)buttonHeightForStyle:(MJAlertControllerStyle)style;
- (void)setButtonHeight:(CGFloat)height forStyle:(MJAlertControllerStyle)style;

@end
