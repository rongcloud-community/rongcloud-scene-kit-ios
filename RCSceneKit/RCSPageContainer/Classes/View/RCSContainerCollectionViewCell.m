//
//  RCSContainerCollectionViewCell.m
//  RCScenePageContainerKit
//
//  Created by 彭蕾 on 2022/7/22.
//

#import "RCSContainerCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface RCSContainerCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, copy) NSString *backgroundUrl;

@end

@implementation RCSContainerCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - notification
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundImageChanged:)
                                                 name:RCSPContainerRoomBGUpdatedNotificaitonName
                                               object:nil];
}

- (void)backgroundImageChanged:(NSNotification *)noti {
    NSDictionary *notiObj = noti.object;
    NSString *notiRoomId = notiObj.allKeys.firstObject;
    if (![notiRoomId isEqualToString:self.pageId] || notiRoomId.length == 0) {
        return;
    }

    self.backgroundUrl = notiObj.allValues.firstObject;
    [self updateBackgroundImage];
}

#pragma mark - public method
- (void)updateUIWithPageId:(NSString *)pageId backgroundUrl:(NSString *)backgroundUrl {
    self.backgroundColor = [UIColor blackColor];
    self.pageId = pageId;
    self.backgroundUrl = backgroundUrl;
    [self updateBackgroundImage];
}

- (void)startGifAnimation {
    if (self.backgroundUrl.length == 0) {
        return;
    }

    NSURL *imageURL = [NSURL URLWithString:self.backgroundUrl];
    [self.bgImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached];
}

- (void)stopGifAnimation {
    if (self.backgroundUrl.length == 0) {
        return;
    }

    [self updateBackgroundImage];
}

- (void)setUpContentView:(UIView *)view {
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    view.alpha = 0;
    [UIView animateWithDuration:0.3
        animations:^{
            view.alpha = 1;
        }
        completion:^(BOOL finished) {
            [self startGifAnimation];
        }];
}

#pragma mark - private method
- (void)updateBackgroundImage {
    NSURL *imageURL = [NSURL URLWithString:self.backgroundUrl ?: @""];
    SDWebImageOptions options = SDWebImageRefreshCached | SDWebImageDecodeFirstFrameOnly;
    [self.bgImageView sd_setImageWithURL:imageURL placeholderImage:nil options:options];
}

#pragma mark - lazy load
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    return _bgImageView;
}


@end
