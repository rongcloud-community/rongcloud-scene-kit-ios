//
//  RCSPageContainerController.h
//  Pods-RCScenePageContainerKit_Example
//
//  Created by 彭蕾 on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "RCSPageItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class RCSPageContainerController;
/// 操作回调
@protocol RCSPageContainerDelegate <NSObject>

/// 刷新
- (void)container:(RCSPageContainerController *)containerVC refresh:(void (^)(void))completion;

/// 加载更多
- (void)container:(RCSPageContainerController *)containerVC loadMore:(void (^)(void))completion;

/// 切换页面
- (void)container:(RCSPageContainerController *)containerVC switchPage:(NSInteger)index;

/// container view load 完成
- (void)containerViewDidLoad;

/// container 即将被销毁
- (void)containerWillDealloc;

/// coordinator notifyWhenInteractionChanges
- (void)container:(RCSPageContainerController *)containerVC
    coordinatorNofifyWhenInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext> _Nonnull)context;

@end

@interface RCSPageContainerController : UIViewController

@property (nonatomic, weak) id<RCSPageContainerDelegate> delegate;
@property (nonatomic, strong) NSArray<id<RCSPageItemProtocol>> *pageItems;
@property (nonatomic, copy, readonly) NSString *currentPageId;

/// 当前进入的房间VC
@property (nonatomic, strong, nullable) UIViewController *currentPageVC;

/// 当前滑动到的房间index
@property (nonatomic, assign) NSInteger currentIndex;

/// 滚动
- (void)setScrollable:(BOOL)scrollable;

/// 禁用滚动事件的视图
- (void)setDescendantViews:(NSArray<UIView *> *)descendantViews;

/// 暂无更多数据
- (void)setHadNomoreData:(BOOL)hadNomoreData;

/// 刷新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
