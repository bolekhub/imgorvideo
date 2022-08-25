//
//  UIImageView+URL.h
//  ImageORVideo
//
//  Created by Boris Chirino on 19/8/22.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (ImageViewNetwork)
- (void)loadImageFromURL:(NSURL*)url completionHandler:(void(^)(NSData * data))completion;
- (void)loadGIFData:( NSData *)data;
@end
NS_ASSUME_NONNULL_END
