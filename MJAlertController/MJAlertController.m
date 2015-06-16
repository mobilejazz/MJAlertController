//
//  MJAlertController.m
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertController_Private.h"

#import <Lyt/Lyt.h>
#import <UIImage+Additions/UIImage+Additions.h>
#import <UIColor+Additions/UIColor+Additions.h>

#import "MJAlertControllerTransitionManager.h"
#import "MJTitleMessageAlertController.h"

#define SEPARATOR_WIDTH 0.5

@interface MJAlertController () <UIViewControllerTransitioningDelegate>

@end

@implementation MJAlertController
{
    MJAlertControllerTransitionManager *_transitionManager;
    MJAlertControllerConfigurator *_configuration;
    
    UIViewController *_containedViewController;
    NSMutableArray *_actions;
    NSArray *_buttons;
    
    UILabel *_sheetTitleLabel;
    UILabel *_sheetMessageLabel;
    
    BOOL _hasCancelAction;
    BOOL _hasDestructiveAction;
    BOOL _viewDidAppearFlag;
    
    NSLayoutConstraint *_alertCenterYLayoutConstraint;
    NSLayoutConstraint *_sheetBottomLayoutConstraint;
}

+ (MJAlertController*)alertControllerWithTitle:(NSString*)title message:(NSString*)message preferredStyle:(MJAlertControllerStyle)style;
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:style];
}

+ (MJAlertController*)alertControllerWithViewController:(UIViewController*)viewController preferredStyle:(MJAlertControllerStyle)style
{
    return [[self alloc] initWithViewController:viewController preferredStyle:style];
}

+ (MJAlertController*)alertControllerWithAttributedTitle:(NSAttributedString*)title attributtedMessage:(NSAttributedString*)message preferredStyle:(MJAlertControllerStyle)style
{
    return [[self alloc] initWithAttributedTitle:title attributtedMessage:message preferredStyle:style];
}

- (id)initWithTitle:(NSString*)title message:(NSString *)message preferredStyle:(MJAlertControllerStyle)style
{
    MJAlertControllerConfigurator *configurator = [MJAlertControllerConfigurator defaultConfigurator];
    MJTitleMessageAlertController *viewController = [[MJTitleMessageAlertController alloc] initWithTitle:title
                                                                                                 message:message
                                                                                                   style:style
                                                                                           configuration:configurator];
    return [self initWithViewController:viewController preferredStyle:style configurator:configurator];
}

- (id)initWithAttributedTitle:(NSAttributedString*)title attributtedMessage:(NSAttributedString*)message preferredStyle:(MJAlertControllerStyle)style
{
    MJAlertControllerConfigurator *configurator = [MJAlertControllerConfigurator defaultConfigurator];
    MJTitleMessageAlertController *viewController = [[MJTitleMessageAlertController alloc] initWithAttributedTitle:title
                                                                                                 attributedMessage:message
                                                                                                             style:style
                                                                                                     configuration:configurator];
    return [self initWithViewController:viewController preferredStyle:style configurator:configurator];
}

- (id)initWithViewController:(UIViewController*)viewController preferredStyle:(MJAlertControllerStyle)style
{
    MJAlertControllerConfigurator *configurator = [MJAlertControllerConfigurator defaultConfigurator];
    return [self initWithViewController:viewController preferredStyle:style configurator:configurator];
}

- (id)initWithViewController:(UIViewController*)viewController preferredStyle:(MJAlertControllerStyle)style configurator:(MJAlertControllerConfigurator*)configurator
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _configuration = configurator;
        
        _preferredStyle = style;
        _containedViewController = viewController;
        _actions = [NSMutableArray array];
        
        _transitionManager = [[MJAlertControllerTransitionManager alloc] init];
        
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mjz_keyboardDidChangeNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _viewDidAppearFlag = YES;
}

#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ---------------------------------------------------------------------------
    // Creating the background view
    //
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.userInteractionEnabled = YES;
    _backgroundView.backgroundColor = _configuration.backColor;
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_backgroundView];
    [_backgroundView lyt_alignToParent];
    
    if (_preferredStyle == MJAlertControllerStyleAlert)
    {
        [self mjz_setupWithAlertStyle];
    }
    else if (_preferredStyle == MJAlertControllerStyleActionSheet)
    {
        [self mjz_setupWithSheetStyle];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    
    if (parent)
        [self addChildViewController:_containedViewController];
    else
        [_containedViewController willMoveToParentViewController:nil];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    
    if (parent)
        [_containedViewController didMoveToParentViewController:self];
    else
        [_containedViewController removeFromParentViewController];
}

