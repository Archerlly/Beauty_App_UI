//
//  labCell.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/13.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "labCell.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

@implementation labCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"button_white_normal"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height *0.5, image.size.width *0.5, image.size.height *0.5, image.size.width *0.5) ];
        imgView.image = image;
        imgView.frame = CGRectMake(0, kHeight * 0.5 - 10, kWidth, kHeight);
        [self addSubview:imgView];
        _imgView = imgView;
    }
    return self;
}

@end
