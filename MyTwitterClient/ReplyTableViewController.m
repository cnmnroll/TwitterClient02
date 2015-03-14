//
//  ReplyTableViewController.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "ReplyTableViewController.h"

@interface ReplyTableViewController ()
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;

@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation ReplyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainQueue = dispatch_get_main_queue();
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.dataManager = appDelegate.dataManager;
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];

    [self getRequest];
    
}

//開くたびに実行される
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //NSLog(@"bbbbbbbbbbbbbbbbbbbbbbbbbbbb");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
    if([self.dataManager.accountChange[1]  isEqual: @1]){
        NSLog(@"AccountChange");
        [self getRequest];
        self.dataManager.accountChange[1] = @0;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------ Twitter 設定 ------------------------------------------------------------------------------*/
-(void)setAccount
{
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    self.dataManager.twitterAccounts= [self.accountStore accountsWithAccountType:twitterType];
                                                    
                                                    if (self.dataManager.twitterAccounts.count > 0) {
                                                        ACAccount *account = self.dataManager.twitterAccounts[0];
                                                        self.dataManager.identifier = account.identifier;
                                                        NSLog(@"成功");
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.dataManager.accountDisplayLabel.text = account.username;
                                                            
                                                        });
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            self.dataManager.accountDisplayLabel.text = @"アカウントなし";
                                                        });
                                                    }
                                                } else {
                                                    NSLog(@"Account Error: %@", [error localizedDescription]);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        self.dataManager.accountDisplayLabel.text = @"アカウント認証エラー";
                                                    });
                                                }
                                                
                                                dispatch_async(self.mainQueue, ^{
                                                    [self getRequest];
                                                    
                                                });
                                            }];
    
}

- (void)getRequest
{
    //NSLog(@"%@", self.identifier);
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.dataManager.identifier];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/mentions_timeline.json"];
    NSDictionary *params = @{@"count" : @"10",
                             @"trim_user" : @"0",
                             @"include_entities" : @"0"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    
    [request setAccount:account];
    
    //タイムライン習得
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES; // インジケータON
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) { // ここからは別スレッド（キュー）
        if (responseData) {
            self.dataManager.httpErrorMessage = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300){
                NSError *jsonError;
                self.dataManager.mentions =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (self.dataManager.mentions) {
                    NSLog(@"mentions Response: %@\n", self.dataManager.mentions);
                    dispatch_async(self.mainQueue, ^{ // UI処理はメインキューで
                        [self.tableView reloadData]; // テーブルビュー書き換え
                    });
                } else { // JSONシリアライズエラー発生時
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
            } else { // HTTPエラー発生時
                self.dataManager.httpErrorMessage =
                [NSString stringWithFormat:@"The response status code is %ld",
                 (long)urlResponse.statusCode];
                NSLog(@"HTTP Error: %@", self.dataManager.httpErrorMessage);
            }
        }
        dispatch_async(self.mainQueue, ^{
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO; // インジケータOFF
        });
    }];
}


/*------------------------------------------------------------------------------ Twitter 設定ここまで ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------ TimeLine 設定ここから ------------------------------------------------------------------------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (self.dataManager.httpErrorMessage) {
        cell.tweetTextLabel.text = self.dataManager.httpErrorMessage;
        cell.tweetTextLabelHeight = 24;
    } else if (!self.dataManager.mentions) {
        cell.tweetTextLabel.text = @"Loading...";
        cell.tweetTextLabelHeight = 24;
    } else {
        NSString *name =  self.dataManager.mentions[indexPath.row][@"user"][@"name"];
        NSString *text = self.dataManager.mentions[indexPath.row][@"text"];
        cell.tweetTextLabelHeight = [GetLabelHeight labelHeight:text];
        cell.tweetTextLabel.text = text;
        cell.nameLabel.text = name;
        
        cell.profileImageView.image = [UIImage imageNamed:@"blank.png"];
        
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = YES;
        
        dispatch_async(self.imageQueue, ^{
            NSString *url;
            NSDictionary *tweetDictionary = self.dataManager.mentions[indexPath.row];
            
            if ([[tweetDictionary allKeys] containsObject:@"retweeted_status"]) {
                // リツイートの場合はretweeted_statusキー項目が存在する
                url = tweetDictionary[@"retweeted_status"][@"user"][@"profile_image_url"];
            } else {
                url = tweetDictionary[@"user"][@"profile_image_url"];
            }
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(self.mainQueue, ^{
                UIApplication *application = [UIApplication sharedApplication];
                application.networkActivityIndicatorVisible = NO;
                UIImage *image = [[UIImage alloc] initWithData:data];
                cell.profileImageView.image = image;
                [cell setNeedsLayout];
            });
        });
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tweetText = self.dataManager.mentions[indexPath.row][@"text"];
    CGFloat tweetTextLabelHeight = [GetLabelHeight labelHeight:tweetText];
    return tweetTextLabelHeight + 35;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(!self.dataManager.timeLineData){
        return 1;
    } else {
        return self.dataManager.timeLineData.count;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //self.dataManager.accountChange = @[@"1", @"1"];
    if (self.dataManager.twitterAccounts.count > 0) {
        if (buttonIndex != self.dataManager.twitterAccounts.count) {
            self.dataManager.accountChange = [@[@1, @0]mutableCopy];
            ACAccount *account = self.dataManager.twitterAccounts[buttonIndex];
            self.dataManager.identifier = account.identifier;
            self.dataManager.accountDisplayLabel.text = account.username;
            NSLog(@"Account set! %@", account.username);
            [self getRequest]; //アカウント更新
        }
        else {
            NSLog(@"cancel!");
        }
    }
}

@end
