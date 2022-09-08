//
//  RCSPageFloaterView.h
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/7/27.
//

#import <UIKit/UIKit.h>
@import Pulsator;

NS_ASSUME_NONNULL_BEGIN

@class RCSPageFloaterView;
@protocol RCSPageFloaterViewDelegate <NSObject>

/// 点击浮窗
- (void)didClickInFloater:(RCSPageFloaterView *)floater;

@end

@class RCSPageFloaterView;
@interface RCSPageFloaterView : UIView

/// 自定义内容
@property (nonatomic, strong) UIView *customContentView;

@property (nonatomic, strong, readonly) Pulsator *radarLayer;

@property (nonatomic, weak) id<RCSPageFloaterViewDelegate> delegate;

- (void)updateAvatarWithImgUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
