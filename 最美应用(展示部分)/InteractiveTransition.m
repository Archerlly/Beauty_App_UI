//
//  InteractiveTransition.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/15.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "InteractiveTransition.h"

@interface InteractiveTransition ()
@property (assign ,nonatomic) CGFloat percent;
@end

@implementation InteractiveTransition

-(void)setPresentingVc:(UIViewController *)presentingVc{
    _presentingVc = presentingVc;
    
    self.completionCurve = UIViewAnimationCurveLinear;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [presentingVc.view addGestureRecognizer:pan];
}



-(void)pan:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _activiting = YES;
        [_presentingVc dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [sender translationInView:nil];
        _percent = point.x / _presentingVc.view.bounds.size.width;
        _percent = fmaxf(fmin(_percent, 1), 0);
        NSLog(@"%.2f",_percent);
        [self updateInteractiveTransition:_percent];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_percent > 0.3) {
            [self finishInteractiveTransition];
        }else{
            [self cancelInteractiveTransition];
        }
        _activiting = NO;
    }
    
}


@end
