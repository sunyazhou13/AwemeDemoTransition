//
//  DismissScaleAnimation.h
//  AwemeDemo
//
//  Created by sunyazhou on 2018/11/30.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DismissScaleAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect centerFrame;
/** 初始位置 不能为CGRectZero */
@property (nonatomic, assign) CGRect originCellFrame;
/** 结束位置 不能为CGRectZero */
@property (nonatomic, assign) CGRect finalCellFrame;
@property (nonatomic, weak)   UIView *selectCell;

@end

NS_ASSUME_NONNULL_END
