//
//  GetTimeLine.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//
//#import "TimeLineTableViewController.h"
#import <Foundation/Foundation.h>
#import "DataManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface GetTimeLine : NSObject {
    DataManager *_dataManeger;
}
@property (nonatomic, retain) DataManager *dataManager;

- (void)getTimeLine:(NSURL *)url;

@end
