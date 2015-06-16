//
//  MJAlertControllerTransitionManager.h
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Define a custom type for the transition mode.
 **/
typedef NS_ENUM(NSUInteger, MJAlertControllerTransitionTo)
{
    /** The modal controller is being dismissed **/
    MJAlertControllerTransitionToInitial,
    
    /** The modal controller is being presented **/
    MJAlertControllerTransitionToModal,
};

/**
 * A transition coordinator to manage transitions of MJAlertControllers.
 **/
@interface MJAlertControllerTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * The transtion style.
 **/
@property (nonatomic, assign) MJAlertControllerTransitionTo transitionTo;

@end