#pragma mark Public Methods

- (void)addAction:(MJAlertAction*)alertAction
{
    BOOL isCancelAction = alertAction.style == MJAlertActionStyleCancel;
    if (isCancelAction)
    {
        if (_hasCancelAction)
        {
            NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                             reason:[NSString stringWithFormat:@"Cannot add more than one action with MJAlertActionStyleCancel style"]
                                                           userInfo:nil];
            [exception raise];
        }
        _hasCancelAction = YES;
    }
    
    BOOL isDestructiveAction = alertAction.style == MJAlertActionStyleDestructive;
    if (isDestructiveAction)
    {
        if (_hasDestructiveAction)
        {
            NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                             reason:[NSString stringWithFormat:@"Cannot add more than one action with MJAlertActionStyleDestructive style"]
                                                           userInfo:nil];
            [exception raise];
        }
        _hasDestructiveAction = YES;
    }
    
    [_actions addObject:alertAction];
}

- (void)configureAlert:(void (^)(MJAlertControllerConfigurator *configurator))configurationBlock
{
    if (self.isViewLoaded)
    {
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:[NSString stringWithFormat:@"Cannot configure the alert controller once the view has loaded"]
                                                       userInfo:nil];
        [exception raise];
    }
    
    MJAlertControllerConfigurator *configurator = [[MJAlertControllerConfigurator alloc] init];
    
    if (configurationBlock)
        configurationBlock(configurator);
    
    _configuration = configurator;
}

#pragma mark Private Methods

- (CGSize)mjz_sizeForAlertContent
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.height < screenSize.width)
        screenSize = CGSizeMake(screenSize.height, screenSize.width);
    CGSize desiredSize = CGSizeMake(270, 0);
    
    if ([_containedViewController conformsToProtocol:@protocol(MJAlertControllerContainment)] &&
        [_containedViewController respondsToSelector:@selector(alertControllerWithStyle:preferredHeightForTargetWidth:)])
    {
        desiredSize.height = [(id <MJAlertControllerContainment>)_containedViewController alertControllerWithStyle:_preferredStyle
                                                                                     preferredHeightForTargetWidth:desiredSize.width];
    }
    else
    {
        CGSize contentSize = [_containedViewController preferredContentSize];
        
        desiredSize.width = contentSize.width;
        desiredSize.height = contentSize.height;
    }
    
    CGSize maxSize = screenSize;
    maxSize.height -= 2*_configuration.padding;
    maxSize.width -= 2*_configuration.padding;
    
    if (_actions.count <= 2)
        maxSize.height -= [_configuration buttonHeightForStyle:_preferredStyle];
    else if (_actions.count > 2)
        maxSize.height -= [_configuration buttonHeightForStyle:_preferredStyle]*_actions.count;
    
    CGSize minSize = screenSize;
    minSize.width = _actions.count==0?0:88;
    minSize.height = 0;
    
    CGSize finalSize;
    finalSize.width = MAX(minSize.width, MIN(maxSize.width, desiredSize.width));
    finalSize.height = MAX(minSize.height, MIN(maxSize.height, desiredSize.height));
    
    return finalSize;
}

- (CGSize)mjz_sizeForSheetContent
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = MIN(screenSize.width, screenSize.height);
    CGSize desiredSize = CGSizeMake(width - 2*_configuration.padding, 0);
    
    if ([_containedViewController conformsToProtocol:@protocol(MJAlertControllerContainment)] &&
        [_containedViewController respondsToSelector:@selector(alertControllerWithStyle:preferredHeightForTargetWidth:)])
    {
        desiredSize.height = [(id <MJAlertControllerContainment>)_containedViewController alertControllerWithStyle:_preferredStyle
                                                                                     preferredHeightForTargetWidth:desiredSize.width];
    }
    else
    {
        desiredSize.width = [_containedViewController preferredContentSize].width;
    }
    
    CGSize maxSize = screenSize;
    maxSize.height = screenSize.height - 2*_configuration.padding;
    
    if (_actions.count > 0)
        maxSize.height -= _actions.count*[_configuration buttonHeightForStyle:_preferredStyle];

    if (_hasCancelAction)
        maxSize.height -= _configuration.cancelButtonPadding;
    
    CGSize finalSize;
    finalSize.width = MIN(maxSize.width, desiredSize.width);
    finalSize.height = MIN(maxSize.height, desiredSize.height);

    return finalSize;
}

