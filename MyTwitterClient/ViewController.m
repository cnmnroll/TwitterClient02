//
//  ViewController.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/11.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tweetActionButton;
@property (weak, nonatomic) IBOutlet UILabel *accountDisplayLabel;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSArray *twitterAccounts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    if (self.twitterAccounts.count > 0) {
                                                        ACAccount *account = self.twitterAccounts[0];
                                                        self.identifier = account.identifier;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.accountDisplayLabel.text = account.username;
                                                        });
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.accountDisplayLabel.text = @"アカウントなし";
                                                        });
                                                    }
                                                } else {
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.accountDisplayLabel.text = @"アカウント認証エラー";
                                                    });
                                                }
                                            }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeLineSegue"]) {
        TimeLineTableViewController *timeLineTableViewController = segue.destinationViewController;
        if ([timeLineTableViewController isKindOfClass:[TimeLineTableViewController class]]){
            timeLineTableViewController.identifier = self.identifier;
        }
    }
    //    if ([segue.identifier isEqualToString:@"testSegue"]) {
    //        TestTableViewController *testTableViewController = segue.destinationViewController;
    //        if ([testTableViewController isKindOfClass:[TestTableViewController class]]){
    //            testTableViewController.identifier = self.identifier;
    //        }
    //    }
}


@end
