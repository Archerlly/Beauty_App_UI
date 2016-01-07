//
//  animationModal.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "animationModal.h"

@implementation animationModal

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView insertSubview:toView atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:nil]  animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(fromView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        BOOL success = ![transitionContext transitionWasCancelled];
        [transitionContext completeTransition:success];
    }];
}

@end
