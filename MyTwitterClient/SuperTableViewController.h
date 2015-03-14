//
//  SuperTableViewController.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//
@class DataManager;
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "IconResize.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "GetLabelHeight.h";
#import "TimeLineCell.h"
#import "DetailViewController.h"

@interface SuperTableViewController : UITableViewController {
    DataManager *_dataManeger;
    
}

@property (nonatomic, retain) DataManager *dataManager;
@property UIBarButtonItem *tweetActionButton;
@property (nonatomic, strong) ACAccountStore *accountStore;
- (void)actionSheet;
@end
