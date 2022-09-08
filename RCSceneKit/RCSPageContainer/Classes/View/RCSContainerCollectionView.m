//
//  RCSContainerCollectionView.m
//  RCScenePageContainerKit
//
//  Created by 彭蕾 on 2022/7/22.
//

#import "RCSContainerCollectionView.h"

@interface UIView (RCSContainer)
- (BOOL)rcsc_containView:(UIView *)view;
@end

@implementation UIView (RCSContainer)

- (BOOL)rcsc_containView:(UIView *)view {
    if ([self isEqual:view]) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView rcsc_containView:view]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation RCSContainerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return self;
}

- (void)setDescendantViews:(NSArray<UIView *> *)descendantViews {
    _descendantViews = descendantViews;
    NSPredicate *scrollClsPredicate =
        [NSPredicate predicateWithBlock:^BOOL(UIView *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:[UIScrollView class]];
        }];
    NSArray<UIScrollView *> *filterArr =
        (NSArray<UIScrollView *> *)[descendantViews filteredArrayUsingPredicate:scrollClsPredicate];
    for (UIScrollView *scrollView in filterArr) {
        scrollView.exclusiveTouch = YES;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    BOOL pointInDescendantView = NO;
    for (UIView *view in self.descendantViews) {
        pointInDescendantView = ![hitView rcsc_containView:view];
        if (pointInDescendantView) {
            break;
        }
        CGRect viewFrame = [view convertRect:view.frame fromView:view.superview];
        viewFrame.size.width = viewFrame.size.width / 375 * 300;
        pointInDescendantView = CGRectContainsPoint(viewFrame, point);
        if (pointInDescendantView) {
            break;
        }
    }
    self.scrollEnabled = self.scrollable && !pointInDescendantView;
    return hitView;
}

@end