- (void)mjz_buttonAction:(UIButton*)sender
{
    NSInteger index = [_buttons indexOfObject:sender];
    
    if (index != NSNotFound)
    {
        MJAlertAction *action = _actions[index];
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (action.handler)
                action.handler(action);
        }];
    }
    else
    {
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:[NSString stringWithFormat:@"Unknown action for button '%@'", [sender titleForState:UIControlStateNormal]]
                                                       userInfo:nil];
        [exception raise];
    }
}

- (void)mjz_setupWithAlertStyle
{
    // ---------------------------------------------------------------------------
    // Creating the container view
    //
    _alertContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _alertContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_alertContainerView];

    [_alertContainerView lyt_centerXInParent];
    _alertCenterYLayoutConstraint = [_alertContainerView lyt_centerYInParent];
    
    _alertContainerView.clipsToBounds = YES;
    _alertContainerView.layer.cornerRadius = _configuration.cornerRadius;
    
    CGSize contentSize = [self mjz_sizeForAlertContent];
    if (_actions.count == 0)
        [_alertContainerView lyt_setSize:contentSize];
    else if (_actions.count <= 2)
        [_alertContainerView lyt_setSize:CGSizeMake(contentSize.width, contentSize.height+[_configuration buttonHeightForStyle:_preferredStyle])];
    else
        [_alertContainerView lyt_setSize:CGSizeMake(contentSize.width, contentSize.height+_actions.count*[_configuration buttonHeightForStyle:_preferredStyle])];
    
    // ---------------------------------------------------------------------------
    // Inserting the viewController
    //
    UIView *viewControllerView = _containedViewController.view;
    viewControllerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertContainerView addSubview:viewControllerView];
    [viewControllerView lyt_alignTopToParent];
    [viewControllerView lyt_alignSidesToParent];
    [viewControllerView lyt_setHeight:contentSize.height];
    
    // ---------------------------------------------------------------------------
    // Inserting the buttons
    //
    NSInteger counter = _actions.count;
    NSArray *actions = _actions;
    if (actions.count > 2)
        actions = [self mjz_arrayWithSortedActions];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:counter];
    __block UIButton *previousButton = nil;
    
    [actions enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(MJAlertAction *action, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [_alertContainerView addSubview:button];
        
        if (counter <= 2)
        {
            [button lyt_alignBottomToParent];
            [button lyt_setHeight:[_configuration buttonHeightForStyle:_preferredStyle]];
            [button lyt_matchWidthToView:_alertContainerView multiplier:1.0/counter];
            
            if (previousButton)
            {
                [button lyt_placeLeftOfView:previousButton];
                
                UIView *separatorLine = [self mjz_createSeparatorView];
                [_alertContainerView addSubview:separatorLine];
                
                [separatorLine lyt_placeRightOfView:button];
                [separatorLine lyt_setWidth:SEPARATOR_WIDTH];
                [separatorLine lyt_alignTopToView:button];
                [separatorLine lyt_alignBottomToView:button];
            }
            else
            {
                [button lyt_alignRightToParent];
            }
        }
        else
        {
            [button lyt_alignSidesToParent];
            [button lyt_setHeight:[_configuration buttonHeightForStyle:_preferredStyle]];
            if (previousButton)
            {
                [button lyt_placeAboveView:previousButton];
                
                UIView *separatorLine = [self mjz_createSeparatorView];
                [_alertContainerView addSubview:separatorLine];
                [separatorLine lyt_alignSidesToParent];
                [separatorLine lyt_setHeight:SEPARATOR_WIDTH];
                [separatorLine lyt_alignBottomToView:button];
            }
            else
                [button lyt_alignBottomToParent];
        }
        
        UIColor *textColor = nil;
        UIColor *buttonColor = nil;
        
        if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleText)
        {
            textColor = _configuration.tintColor;
            buttonColor = [UIColor whiteColor];
        }
        else //if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleBackground)
        {
            textColor = [UIColor whiteColor];
            buttonColor = _configuration.tintColor;
        }
        
        UIFont *font = [_configuration defaultButtonFontForStyle:_preferredStyle];
        
        if (action.style == MJAlertActionStyleCancel)
        {
            font = [_configuration cancelButtonFontForStyle:_preferredStyle];
        }
        else if (action.style == MJAlertActionStyleDestructive)
        {
            font = [_configuration destructiveButtonFontForStyle:_preferredStyle];
            
            if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleText)
                textColor = _configuration.destructiveColor;
            else //if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleBackground)
                buttonColor = _configuration.destructiveColor;
        }
        
        button.titleLabel.font = font;
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage add_resizableImageWithColor:buttonColor]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage add_resizableImageWithColor:[buttonColor add_darkerColorWithValue:0.05]]
                          forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(mjz_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (action.attributedTitle)
            [button setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
        else
            [button setTitle:action.title forState:UIControlStateNormal];
        
        previousButton = button;
        [buttons addObject:button];
    }];
    
    if (_actions.count > 0)
    {
        UIView *separatorLine = [self mjz_createSeparatorView];
        [_alertContainerView addSubview:separatorLine];
        [separatorLine lyt_alignSidesToParent];
        [separatorLine lyt_setHeight:SEPARATOR_WIDTH];
        [separatorLine lyt_alignBottomToView:viewControllerView];
    }
    
    _buttons = [buttons copy];
}

