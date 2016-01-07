//
//  ListCell.h
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import <UIKit/UIKit.h>
@class dataModel;
@interface ListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, strong) dataModel *mod;

@end
