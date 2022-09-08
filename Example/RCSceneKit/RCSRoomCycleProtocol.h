//
//  RCSRoomCycleProtocol.h
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/8/1.
//  Copyright © 2022 彭蕾. All rights reserved.
//

@protocol RCSRoomCycleProtocol <NSObject>

- (NSArray<UIView *> *)descendantViews;

- (void)leaveRoom:(void (^)(void))completion;

@end
