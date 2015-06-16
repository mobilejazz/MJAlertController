//
//  MJTitleMessageAlertController.m
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJTitleMessageAlertController.h"

#import <Lyt/Lyt.h>

#import "MJAlertControllerConfigurator.h"
#import "MJAlertController.h"

#define VERTICAL_MARGIN     (_style==MJAlertControllerStyleAlert?20:15)
#define SIDES_MARGIN        15
#define INTERSPACE_OFFSET   (_style==MJAlertControllerStyleAlert?8:2)

@interface MJTitleMessageAlertController () <MJAlertControllerContainment>

@end

@implementation MJTitleMessageAlertController
{
    UILabel *_titleLabel;
    UILabel *_messageLabel;
}

- (id)initWithTitle:(NSString*)title
            message:(NSString *)message
              style:(MJAlertControllerStyle)style
      configuration:(MJAlertControllerConfigurator *)configuration
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _style = style;
        _configuration = configuration;
        
        _titleText = title;
        _messageText = message;
    }
    return self;
}

- (id)initWithAttributedTitle:(NSAttributedString*)title
            attributedMessage:(NSAttributedString*)message
                        style:(MJAlertControllerStyle)style
                configuration:(MJAlertControllerConfigurator*)configuration
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _style = style;
        _configuration = configuration;
        
        _attributedTitleText = title;
        _attributedMessageText = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_titleText.length > 0 || _attributedTitleText.length > 0)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_titleLabel];
        [_titleLabel lyt_alignTopToParentWithMargin:VERTICAL_MARGIN];
        [_titleLabel lyt_alignSidesToParentWithMargin:SIDES_MARGIN];
    }
    
    if (_messageText.length > 0 || _attributedMessageText.length > 0)
    {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_messageLabel];
        [_messageLabel lyt_alignSidesToParentWithMargin:SIDES_MARGIN];
        
        if (!_titleLabel)
            [_messageLabel lyt_alignTopToParentWithMargin:VERTICAL_MARGIN];
        else
            [_messageLabel lyt_placeBelowView:_titleLabel margin:INTERSPACE_OFFSET];
    }
    
    _titleLabel.font = [_configuration titleFontForStyle:_style];
    _titleLabel.textColor = [_configuration titleColorForStyle:_style];
    
    _messageLabel.font = [_configuration textFontForStyle:_style];
    _messageLabel.textColor = [_configuration textColorForStyle:_style];
    
    if (_titleText.length > 0)
        _titleLabel.text = _titleText;
    else if (_attributedTitleText.length > 0)
        _titleLabel.attributedText = _attributedTitleText;
    
    if (_messageText.length > 0)
        _messageLabel.text = _messageText;
    else if (_attributedMessageText.length > 0)
        _messageLabel.attributedText = _attributedMessageText;
}

- (CGSize)preferredContentSize
{
    (void)self.view;
    CGFloat width = floorf([UIScreen mainScreen].bounds.size.width*0.73);
    CGFloat height = [self mjz_heightForTargetSize:CGSizeMake(width, 0)];
    return CGSizeMake(width, height);
}

- (CGFloat)mjz_heightForTargetSize:(CGSize)targetSize
{
    CGFloat width = targetSize.width;
    UIEdgeInsets insets = UIEdgeInsetsMake(VERTICAL_MARGIN, SIDES_MARGIN, VERTICAL_MARGIN, SIDES_MARGIN);
    
    CGSize size = CGSizeMake(width - insets.left - insets.right, CGFLOAT_MAX);
    CGRect bounds1 = CGRectZero;
    CGRect bounds2 = CGRectZero;
    
    if (_titleText.length > 0 || _messageText.length > 0)
    {
        if (_titleText.length > 0)
            bounds1 = [_titleText boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [_configuration titleFontForStyle:_style]}
                                               context:nil];
        
        if (_messageText.length > 0)
            bounds2 = [_messageText boundingRectWithSize:size
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: [_configuration textFontForStyle:_style]}
                                                 context:nil];
    }
    else if (_attributedTitleText.length > 0 || _attributedMessageText.length > 0)
    {
        if (_attributedTitleText.length > 0)
            bounds1 = [_attributedTitleText boundingRectWithSize:size
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                          context:nil];
        
        if (_attributedMessageText.length > 0)
            bounds2 = [_attributedMessageText boundingRectWithSize:size
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           context:nil];
    }
    else
    {
        return 0;
    }
    
    CGFloat separator = (bounds1.size.height>0 && bounds2.size.height>0) ? INTERSPACE_OFFSET : 0;
    CGFloat height = ceilf(insets.top + bounds1.size.height + separator + bounds2.size.height + insets.bottom) + 1;
    return height;
}

#pragma mark - Protocols
#pragma mark MJAlertControllerContainment

- (CGFloat)alertControllerWithStyle:(MJAlertControllerStyle)style preferredHeightForTargetWidth:(CGFloat)width
{
    (void)self.view;
    CGFloat height = [self mjz_heightForTargetSize:CGSizeMake(width, 0)];
    return height;
}

@end
