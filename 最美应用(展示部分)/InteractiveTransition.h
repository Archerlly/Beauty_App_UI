//
//  InteractiveTransition.h
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/15.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic ,weak) UIViewController *presentingVc;
@property (nonatomic, assign) BOOL activiting;

@end
