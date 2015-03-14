//
//  SetAccount.h
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "DataManager.h"
#import "GetTimeLine.h"

@interface SetAccount : NSObject {
    DataManager *_dataManeger;
}
@property (nonatomic, retain) DataManager *dataManager;

-(void)setAccount;
@end
