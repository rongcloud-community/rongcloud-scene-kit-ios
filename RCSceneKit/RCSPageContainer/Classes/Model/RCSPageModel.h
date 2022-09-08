//
//  RCSPageModel.h
//  RCSceneKit
//
//  Created by 彭蕾 on 2022/7/29.
//

#import <Foundation/Foundation.h>
#import "RCSPageItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSPageModel : NSObject <RCSPageItemProtocol>

@property (nonatomic, copy, nonnull) NSString *pageId;
@property (nonatomic, copy, nullable) NSString *backgroudUrl;
//@property (nonatomic, copy, nullable) NSString *themePictureUrl;
@property (nonatomic, assign) BOOL switchable;

@end

NS_ASSUME_NONNULL_END
