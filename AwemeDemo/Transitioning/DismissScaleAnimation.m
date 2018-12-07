//
//  DismissScaleAnimation.m
//  AwemeDemo
//
//  Created by sunyazhou on 2018/11/30.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "DismissScaleAnimation.h"

//size
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DismissScaleAnimation ()

@end

@implementation DismissScaleAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        _centerFrame = CGRectMake((ScreenWidth - 5)/2, (ScreenHeight - 5)/2, 5, 5);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UINavigationController *toNavigation = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *toVC = [toNavigation viewControllers].firstObject;
    
    
    UIView *snapshotView;
    CGFloat scaleRatio;
    CGRect finalFrame = self.finalCellFrame;
    if(self.selectCell && !CGRectEqualToRect(finalFrame, CGRectZero)) {
        snapshotView = [self.selectCell snapshotViewAfterScreenUpdates:NO];
        scaleRatio = fromVC.view.frame.size.width/self.selectCell.frame.size.width;
        snapshotView.layer.zPosition = 20;
    }else {
        snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        scaleRatio = fromVC.view.frame.size.width/ScreenWidth;
        finalFrame = _centerFrame;
    }
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:snapshotView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    fromVC.view.alpha = 0.0f;
    snapshotView.center = fromVC.view.center;
    snapshotView.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         snapshotView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         snapshotView.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         [transitionContext finishInteractiveTransition];
                         [transitionContext completeTransition:YES];
                         [snapshotView removeFromSuperview];
                     }];
}



@end
