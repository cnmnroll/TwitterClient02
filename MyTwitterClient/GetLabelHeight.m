//
//  GetLabelHeight.m
//  MyTwitterClient
//
//  Created by Lotus on 2015/03/13.
//  Copyright (c) 2015年 ne260037.com. All rights reserved.
//

#import "GetLabelHeight.h"

@interface GetLabelHeight ()

@end

@implementation GetLabelHeight
+ (CGFloat)labelHeight:(NSString *)labelText
{
    //ラベルの行間設定
    UILabel *aLabel = [[UILabel alloc] init];
    CGFloat lineHeight = 18.0;
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = lineHeight;
    paragrahStyle.maximumLineHeight = lineHeight;
    
    //テキスト属性を付与
    NSString *text = (labelText == nil) ? @"" : labelText;
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    NSDictionary *attrbutes = @{NSParagraphStyleAttributeName:paragrahStyle,
                                NSFontAttributeName:font};
    NSAttributedString *aText = [[NSAttributedString alloc] initWithString:text attributes:attrbutes];
    aLabel.attributedText = aText;
    
    //ラベルの高さ計算
    CGFloat aHeight = [aLabel.attributedText boundingRectWithSize:CGSizeMake(257, MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size.height;
    return aHeight;
}
@end
