//
//  RCSContainerCollectionView.h
//  RCScenePageContainerKit
//
//  Created by 彭蕾 on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface RCSContainerCollectionView : UICollectionView

@property (nonatomic, assign) BOOL scrollable;
@property (nonatomic, strong) NSArray<UIView *> *descendantViews;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
