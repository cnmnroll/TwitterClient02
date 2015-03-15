//
//  SuperTableViewController.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "SuperTableViewController.h"
//セル取得数
#define ONCEREAD 40

@interface SuperTableViewController ()

@property NSInteger update;
@property NSInteger viewingPage;
@property (strong, nonatomic) UIActivityIndicatorView *underIndicator;
@end

@implementation SuperTableViewController
//@synthesize dataManager = _dataManager;
- (void)viewDidLoad {
    _update = 1;
    NSLog(@"%d", self.update);
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.dataManager = appDelegate.dataManager;
    [appDelegate.dataManager addObserver:self forKeyPath:@"identifier" options:0 context:NULL];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    _viewingPage = 200;//
    _underIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.underIndicator setColor:[UIColor darkGrayColor]];
    [self.underIndicator setHidesWhenStopped:YES];
    [self.underIndicator stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //ナビゲーションバー設定
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:172/255.0 blue:237/255.0 alpha:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIImage *accountImage = [UIImage imageNamed:@"account"];
    UIImage *tweetImage = [UIImage imageNamed:@"tweet"];
    
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithImage:[IconResize iconResize:tweetImage]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(tweetAction:)];
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithImage:[IconResize iconResize:accountImage]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(setAccountAction:)];
    UITabBarController *home = self.tabBarController.tabBar.items[0];
    home.title = @"Home";
    UITabBarController *mentions = self.tabBarController.tabBar.items[1];
    mentions.title = @"Mentions";
    UITabBarController *favorites = self.tabBarController.tabBar.items[2];
    favorites.title = @"Favorites";
    
    self.navigationItem.leftBarButtonItem = accountButton;
    self.navigationItem.rightBarButtonItem = tweetButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*------------------------------------------------------------------------------ Cell設定 ここから  ------------------------------------------------------------------------------*/
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
        return _update * ONCEREAD;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//セルクリックした時
    //行とセクション取り出す
    TimeLineCell *cell = (TimeLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"]; //StoryBoard ID
    detailViewController.name = cell.nameLabel.text;
    detailViewController.text = cell.tweetTextLabel.text;
    detailViewController.image = cell.profileImageView.image;
    detailViewController.identifier = self.dataManager.identifier;
    detailViewController.idStr = self.dataManager.timeLineData[indexPath.row][@"id_str"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

/*------------------------------------------------------------------------------ Cell設定 ここまで  ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------ ButtonAction設定 ここから  ------------------------------------------------------------------------------*/

- (IBAction)setAccountAction:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    
    sheet.title = @"選択してください。";
    for (ACAccount *account in self.dataManager.twitterAccounts) {
        [sheet addButtonWithTitle:account.username];
    }
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = self.dataManager.twitterAccounts.count;
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
    
}

- (IBAction)tweetAction:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) { //利用可能チェック
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                //投稿成功時の処理
                NSLog(@"Tweet Success!");
            }
        }];
        [self presentViewController:composeCtl animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (self.dataManager.twitterAccounts.count > 0) {
        if (buttonIndex != self.dataManager.twitterAccounts.count) {
            ACAccount *account = self.dataManager.twitterAccounts[buttonIndex];
            self.dataManager.identifier = account.identifier;
            self.dataManager.accountDisplayLabel.text = account.username;
            NSLog(@"Account set! %@", account.username);
        }
        else {
            NSLog(@"cancel!");
        }
    }
}
/*------------------------------------------------------------------------------ ButtonAction設定 ここまで ------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------ Footer更新 ここから ------------------------------------------------------------------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"viewPage = %d _updaa*oneceread = %d", self.viewingPage , _update*ONCEREAD);
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        
        if([_underIndicator isAnimating]) {
            return;
        }
        
        
        if (self.viewingPage > (_update*ONCEREAD)) {
            [self startIndicator];
            [self performSelector:@selector(reloadMoreData) withObject:nil afterDelay:0.1f];
        }
        
    }
}

- (void)reloadMoreData
{
    _update++;
    [self.tableView reloadData];
    [self endIndicator];
}
- (void)startIndicator
{
    [_underIndicator startAnimating];
    CGRect footerFrame = self.tableView.tableFooterView.frame;
    footerFrame.size.height += 10.0f;
    
    [_underIndicator setFrame:footerFrame];
    [self.tableView setTableFooterView:_underIndicator];
}


- (void)endIndicator
{
    [_underIndicator stopAnimating];
    [_underIndicator removeFromSuperview];
    [self.tableView setTableFooterView:nil];
    
}

/*------------------------------------------------------------------------------ Footer更新 ここまで ------------------------------------------------------------------------------*/
@end
