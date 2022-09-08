//
//  RCSContainerCollectionViewCell.h
//  RCScenePageContainerKit
//
//  Created by 彭蕾 on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSContainerCollectionViewCell : UICollectionViewCell

- (void)setUpContentView:(UIView *)view;
- (void)updateUIWithPageId:(NSString *)pageId backgroundUrl:(NSString *)backgroundUrl;

- (void)startGifAnimation;
- (void)stopGifAnimation;


@end

NS_ASSUME_NONNULL_END
