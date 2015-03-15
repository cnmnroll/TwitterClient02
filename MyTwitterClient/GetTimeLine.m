//
//  GetTimeLine.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "GetTimeLine.h"
@interface GetTimeLine ()

@end

@implementation GetTimeLine
@synthesize dataManager = _dataManager;

- (void)getTimeLine:(NSURL *)url
{
    NSLog(@"%@", self.dataManager.identifier);
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:_dataManager.identifier];
    

    NSDictionary *params = @{@"count" : @"1",
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
            _dataManager.httpErrorMessage = nil;
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300){
                NSError *jsonError;
                 _dataManager.timeLineData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (_dataManager.timeLineData) {
                    NSLog(@"Timeline Response: %@\n", _dataManager.timeLineData);
                    dispatch_async(dispatch_get_main_queue(), ^{ // UI処理はメインキューで
                         NSLog(@"Timeline習得成功\n");
//                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        TimeLineTableViewController *timeLineView = [storyBoard instantiateViewControllerWithIdentifier:@"TimeLineTableView"];
//                        
//                        [timeLineView.tableView reloadData]; // テーブルビュー書き換え
                        
                        [self.dataManager.timeLineTableView.tableView reloadData];
                        
                    });
                } else { // JSONシリアライズエラー発生時
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
            } else { // HTTPエラー発生時
                _dataManager.httpErrorMessage =
                [NSString stringWithFormat:@"The response status code is %ld",
                 (long)urlResponse.statusCode];
                NSLog(@"HTTP Error: %@",  _dataManager.httpErrorMessage);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = NO; // インジケータOFF
        });
    }];
    
}



@end
