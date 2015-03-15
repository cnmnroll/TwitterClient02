//
//  SetAccount.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "SetAccount.h"

@interface SetAccount ()
@property (nonatomic, strong) ACAccountStore *accountStore;


@end

@implementation SetAccount
@synthesize dataManager = _dataManager;


-(void)setAccount
{
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Account 接続成功");
                                                    self.dataManager.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    NSLog(@"%@",self.dataManager.twitterAccounts);
                                                    if (self.dataManager.twitterAccounts.count > 0) {
                                                        ACAccount *account = self.dataManager.twitterAccounts[0];
                                                        self.dataManager.identifier = account.identifier;
                                                        NSLog(@"%@",self.dataManager.identifier);
                                                        NSLog(@"成功");
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.dataManager.accountDisplayLabel.text = account.username;
                                                            
                                                        });
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            _dataManager.accountDisplayLabel.text = @"アカウントなし";
                                                        });
                                                    }
                                                } else {
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        _dataManager.accountDisplayLabel.text = @"アカウント認証エラー";
                                                    });
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                                                    GetTimeLine *getTimeLine = [[GetTimeLine alloc] init];
                                                    getTimeLine.dataManager = self.dataManager;
                                                    [getTimeLine getTimeLine:url];
                                                }); 
                                            }];
    
}


@end