- (void)mjz_setupWithSheetStyle
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mjz_tapGestureRecognized:)];
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    // ---------------------------------------------------------------------------
    // Creating the container view
    //
    _alertContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _alertContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_alertContainerView];
    _alertContainerView.clipsToBounds = YES;
    _alertContainerView.layer.cornerRadius = _configuration.cornerRadius;
    
    CGSize contentSize = [self mjz_sizeForSheetContent];
    CGSize sheetSize = contentSize;
    
    if (_actions.count > 0)
    {
        // Adding one button height per action
        sheetSize.height += _actions.count * [_configuration buttonHeightForStyle:_preferredStyle];
    }
    
    if (_hasCancelAction)
    {
        // Adding the spacing from actions to cancel action
        sheetSize.height += _configuration.cancelButtonPadding;
    }
    
    // Setting the sheet size
    _sheetBottomLayoutConstraint = [_alertContainerView lyt_alignBottomToParentWithMargin:_configuration.padding];
    [_alertContainerView lyt_centerXInParent];
    [_alertContainerView lyt_setSize:sheetSize];
    
    
    // ---------------------------------------------------------------------------
    // Inserting the viewController
    //
    UIView *viewControllerView = _containedViewController.view;
    viewControllerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_alertContainerView addSubview:viewControllerView];
    [viewControllerView lyt_alignTopToParent];
    [viewControllerView lyt_alignSidesToParent];
    [viewControllerView lyt_setHeight:contentSize.height];
    
    // ---------------------------------------------------------------------------
    // Inserting the buttons
    //
    NSInteger counter = _actions.count;
    NSArray *actions = [self mjz_arrayWithSortedActions];
    
    // Listing actions
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:counter];
    __block UIButton *previousButton = nil;
    [actions enumerateObjectsWithOptions:0 usingBlock:^(MJAlertAction *action, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [_alertContainerView addSubview:button];
        [button lyt_alignSidesToParent];
        [button lyt_setHeight:[_configuration buttonHeightForStyle:_preferredStyle]];
        
        if (previousButton)
        {
            CGFloat margin = action.style == MJAlertActionStyleCancel ? _configuration.cancelButtonPadding : 0;
            [button lyt_placeBelowView:previousButton margin:margin];
        }
        else
        {
            // Placing first button below view controller
            [button lyt_placeBelowView:viewControllerView];
        }
        
        UIColor *textColor = _configuration.tintColor;
        UIColor *buttonColor = [UIColor whiteColor];
        
        UIFont *font = [_configuration defaultButtonFontForStyle:_preferredStyle];
        ADDCornerInset cornerInset = ADDCornerInsetZero;
        
        if (action.style == MJAlertActionStyleCancel)
        {
            font = [_configuration cancelButtonFontForStyle:_preferredStyle];
            
            if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleText)
            {
                buttonColor = [UIColor whiteColor];
                textColor = _configuration.tintColor;
            }
            else if (_configuration.configurationStyle == MJAlertControllerConfiguratorStyleBackground)
            {
                buttonColor = _configuration.tintColor;
                textColor = [UIColor whiteColor];
            }
            
            cornerInset = ADDCornerInsetMakeWithRadius(_configuration.cornerRadius);
        }
        else if (action.style == MJAlertActionStyleDestructive)
        {
            font = [_configuration destructiveButtonFontForStyle:_preferredStyle];
            textColor = _configuration.destructiveColor;
        }
        
        BOOL addSeparator = YES;
        
        if (idx == counter-1)
        {
            // Last row
            addSeparator = NO;
        }
        else if (idx+1 == counter-1)
        {
            MJAlertAction *nextAction = actions[idx+1];
            if (nextAction.style == MJAlertActionStyleCancel)
            {
                // Next button is cancel button
                addSeparator = NO;
                cornerInset = ADDCornerInsetMake(0, 0, _configuration.cornerRadius, _configuration.cornerRadius);
            }
        }

        if (addSeparator)
        {
            UIView *separatorLine = [self mjz_createSeparatorView];
            [_alertContainerView addSubview:separatorLine];
            [separatorLine lyt_alignSidesToParent];
            [separatorLine lyt_setHeight:SEPARATOR_WIDTH];
            [separatorLine lyt_alignBottomToView:button];
        }
        
        button.titleLabel.font = font;
        [button setTitleColor:textColor forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage add_resizableImageWithColor:buttonColor cornerInset:cornerInset]
                          forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage add_resizableImageWithColor:[buttonColor add_darkerColorWithValue:0.05] cornerInset:cornerInset]
                          forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(mjz_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (action.attributedTitle)
            [button setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
        else
            [button setTitle:action.title forState:UIControlStateNormal];
        
        previousButton = button;
        [buttons addObject:button];

    }];
    
    if (actions.count > 0 &&
        [(MJAlertAction*)[actions firstObject] style] != MJAlertActionStyleCancel &&
        contentSize.height > 0)
    {
        UIView *separatorLine = [self mjz_createSeparatorView];
        [_alertContainerView addSubview:separatorLine];
        [separatorLine lyt_alignSidesToParent];
        [separatorLine lyt_setHeight:SEPARATOR_WIDTH];
        [separatorLine lyt_alignBottomToView:viewControllerView];
    }
    
    _buttons = [buttons copy];
}

