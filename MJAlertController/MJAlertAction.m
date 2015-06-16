//
//  MJAlertAction.m
//  AlertController
//
//  Created by Joan Martin on 09/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertAction.h"

@implementation MJAlertAction

+ (MJAlertAction*)actionWithTitle:(NSString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction*))handler
{
    return [[MJAlertAction alloc] initWithTitle:title style:style handler:handler];
}

+ (MJAlertAction*)actionWithAttributedTitle:(NSAttributedString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction *action))handler
{
    return [[MJAlertAction alloc] initWithAttributedTitle:title style:style handler:handler];
}

- (id)initWithTitle:(NSString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction*))handler
{
    self = [super init];
    if (self)
    {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

- (id)initWithAttributedTitle:(NSAttributedString*)title style:(MJAlertActionStyle)style handler:(void (^)(MJAlertAction *action))handler
{
    self = [super init];
    if (self)
    {
        _attributedTitle = title;
        _style = style;
        _handler = handler;
    }
    return self;
}


@end