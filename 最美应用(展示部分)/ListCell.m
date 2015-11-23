//
//  ListCell.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "ListCell.h"
#import "dataModel.h"

@interface ListCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UILabel *detailIntro;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end

@implementation ListCell

-(void)setMod:(dataModel *)mod{
    _mod = mod;
    _name.text = mod.name;
    _intro.text = mod.intro;
    _img.image = [UIImage imageNamed:mod.imgName];
    _detailIntro.text = mod.detailIntro;
    _author.text = mod.author;
}


@end
