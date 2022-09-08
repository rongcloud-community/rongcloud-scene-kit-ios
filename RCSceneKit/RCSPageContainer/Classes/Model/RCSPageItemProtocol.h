//
//  RCSPageItemProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/25.
//

@protocol RCSPageItemProtocol <NSObject>

@property (nonatomic, copy, nonnull) NSString *pageId;
@property (nonatomic, copy, nullable) NSString *backgroudUrl;
@property (nonatomic, copy, nullable) NSString *themePictureUrl;
@property (nonatomic, assign) BOOL switchable;

@end
