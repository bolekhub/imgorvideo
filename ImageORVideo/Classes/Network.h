//
//  Nerwork.h
//  ImageORVideo
//
//  Created by Boris Chirino on 6/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject
- (void)getFromULR:(NSString*)stringURL completionHandler:(void(^)(NSData * _Nullable data))completion;
- (instancetype)initCachingResponse:(BOOL)cachingResponse NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
