//
//  RCSRoomViewController.h
//  RCSceneKit_Example
//
//  Created by 彭蕾 on 2022/8/1.
//  Copyright © 2022 彭蕾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSRoomCycleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSRoomViewController : UIViewController <RCSRoomCycleProtocol>

- (NSArray<UIView *> *)descendantViews;

@end

NS_ASSUME_NONNULL_END
