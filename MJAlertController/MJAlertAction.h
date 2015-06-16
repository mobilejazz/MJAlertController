//
//  MJAlertAction.h
//  AlertController
//
//  Created by Joan Martin on 09/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Enumeration of alert action styles.
 **/
typedef NS_ENUM(NSUInteger, MJAlertActionStyle)
{
    /** Default style **/
    MJAlertActionStyleDefault,
    
    /** Cancel style **/
    MJAlertActionStyleCancel,
    
    /** Destructive style **/
    MJAlertActionStyleDestructive
};

/**
 * Custom implementation of the `UIAlertAction`.
 **/
@interface MJAlertAction : NSObject

/**
 * Default static initializer.
 **/
+ (MJAlertAction*)actionWithTitle:(NSString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction *action))handler;

/**
 * Default static initializer.
 **/
+ (MJAlertAction*)actionWithAttributedTitle:(NSAttributedString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction *action))handler;

/** @property The title **/
@property (nonatomic, strong, readonly) NSString *title;

/** @property The attributted title **/
@property (nonatomic, strong, readonly) NSAttributedString *attributedTitle;

/** @property The style **/
@property (nonatomic, assign, readonly) MJAlertActionStyle style;

/** @property The action block **/
@property (nonatomic, strong, readonly) void (^handler)(MJAlertAction*);

@end