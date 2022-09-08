//
//  RCSRoomViewController.m
//  RCSceneKit_Example
//
//  Created by 彭蕾 on 2022/8/1.
//  Copyright © 2022 彭蕾. All rights reserved.
//

#import "RCSRoomViewController.h"
#import <RCSceneKit/RCSPageFloaterManager.h>
#import <Masonry/Masonry.h>
@interface RCSRoomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *previewView;

@end

@implementation RCSRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor systemPurpleColor];

    [self.view insertSubview:self.previewView atIndex:0];
}


- (NSArray<UIView *> *)descendantViews {
    return @[];
}

- (void)leaveRoom:(void (^)(void))completion {
    dispatch_time_t loadingTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(loadingTime, dispatch_get_main_queue(), ^{
        completion();
    });
}

- (IBAction)miniminzeVC:(id)sender {
    [[RCSPageFloaterManager shared] showWithController:self.parentViewController
                                          avatarImgUrl:@"https://img2.baidu.com/it/"
                                                       @"u=1024116573,4231708672&fm=253&app=138&size=w931&n=0&f=JPEG&"
                                                       @"fmt=auto?sec=1659459600&t=b57ee4428efb4d0d2a92161f8fe11108"
                                              animated:YES];
    //    [[RCSPageFloaterManager shared] showWithController:self.parentViewController
    //                                          avatarImgUrl:@"https://img2.baidu.com/it/u=1024116573,4231708672&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1659459600&t=b57ee4428efb4d0d2a92161f8fe11108"
    //                                     customContentView:self.previewView
    //                                              animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIView *)previewView {
    if (!_previewView) {
        _previewView = [UIView new];
        _previewView.backgroundColor = [UIColor colorWithRed:0.8 green:0.5 blue:0.1 alpha:0.9];
        _previewView.frame =
            CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return _previewView;
}

@end
