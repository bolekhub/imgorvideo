//
//  UIImageView+URL.m
//  ImageORVideo
//
//  Created by Boris Chirino on 19/8/22.
//

#import "UIImageView+Network.h"
#import "Network.h"

@implementation UIImageView (ImageViewNetwork)
- (void)loadImageFromURL:(NSURL*_Nonnull)url completionHandler:(void(^_Nonnull)(NSData * _Nullable data))completion {
    Network *service = [[Network alloc] initCachingResponse:YES];
    [service getFromULR:url.absoluteString completionHandler:completion];
}
@end
