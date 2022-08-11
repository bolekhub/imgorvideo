//
//  ImageCache.h
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject
+ (void)setData:(NSData*)data forKey:(NSString*)key;
+ (NSData*)dataForKey:(NSString*)key;
+ (void)setup;
@end

NS_ASSUME_NONNULL_END
