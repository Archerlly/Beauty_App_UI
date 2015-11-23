//
//  sideBar.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/14.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "sideBar.h"

@interface sideBar ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation sideBar

-(void)awakeFromNib{
    _icon.layer.cornerRadius = _icon.bounds.size.width * 0.5;
    _icon.clipsToBounds = YES;
}

@end
