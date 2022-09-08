//
//  RCSPageFloaterManager.h
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSPageFloaterManager : NSObject
/// 强持有 floatingController 的代理，防止页面 dealloc 后，代理为空
@property (nonatomic, strong, nullable) NSArray<id> *multiDelegates;
@property (nonatomic, strong, readonly, nullable) UIViewController *controller;

+ (instancetype)shared;

- (void)showWithController:(UIViewController *)controller
              avatarImgUrl:(nullable NSString *)imgUrl
         customContentView:(nullable UIView *)contentView
                  animated:(BOOL)animated;

- (void)showWithController:(UIViewController *)controller
              avatarImgUrl:(nullable NSString *)imgUrl
                  animated:(BOOL)animated;

- (void)updateAvatarImgUrl:(NSString *)imgUrl;

- (void)hide;

- (BOOL)showing;

- (void)floaterViewDidClick;

- (void)setSpeakingState:(BOOL)isSpeaking;

@end

NS_ASSUME_NONNULL_END
