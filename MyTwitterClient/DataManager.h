//
//  DataManager.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataManager : NSObject {
    NSString *_identifier;
    UILabel *_accountDisplayLabel;
    NSString *_httpErrorMessage;
    NSArray *_timeLineData;
    NSArray *_twitterAccounts;
    NSArray *_mentions;
    NSMutableArray *_accountChange;
}

@property NSString *identifier;
@property UILabel *accountDisplayLabel;
@property NSString *httpErrorMessage;
@property NSArray *timeLineData;

@property (nonatomic, copy) NSArray *twitterAccounts;
@property NSArray *mentions;

@property NSMutableArray *accountChange;
- (id)initWithNone;
@end
