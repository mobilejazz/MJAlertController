//
//  ViewController.m
//  AlertController
//
//  Created by Joan Martin on 08/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "ViewController.h"

#import "NSString+Additions.h"

#import "MJAlertController.h"

#import "MJAlertContentTestController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)mjz_segmentControlDidChange:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        [MJAlertControllerConfigurator defaultConfigurator].configurationStyle = MJAlertControllerConfiguratorStyleText;
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        [MJAlertControllerConfigurator defaultConfigurator].configurationStyle = MJAlertControllerConfiguratorStyleBackground;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title"
                                                                                     message:@"Alert message can be a long text or a short text. However we cannot include custom content."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"View"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            MJAlertController *alertController = [MJAlertController alertControllerWithTitle:@"Alert Title"
                                                                                     message:@"Alert message can be a long text or a short text. Also, we can include custom content."
                                                                              preferredStyle:MJAlertControllerStyleAlert];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 2)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title"
                                                                                     message:@"Alert message can be a long text or a short text. However we cannot include custom content."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"View"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Purchase"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Delete"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 3)
        {
            MJAlertController *alertController = [MJAlertController alertControllerWithTitle:@"Alert Title"
                                                                                     message:@"Alert message can be a long text or a short text. Also, we can include custom content."
                                                                              preferredStyle:MJAlertControllerStyleAlert];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Purchase"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            [alertController addAction:[MJAlertAction actionWithTitle:@"Delete"
                                                                style:MJAlertActionStyleDestructive
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            MJAlertController *alertController = [MJAlertController alertControllerWithAttributedTitle:[NSAttributedString attributedStringWithStrings:@[@"Alert ", @"Title"]
                                                                                                                                                 fonts:@[[UIFont boldSystemFontOfSize:17]]
                                                                                                                                            textColors:@[[UIColor orangeColor], [UIColor greenColor]]]
                                                                                    attributtedMessage:[NSAttributedString attributedStringWithStrings:@[@"Alert message can be a ",
                                                                                                                                                         @"long text",
                                                                                                                                                         @" or ",
                                                                                                                                                         @"short text",
                                                                                                                                                         @". Also, we can use ",
                                                                                                                                                         @"attributed strings",
                                                                                                                                                         @"."]
                                                                                                                                                 fonts:@[[UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont boldSystemFontOfSize:17],
                                                                                                                                                         [UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont boldSystemFontOfSize:10],
                                                                                                                                                         [UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont fontWithName:@"HelveticaNeue-light" size:19],
                                                                                                                                                         [UIFont systemFontOfSize:13],]
                                                                                                                                            textColors:@[[UIColor grayColor],
                                                                                                                                                         [UIColor blackColor],
                                                                                                                                                         [UIColor grayColor],
                                                                                                                                                         [UIColor blackColor],
                                                                                                                                                         [UIColor grayColor],
                                                                                                                                                         [UIColor purpleColor],
                                                                                                                                                         [UIColor grayColor]]]
                                                                                        preferredStyle:MJAlertControllerStyleAlert];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithAttributedTitle:[NSAttributedString attributedStringWithStrings:@[@"Vi",
                                                                                                                                  @"ew"]
                                                                                                                          fonts:@[[UIFont fontWithName:@"HelveticaNeue" size:21],
                                                                                                                                  [UIFont systemFontOfSize:18]]
                                                                                                                     textColors:@[[UIColor redColor],
                                                                                                                                  [UIColor yellowColor]]]
                                                                          style:MJAlertActionStyleDefault
                                                                        handler:^(MJAlertAction *action) {
                                                                            NSLog(@"Alert button tapped");
                                                                        }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            MJAlertContentTestController *testController = [[MJAlertContentTestController alloc] init];
            MJAlertController *alertController = [MJAlertController alertControllerWithViewController:testController
                                                                              preferredStyle:MJAlertControllerStyleAlert];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action Sheet Title"
                                                                                     message:@"Action sheet message can be a long text or a short text. However we cannot include custom content."
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"View"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Purchase"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Delete"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if (indexPath.row == 1)
        {
            MJAlertController *alertController = [MJAlertController alertControllerWithTitle:@"Action Sheet Title"
                                                                                     message:@"Action sheet message can be a long text or a short text. Also, we can include custom content."
                                                                              preferredStyle:MJAlertControllerStyleActionSheet];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Purchase"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Delete"
                                                                style:MJAlertActionStyleDestructive
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            MJAlertController *alertController = [MJAlertController alertControllerWithAttributedTitle:[NSAttributedString attributedStringWithStrings:@[@"Action Sheet ", @"Title"]
                                                                                                                                                 fonts:@[[UIFont boldSystemFontOfSize:17]]
                                                                                                                                            textColors:@[[UIColor orangeColor], [UIColor greenColor]]]
                                                                                    attributtedMessage:[NSAttributedString attributedStringWithStrings:@[@"Alert message can be a ",
                                                                                                                                                         @"long text",
                                                                                                                                                         @" or ",
                                                                                                                                                         @"short text",
                                                                                                                                                         @". Also, we can use ",
                                                                                                                                                         @"attributed strings",
                                                                                                                                                         @"."]
                                                                                                                                                 fonts:@[[UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont boldSystemFontOfSize:17],
                                                                                                                                                         [UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont boldSystemFontOfSize:10],
                                                                                                                                                         [UIFont systemFontOfSize:13],
                                                                                                                                                         [UIFont fontWithName:@"HelveticaNeue-light" size:19],
                                                                                                                                                         [UIFont systemFontOfSize:13],]
                                                                                                                                            textColors:@[[UIColor grayColor],
                                                                                                                                                         [UIColor blackColor],
                                                                                                                                                         [UIColor grayColor],
                                                                                                                                                         [UIColor blackColor],
                                                                                                                                                         [UIColor grayColor],
                                                                                                                                                         [UIColor purpleColor],
                                                                                                                                                         [UIColor grayColor]]]
                                                                                        preferredStyle:MJAlertControllerStyleActionSheet];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[MJAlertAction actionWithAttributedTitle:[NSAttributedString attributedStringWithStrings:@[@"Pur",
                                                                                                                                  @"chase"]
                                                                                                                          fonts:@[[UIFont fontWithName:@"HelveticaNeue-light" size:21],
                                                                                                                                  [UIFont systemFontOfSize:15],]
                                                                                                                     textColors:@[[UIColor purpleColor],
                                                                                                                                  [UIColor greenColor]]]
                                                                          style:MJAlertActionStyleDefault
                                                                        handler:^(MJAlertAction *action) {
                                                                            NSLog(@"Alert button tapped");
                                                                        }]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Delete"
                                                                style:MJAlertActionStyleDestructive
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            MJAlertContentTestController *testController = [[MJAlertContentTestController alloc] init];
            MJAlertController *alertController = [MJAlertController alertControllerWithViewController:testController
                                                                                       preferredStyle:MJAlertControllerStyleActionSheet];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Dismiss"
                                                                style:MJAlertActionStyleCancel
                                                              handler:nil]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"View"
                                                                style:MJAlertActionStyleDefault
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [alertController addAction:[MJAlertAction actionWithTitle:@"Delete"
                                                                style:MJAlertActionStyleDestructive
                                                              handler:^(MJAlertAction *action) {
                                                                  NSLog(@"Alert button tapped");
                                                              }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
