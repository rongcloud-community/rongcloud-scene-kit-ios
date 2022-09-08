//
//  RCSPageFloaterManager.m
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/7/27.
//

#import "RCSPageFloaterManager.h"
#import "RCSPageFloaterView.h"

@interface RCSPageFloaterManager () <RCSPageFloaterViewDelegate>

@property (nonatomic, strong) RCSPageFloaterView *floater;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation RCSPageFloaterManager
+ (instancetype)shared {
    static id _floaterManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _floaterManager = [RCSPageFloaterManager new];
    });

    return _floaterManager;
}

#pragma mark - public method
- (void)showWithController:(UIViewController *)controller
              avatarImgUrl:(nullable NSString *)imgUrl
         customContentView:(nullable UIView *)contentView
                  animated:(BOOL)animated {
    self.multiDelegates = nil;
    self.controller = nil;

    self.controller = controller;

    CGFloat width = contentView ? contentView.width * 0.3 : 66;
    CGFloat height = contentView ? contentView.height * 0.3 : 66;
    self.floater.customContentView = contentView;
    self.floater.frame = CGRectMake(kScreen_WIDTH - 17 - width, kScreen_HEIGHT - 128 - height, width, height);

    if (animated) {
        [self miniScaleAnimation:controller];
    }

    [UIApplication.sharedApplication.keyWindow addSubview:self.floater];

    [self updateAvatarImgUrl:imgUrl];
}

- (void)showWithController:(UIViewController *)controller
              avatarImgUrl:(nullable NSString *)imgUrl
                  animated:(BOOL)animated {
    [self showWithController:controller avatarImgUrl:imgUrl customContentView:nil animated:animated];
}

- (void)updateAvatarImgUrl:(NSString *)imgUrl {
    [self.floater updateAvatarWithImgUrl:imgUrl];
}

- (void)hide {
    [self.floater removeFromSuperview];
    [self.controller removeFromParentViewController];
    self.multiDelegates = nil;
    self.controller = nil;
}

- (void)setSpeakingState:(BOOL)isSpeaking {
    if (!isSpeaking) {
        [self.floater.radarLayer stop];
        return;
    }

    [self.floater.radarLayer start];
}

- (BOOL)showing {
    return (self.floater.superview != nil);
}

- (void)floaterViewDidClick {
    [self didClickInFloater:self.floater];
}

#pragma mark - private method
- (void)miniScaleAnimation:(UIViewController *)controller {
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:controller.view.size];
    UIImage *image = [render imageWithActions:^(UIGraphicsImageRendererContext *_Nonnull rendererContext) {
        [controller.view.layer renderInContext:rendererContext.CGContext];
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [[UIApplication sharedApplication].delegate.window addSubview:imageView];

    CGPoint center = self.floater.center;
    CGFloat radius = self.floater.width * 0.5;
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:kScreen_HEIGHT
                                                        startAngle:0
                                                          endAngle:M_PI * 2
                                                         clockwise:NO];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:center
                                                          radius:radius
                                                      startAngle:0
                                                        endAngle:M_PI * 2
                                                       clockwise:NO];

    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = (__bridge CGPathRef _Nullable)((__bridge id)(fromPath.CGPath));
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    imageView.layer.mask = shapeLayer;

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)(fromPath.CGPath);
    pathAnimation.toValue = (__bridge id)(toPath.CGPath);
    pathAnimation.duration = 0.37;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;

    [shapeLayer addAnimation:pathAnimation forKey:@"path_circle"];

    [UIView animateWithDuration:0.1
        delay:0.37
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            imageView.alpha = 0;
        }
        completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [shapeLayer removeAllAnimations];
        }];
}


#pragma mark - RCSPageFloaterViewDelegate
/// 点击浮窗
- (void)didClickInFloater:(RCSPageFloaterView *)floater {
    [self.floater removeFromSuperview];
    UIViewController *topVC = [self topmostViewController];
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topVC pushViewController:self.controller animated:YES];
    } else if (topVC.navigationController) {
        [topVC.navigationController pushViewController:self.controller animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:topVC];
        [nav presentViewController:self.controller animated:YES completion:nil];
    }
}

// 当前最上层的ViewController
- (UIViewController *)topmostViewController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *blockViewController = window.rootViewController;

    while (blockViewController.presentedViewController) {
        blockViewController = blockViewController.presentedViewController;
    }

    do {
        if ([blockViewController respondsToSelector:@selector(selectedViewController)]) {
            blockViewController = [blockViewController performSelector:@selector(selectedViewController)];
        }

        if ([blockViewController respondsToSelector:@selector(topViewController)]) {
            blockViewController = [blockViewController performSelector:@selector(topViewController)];
        }

        if (blockViewController.childViewControllers.count) {
            blockViewController = blockViewController.childViewControllers.lastObject;
        }
    } while ([blockViewController respondsToSelector:@selector(selectedViewController)] ||
             [blockViewController respondsToSelector:@selector(topViewController)] ||
             blockViewController.childViewControllers.count);

    return blockViewController;
}

#pragma mark - lazy load
- (RCSPageFloaterView *)floater {
    if (!_floater) {
        _floater = [RCSPageFloaterView new];
        _floater.delegate = self;
    }
    return _floater;
}

@end
