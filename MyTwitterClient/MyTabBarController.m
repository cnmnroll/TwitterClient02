//
//  MyTabBarController.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([viewController conformsToProtocol:@protocol(MyTabBarControllerDelegate)]) {
        //[(UIViewController<MyTabBarControllerDelegate>*)viewController didSelect:self];
        ReplyTableViewController *replyTableViewController = [[ReplyTableViewController alloc] init];
        //replyTableViewController.identifier =
        viewController.title = @"a";
        //UIViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"Tab"];
        UITableViewController *tabViewController = [];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
