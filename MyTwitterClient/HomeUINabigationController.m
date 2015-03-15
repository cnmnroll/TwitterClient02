//
//  HomeUINabigationController.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/12.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "HomeUINabigationController.h"

@interface HomeUINabigationController ()

@end

@implementation HomeUINabigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *accountImage = [UIImage imageNamed:@"account"];
    UIImage *tweetImage = [UIImage imageNamed:@"tweet"];
    
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithImage:[self iconResize:tweetImage]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(tweetAction:)];
    UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithImage:[self iconResize:accountImage]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(setAccountAction:)];
    
    self.navigationItem.leftBarButtonItem = accountButton;
    self.navigationItem.rightBarButtonItem = tweetButton;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //ナビゲーションバー設定
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:172/255.0 blue:237/255.0 alpha:0.5];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIImage *)iconResize:(UIImage *)image
{
    //    int imageW = image.size.width;
    //    int imageH = image.size.height;
    //
    //float scale = (imageW > imageH)
    
    CGSize resizedSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContext(resizedSize);
    [image drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
