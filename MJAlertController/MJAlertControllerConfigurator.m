//
//  MJAlertControllerConfigurator.m
//  AlertController
//
//  Created by Joan Martin on 08/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertControllerConfigurator.h"

#import <UIColor+Additions/UIColor+Additions.h>

@implementation MJAlertControllerConfigurator
{
    NSMutableDictionary *_titleColors;
    NSMutableDictionary *_textColors;
    NSMutableDictionary *_titleFonts;
    NSMutableDictionary *_textFonts;
    NSMutableDictionary *_defaultButtonFonts;
    NSMutableDictionary *_destructiveButtonFonts;
    NSMutableDictionary *_cancelButtonFonts;
    NSMutableDictionary *_buttonHeights;
}

+ (MJAlertControllerConfigurator*)defaultConfigurator
{
    static MJAlertControllerConfigurator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MJAlertControllerConfigurator alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _configurationStyle = MJAlertControllerConfiguratorStyleText;
        
        _tintColor = [UIColor add_colorWithRed255:0 green255:122 blue255:255];
        _destructiveColor = [UIColor add_colorWithRed255:255 green255:59 blue255:48];
        _separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _backColor = [UIColor colorWithWhite:0.2 alpha:0.48];
        
        _titleColors = [NSMutableDictionary dictionary];
        _textColors = [NSMutableDictionary dictionary];
        _titleFonts = [NSMutableDictionary dictionary];
        _textFonts = [NSMutableDictionary dictionary];
        _defaultButtonFonts = [NSMutableDictionary dictionary];
        _destructiveButtonFonts = [NSMutableDictionary dictionary];
        _cancelButtonFonts = [NSMutableDictionary dictionary];
        _buttonHeights = [NSMutableDictionary dictionary];
        
        [self setTitleColor:[UIColor colorWithWhite:0.1 alpha:1.0] forStyle:MJAlertControllerStyleAlert];
        [self setTitleColor:[UIColor colorWithWhite:143.0/255.0 alpha:1.0] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setTextColor:[UIColor colorWithWhite:0.1 alpha:1.0] forStyle:MJAlertControllerStyleAlert];
        [self setTextColor:[UIColor colorWithWhite:143.0/255.0 alpha:1.0] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setTitleFont:[UIFont boldSystemFontOfSize:17] forStyle:MJAlertControllerStyleAlert];
        [self setTitleFont:[UIFont boldSystemFontOfSize:13] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setTextFont:[UIFont systemFontOfSize:14] forStyle:MJAlertControllerStyleAlert];
        [self setTextFont:[UIFont systemFontOfSize:13] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setDefaultButtonFont:[UIFont systemFontOfSize:17] forStyle:MJAlertControllerStyleAlert];
        [self setDefaultButtonFont:[UIFont systemFontOfSize:20] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setDestructiveButtonFont:[UIFont systemFontOfSize:17] forStyle:MJAlertControllerStyleAlert];
        [self setDestructiveButtonFont:[UIFont systemFontOfSize:20] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setCancelButtonFont:[UIFont boldSystemFontOfSize:17] forStyle:MJAlertControllerStyleAlert];
        [self setCancelButtonFont:[UIFont boldSystemFontOfSize:20] forStyle:MJAlertControllerStyleActionSheet];
        
        [self setButtonHeight:44 forStyle:MJAlertControllerStyleAlert];
        [self setButtonHeight:44 forStyle:MJAlertControllerStyleActionSheet];
        
        _cornerRadius = 6;
        _padding = 8;
        _cancelButtonPadding = 8;
    }
    return self;
}

- (UIColor*)titleColorForStyle:(MJAlertControllerStyle)style
{
    return _titleColors[@(style)];
}

- (void)setTitleColor:(UIColor*)color forStyle:(MJAlertControllerStyle)style
{
    if (color)
        _titleColors[@(style)] = color;
    else
        [_titleColors removeObjectForKey:@(style)];
}

- (UIColor*)textColorForStyle:(MJAlertControllerStyle)style
{
    return _textColors[@(style)];
}

- (void)setTextColor:(UIColor*)color forStyle:(MJAlertControllerStyle)style
{
    if (color)
        _textColors[@(style)] = color;
    else
        [_textColors removeObjectForKey:@(style)];
}

- (UIFont*)titleFontForStyle:(MJAlertControllerStyle)style
{
    return _titleFonts[@(style)];
}

- (void)setTitleFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style
{
    if (font)
        _titleFonts[@(style)] = font;
    else
        [_titleFonts removeObjectForKey:@(style)];
}

- (UIFont*)textFontForStyle:(MJAlertControllerStyle)style
{
    return _textFonts[@(style)];
}

- (void)setTextFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style
{
    if (font)
        _textFonts[@(style)] = font;
    else
        [_textFonts removeObjectForKey:@(style)];
}

- (UIFont*)defaultButtonFontForStyle:(MJAlertControllerStyle)style
{
    return _defaultButtonFonts[@(style)];
}

- (void)setDefaultButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style
{
    if (font)
        _defaultButtonFonts[@(style)] = font;
    else
        [_defaultButtonFonts removeObjectForKey:@(style)];
}

- (UIFont*)destructiveButtonFontForStyle:(MJAlertControllerStyle)style
{
    return _destructiveButtonFonts[@(style)];
}

- (void)setDestructiveButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style
{
    if (font)
        _destructiveButtonFonts[@(style)] = font;
    else
        [_destructiveButtonFonts removeObjectForKey:@(style)];
}

- (UIFont*)cancelButtonFontForStyle:(MJAlertControllerStyle)style
{
    return _cancelButtonFonts[@(style)];
}

- (void)setCancelButtonFont:(UIFont*)font forStyle:(MJAlertControllerStyle)style
{
    if (font)
        _cancelButtonFonts[@(style)] = font;
    else
        [_cancelButtonFonts removeObjectForKey:@(style)];
}

- (CGFloat)buttonHeightForStyle:(MJAlertControllerStyle)style
{
    return [_buttonHeights[@(style)] floatValue];
}

- (void)setButtonHeight:(CGFloat)height forStyle:(MJAlertControllerStyle)style
{
    _buttonHeights[@(style)] = @(height);
}

@end
