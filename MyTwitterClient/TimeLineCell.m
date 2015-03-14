//
//  TimeLineCell.m
//  TwitterClient
//
//  Created by Lotus on 2015/03/08.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "TimeLineCell.h"

@implementation TimeLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _paddingBottom = 5;
        _paddingTop = 5;
        //        SharedDataManager *sharedManager = [SharedDataManager sharedManager];
        
        _tweetTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tweetTextLabel.font = [UIFont systemFontOfSize:14.0f];
        _tweetTextLabel.textColor = [UIColor blackColor];
        _tweetTextLabel.numberOfLines = 0;
        [self.contentView addSubview:_tweetTextLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_profileImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.profileImageView.frame = CGRectMake(5, self.paddingTop, 48, 48);
    self.nameLabel.frame = CGRectMake(58, self.paddingTop, 257, 10);
    self.tweetTextLabel.frame = CGRectMake(58, self.paddingTop + 10, 257, self.tweetTextLabelHeight);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
