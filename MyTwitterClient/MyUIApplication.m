//
//  MyUIApplication.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/11.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "MyUIApplication.h"

@implementation MyUIApplication

- (BOOL)openURL:(NSURL *)url
{
    if(!url){
        return NO;
    }
    
    self.myOpenURL = url;
    AppDelegate *appDelegate = (AppDelegate *)[self delegate];
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WebViewController *webViewController = [storybord instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.openURL = self.myOpenURL;
    webViewController.title = @"Web View";
    [appDelegate.navigationController pushViewController:webViewController animated:YES];
    self.myOpenURL = nil;
    return YES;
}

@end
