//
//  RCSPageContainerController.m
//  Pods-RCScenePageContainerKit_Example
//
//  Created by 彭蕾 on 2022/7/22.
//

#import "RCSPageContainerController.h"
#import "RCSContainerCollectionView.h"
#import "RCSContainerCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface RCSPageContainerController () <UINavigationControllerDelegate,
                                          UICollectionViewDelegate,
                                          UICollectionViewDataSource>

@property (nonatomic, strong) RCSContainerCollectionView *collectionView;
@property (nonatomic, copy) NSString *currentPageId;

@end

@implementation RCSPageContainerController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(refreshData)];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    [self addChildViewController:self.currentPageVC];
    [self.currentPageVC didMoveToParentViewController:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        RCSContainerCollectionViewCell *cell =
            (RCSContainerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setUpContentView:self.currentPageVC.view];
    });

    self.navigationController.delegate = self;


    if ([self.delegate respondsToSelector:@selector(containerViewDidLoad)]) {
        [self.delegate containerViewDidLoad];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    if ([self.delegate respondsToSelector:@selector(containerWillDealloc)]) {
        [self.delegate containerWillDealloc];
    }
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.collectionView.mj_header.mj_h = self.view.safeAreaInsets.top;
}

#pragma mark - public method
- (void)setCurrentIndex:(NSInteger)currentIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];

    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
    NSString *newPageId = self.pageItems[currentIndex].pageId;
    [self setScrollable:self.pageItems[currentIndex].switchable];
    _currentIndex = currentIndex;
    if (![self.currentPageId isEqualToString:newPageId] && self.currentPageId) {
        [self switchPage];
    }
    self.currentPageId = newPageId.copy;
}

- (void)setCurrentPageVC:(UIViewController *)currentPageVC {
    if (_currentPageVC == currentPageVC || currentPageVC == nil) {
        return;
    }
    [_currentPageVC.view removeFromSuperview];
    [_currentPageVC removeFromParentViewController];

    [self addChildViewController:currentPageVC];
    [currentPageVC didMoveToParentViewController:self];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    RCSContainerCollectionViewCell *cell =
        (RCSContainerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setUpContentView:currentPageVC.view];

    _currentPageVC = currentPageVC;
}

- (void)setDescendantViews:(NSArray<UIView *> *)descendantViews {
    self.collectionView.descendantViews = descendantViews;
}

- (void)setScrollable:(BOOL)scrollable {
    BOOL scroll = scrollable;
    if (scrollable) {
        if (self.currentIndex < self.pageItems.count) {
            scroll = self.pageItems[self.currentIndex].switchable;
        }
    }
    self.collectionView.scrollable = scroll;
}

- (void)setHadNomoreData:(BOOL)hadNomoreData {
    if (hadNomoreData) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (void)reloadData {
    if (self.pageItems.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showInfoWithStatus:@"获取房间信息为空"];
        return;
    }

    [self.collectionView reloadData];
}

#pragma mark - private method
- (void)loadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(container:loadMore:)]) {
        [self.delegate container:self
                        loadMore:^{
                            [self.collectionView.mj_footer endRefreshing];
                        }];
    }
}

- (void)refreshData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(container:refresh:)]) {
        [self.delegate container:self
                         refresh:^{
                             [self.collectionView.mj_header endRefreshing];
                         }];
    }
}

- (void)switchPage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(container:switchPage:)]) {
        [self.delegate container:self switchPage:self.currentIndex];
    }
}

#pragma mark - collection delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= self.pageItems.count * kScreen_WIDTH) {
        _collectionView.pagingEnabled = NO;
    } else {
        _collectionView.pagingEnabled = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didEndDisplayingCell:(UICollectionViewCell *)cell
      forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *currentIndexPath = [collectionView indexPathsForVisibleItems].firstObject;
    if (!currentIndexPath) {
        return;
    }
    self.currentIndex = currentIndexPath.row;
    [(RCSContainerCollectionViewCell *)cell stopGifAnimation];
}

#pragma mark - collection dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSContainerCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RCSContainerCollectionViewCell.class)
                                                  forIndexPath:indexPath];
    id<RCSPageItemProtocol> item = self.pageItems[indexPath.row];
    [cell updateUIWithPageId:item.pageId backgroundUrl:item.backgroudUrl];
    return cell;
}

#pragma mark - lazy load
- (RCSContainerCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        _collectionView = [[RCSContainerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[RCSContainerCollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass(RCSContainerCollectionViewCell.class)];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> coordinator =
        navigationController.topViewController.transitionCoordinator;
    if (coordinator == nil) {
        return;
    }

    [coordinator
        notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(container:coordinatorNofifyWhenInteractionChanges:)]) {
                [self.delegate container:self coordinatorNofifyWhenInteractionChanges:context];
            }
        }];
}


@end
