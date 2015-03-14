//
//  AppDelegate.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/11.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DataManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    DataManager *_dataManeger;
}
@property (nonatomic, retain) DataManager *dataManager;


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)UINavigationController *navigationController;
@property (nonatomic, copy) NSString *identifier;


@end

