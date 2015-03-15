//
//  TimeLineCell.h
//  TwitterClient
//
//  Created by Lotus on 2015/03/08.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell
@property UILabel *tweetTextLabel;
@property UILabel *nameLabel;
@property UIImageView *profileImageView;
@property UIImage *image;
@property int tweetTextLabelHeight;
@property int paddingTop;
@property int paddingBottom;
@end



