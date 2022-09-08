//
//  RCSViewController.m
//  RCSceneKit
//
//  Created by 彭蕾 on 07/27/2022.
//  Copyright (c) 2022 彭蕾. All rights reserved.
//

#import "RCSViewController.h"
#import <RCSceneKit/RCSPageContainerKit.h>
#import <RCSceneKit/RCSPageFloaterManager.h>
#import <YYModel/YYModel.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "RCSRoomViewController.h"
#import "RCSRoomCycleProtocol.h"

@interface RCSViewController () <RCSPageContainerDelegate>

@end

@implementation RCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToContainer:(id)sender {
    [[RCSPageFloaterManager shared] hide];

    RCSPageContainerController *pageContianer = [RCSPageContainerController new];
    pageContianer.pageItems = [NSArray yy_modelArrayWithClass:RCSPageModel.class json:[self testPageData]];
    pageContianer.delegate = self;
    pageContianer.currentIndex = 0;
    pageContianer.currentPageVC = [RCSRoomViewController new];
    [self.navigationController pushViewController:pageContianer animated:YES];
    if ([pageContianer.currentPageVC conformsToProtocol:@protocol(RCSRoomCycleProtocol)]) {
        id<RCSRoomCycleProtocol> pageVC = (id<RCSRoomCycleProtocol>)pageContianer.currentPageVC;
        [pageContianer setDescendantViews:[pageVC descendantViews]];
    }
}

- (IBAction)hideFloater:(id)sender {
    [[RCSPageFloaterManager shared] hide];
}

#pragma mark - container delegate
- (void)container:(nonnull RCSPageContainerController *)containerVC
    coordinatorNofifyWhenInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext> _Nonnull)context {
    if (!context.isCancelled) {
        // 展示浮窗
    }
}

- (void)container:(nonnull RCSPageContainerController *)containerVC loadMore:(nonnull void (^)(void))completion {
    dispatch_time_t loadingTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(loadingTime, dispatch_get_main_queue(), ^{
        completion();
    });
}

- (void)container:(nonnull RCSPageContainerController *)containerVC refresh:(nonnull void (^)(void))completion {
    dispatch_time_t loadingTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(loadingTime, dispatch_get_main_queue(), ^{
        completion();
    });
}

- (void)container:(nonnull RCSPageContainerController *)containerVC switchPage:(NSInteger)index {
    /// 离开当前房间，进入下一个房间
    if (![containerVC.currentPageVC conformsToProtocol:@protocol(RCSRoomCycleProtocol)]) {
        return;
    }
    id<RCSRoomCycleProtocol> pageVC = (id<RCSRoomCycleProtocol>)containerVC.currentPageVC;
    [pageVC leaveRoom:^{
        RCSRoomViewController *roomVC = [RCSRoomViewController new];
        containerVC.currentPageVC = roomVC;
        [containerVC setDescendantViews:[roomVC descendantViews]];
    }];
}

- (void)containerViewDidLoad {
    // 禁止 call
}

- (void)containerWillDealloc {
    // 允许 call
}

#pragma mark - test data
- (NSArray<NSDictionary *> *)testPageData {
    return @[
        @{
            @"pageId": @"1",
            @"backgroudUrl": @"https://img0.baidu.com/it/"
                             @"u=1026982531,3317111284&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1659459600&t="
                             @"2abc2ada7c3057f1aa013a68af99ff23",
            @"switchable": @"1",
        },
        @{
            @"pageId": @"2",
            @"backgroudUrl":
                @"https://img2.baidu.com/it/u=1291049396,3762534027&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=893",
            @"switchable": @"1",
        },
        @{
            @"pageId": @"3",
            @"backgroudUrl": @"https://img2.baidu.com/it/"
                             @"u=1945309677,2982947304&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1659459600&t="
                             @"b1f31c7bc702f1e6c903baf0333d27dc",
            @"switchable": @"1",
        },
        @{
            @"pageId": @"4",
            @"backgroudUrl": @"https://img1.baidu.com/it/"
                             @"u=42055959,4255339361&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1659459600&t="
                             @"89e4e152789e245ce52a89fcd2b7ba92",
            @"switchable": @"1",
        }
    ];
}

@end
