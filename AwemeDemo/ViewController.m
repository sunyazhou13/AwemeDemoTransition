//
//  ViewController.m
//  AwemeDemo
//
//  Created by sunyazhou on 2018/10/18.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "ViewController.h"
#import "AwemeListViewController.h"
#import <Masonry/Masonry.h>

#import "PresentScaleAnimation.h"
#import "DismissScaleAnimation.h"
#import "DragLeftInteractiveTransition.h"


#define ColorClear [UIColor clearColor]

@interface ViewController () <UICollectionViewDataSource , UICollectionViewDelegate,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) PresentScaleAnimation *presentScaleAnimation;
@property (nonatomic, strong) DismissScaleAnimation *dismissScaleAnimation;
@property (nonatomic, strong) DragLeftInteractiveTransition *leftDragInteractiveTransition;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNavigationBarTitleColor:ColorClear];
    [self setNavigationBarBackgroundColor:ColorClear];
    [self setStatusBarBackgroundColor:ColorClear];
    [self setNavigationBarBackgroundImage:[UIImage new]];
    [self setNavigationBarShadowImage:[UIImage new]];

    [self setStatusBarHidden:NO];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentify"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    //转场的两个动画
    self.presentScaleAnimation = [[PresentScaleAnimation alloc] init];
    self.dismissScaleAnimation = [[DismissScaleAnimation alloc] init];
    self.leftDragInteractiveTransition = [DragLeftInteractiveTransition new];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setNavigationBarTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundColor:color];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

//导航栏暗影透明
- (void)setNavigationBarShadowImage:(UIImage *)image {
    [self.navigationController.navigationBar setShadowImage:image];
}


//导航栏透明
- (void)setNavigationBarBackgroundImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


- (void) setStatusBarHidden:(BOOL) hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}


#pragma mark -
#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentify" forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeListViewController *awemeVC = [[AwemeListViewController alloc] init];
    awemeVC.transitioningDelegate = self; //0
    
    // 1
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    // 2
    CGRect cellFrame = cell.frame;
    // 3
    CGRect cellConvertedFrame = [collectionView convertRect:cellFrame toView:collectionView.superview];
    
    //弹窗转场
    self.presentScaleAnimation.cellConvertFrame = cellConvertedFrame; //4
    
    //消失转场
    self.dismissScaleAnimation.selectCell = cell; // 5
    self.dismissScaleAnimation.originCellFrame  = cellFrame; //6
    self.dismissScaleAnimation.finalCellFrame = cellConvertedFrame; //7
    
    awemeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext; //8
    self.modalPresentationStyle = UIModalPresentationCurrentContext; //9
    
    [self.leftDragInteractiveTransition wireToViewController:awemeVC];
    [self presentViewController:awemeVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UIViewControllerAnimatedTransitioning Delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self.presentScaleAnimation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissScaleAnimation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.leftDragInteractiveTransition.isInteracting? self.leftDragInteractiveTransition: nil;
}


- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


@end
