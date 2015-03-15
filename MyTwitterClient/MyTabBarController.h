//
//  MyTabBarController.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineTableViewController.h"
#import "MyTabBarController.h"

@interface MyTabBarController : UITabBarController <UITabBarControllerDelegate>

@end

@protocol MyTabBarControllerDelegate

- (void) didSelect:(MyTabBarController*) tabBarController;

@end