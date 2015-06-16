//
//  MJTitleMessageAlertController.h
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJAlertController.h"

/**
 * View controller used internally on MJAlertController to display alerts with a title and a message.
 **/
@interface MJTitleMessageAlertController : UIViewController

- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
              style:(MJAlertControllerStyle)style
      configuration:(MJAlertControllerConfigurator*)configuration;

- (id)initWithAttributedTitle:(NSAttributedString*)title
            attributedMessage:(NSAttributedString*)message
                        style:(MJAlertControllerStyle)style
                configuration:(MJAlertControllerConfigurator*)configuration;

@property (nonatomic, strong, readonly) NSString *titleText;
@property (nonatomic, strong, readonly) NSString *messageText;

@property (nonatomic, strong, readonly) NSAttributedString *attributedTitleText;
@property (nonatomic, strong, readonly) NSAttributedString *attributedMessageText;

@property (nonatomic, assign, readonly) MJAlertControllerStyle style;
@property (nonatomic, strong, readonly) MJAlertControllerConfigurator *configuration;

@end