- (UIView*)mjz_createSeparatorView
{
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectZero];
    separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    separatorLine.userInteractionEnabled = NO;
    separatorLine.backgroundColor = _configuration.separatorColor;
    
    return separatorLine;
}

- (void)mjz_tapGestureRecognized:(UITapGestureRecognizer*)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray*)mjz_arrayWithSortedActions
{
    NSMutableArray *actions = [NSMutableArray array];
    __block MJAlertAction *cancelAction = nil;
    __block MJAlertAction *destructiveAction = nil;
    
    [_actions enumerateObjectsWithOptions:0 usingBlock:^(MJAlertAction *action, NSUInteger idx, BOOL *stop) {
        if (action.style == MJAlertActionStyleCancel)
            cancelAction = action;
        else if (action.style == MJAlertActionStyleDestructive)
            destructiveAction = action;
        else
            [actions addObject:action];
    }];
    
    if (destructiveAction)
    {
        // Appending destructive button at the end.
        [actions addObject:destructiveAction];
    }
    
    if (cancelAction)
    {
        // Appending cancel button at the end.
        [actions addObject:cancelAction];
    }
    
    return actions;
}

- (void)mjz_keyboardDidChangeNotification:(NSNotification*)notification
{
    CGRect frame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    void (^performAnimation)(BOOL animated, void (^animationBlock)()) = ^(BOOL animated, void (^animationBlock)()) {
        if (animated)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationDuration:duration];
            animationBlock();
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            [UIView commitAnimations];
        }
        else
        {
            [UIView performWithoutAnimation:^{
                animationBlock();
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }];
        }
    };
    
    if (_preferredStyle == MJAlertControllerStyleAlert)
    {
        CGPoint center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
        CGPoint newCenter = CGPointMake(self.view.bounds.size.width/2.0, frame.origin.y/2.0);
        
        CGFloat offset = newCenter.y - center.y;
        
        performAnimation(_viewDidAppearFlag, ^{
            _alertCenterYLayoutConstraint.constant = offset;
        });
    }
    else if (_preferredStyle == MJAlertControllerStyleActionSheet)
        
    {
        CGFloat keyboardOffset = self.view.bounds.size.height - frame.origin.y;
        CGFloat topActionsOffset = _actions.count*[_configuration buttonHeightForStyle:MJAlertControllerStyleActionSheet] + _configuration.padding + (_hasCancelAction?_configuration.padding:0);
        
        CGFloat finalOffset = 0;
        if (topActionsOffset < keyboardOffset)
            finalOffset = keyboardOffset - topActionsOffset;
        
        CGFloat bottomMargin = _configuration.padding + finalOffset;
        
        performAnimation(_viewDidAppearFlag, ^{
            _sheetBottomLayoutConstraint.constant = -bottomMargin;
        });
    }
}

#pragma mark - Protocols
#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:MJAlertController.class])
    {
        _transitionManager.transitionTo = MJAlertControllerTransitionToModal;
        return _transitionManager;
    }
    
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:MJAlertController.class])
    {
        _transitionManager.transitionTo = MJAlertControllerTransitionToInitial;
        return _transitionManager;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

@end
