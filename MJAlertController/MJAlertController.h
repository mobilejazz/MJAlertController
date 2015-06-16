//
//  MJAlertController.h
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJAlertAction.h"

/**
 * The style of the alert.
 **/
typedef NS_ENUM(NSUInteger, MJAlertControllerStyle)
{
    /** Alert with UIAlertView style **/
    MJAlertControllerStyleAlert,
    
    /** Alert with UIActionSheet style **/
    MJAlertControllerStyleActionSheet,
};

@class MJAlertControllerConfigurator;

/**
 * Custom implementation of an `UIAlertController`.
 **/
@interface MJAlertController : UIViewController

/**
 * Default static initializer to display title and message.
 * @param title The title.
 * @param message The message.
 * @return The initialized instance.
 **/
+ (MJAlertController*)alertControllerWithTitle:(NSString*)title message:(NSString*)message preferredStyle:(MJAlertControllerStyle)style;

/**
 * Default static initializer to display attributed title and message.
 * @param title The attributed title.
 * @param message The attributed message.
 * @return The initialized instance.
 **/
+ (MJAlertController*)alertControllerWithAttributedTitle:(NSAttributedString*)title attributtedMessage:(NSAttributedString*)message preferredStyle:(MJAlertControllerStyle)style;

/**
 * Default static initializer.
 * @param viewController The view controller to show.
 * @return The initialized instance.
 * @discussion Alerts containing a view controller will be displayed with `MJAlertControllerStyleAlert` style. The size of the view controller must be specified in the method `preferredContentSize` of `UIViewController`.
 **/
+ (MJAlertController*)alertControllerWithViewController:(UIViewController*)viewController preferredStyle:(MJAlertControllerStyle)style;

/**
 * Default initializer to display title and message.
 * @param title The title.
 * @param message The message.
 * @return The initialized instance.
 **/
- (id)initWithTitle:(NSString*)title message:(NSString *)message preferredStyle:(MJAlertControllerStyle)style;

/**
 * Default initializer to display attributed title and message.
 * @param title The attributed title.
 * @param message The attributed message.
 * @return The initialized instance.
 **/
- (id)initWithAttributedTitle:(NSAttributedString*)title attributtedMessage:(NSAttributedString*)message preferredStyle:(MJAlertControllerStyle)style;

/**
 * Default initializer.
 * @param viewController The view controller to show.
 * @return The initialized instance.
 * @discussion Alerts containing a view controller will be displayed with `MJAlertControllerStyleAlert` style. The size of the view controller must be specified using the protocol `MJAlertControllerContainment` or via the method `preferredContentSize` of `UIViewController`.
 **/
- (id)initWithViewController:(UIViewController*)viewController preferredStyle:(MJAlertControllerStyle)style;

/**
 * Adds a new action.
 * @param alertAction The action to add.
 **/
- (void)addAction:(MJAlertAction*)alertAction;

/**
 * Configuration method.
 * @param  configurationBlock The style configuration block.
 * @discussion This method must be called before the alert's view is loaded, otherwise will throw an exception. If the alert is not configured, the default configuration will be used.
 **/
- (void)configureAlert:(void (^)(MJAlertControllerConfigurator *configurator))configurationBlock;

@end

#import "MJAlertControllerConfigurator.h"

/**
 * UIViewControllers can conform to this protocol to setup a preferred height for a given width.
 **/
@protocol MJAlertControllerContainment <NSObject>

@optional
/**
 * Return the preferred height for the given width.
 * @param style The alert controller style
 *
 **/
- (CGFloat)alertControllerWithStyle:(MJAlertControllerStyle)style preferredHeightForTargetWidth:(CGFloat)width;

@end

