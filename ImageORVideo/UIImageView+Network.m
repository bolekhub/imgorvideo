//
//  UIImageView+URL.m
//  ImageORVideo
//
//  Created by Boris Chirino on 19/8/22.
//

#import "UIImageView+Network.h"
#import "Network.h"

@implementation UIImageView (ImageViewNetwork)
- (void)loadImageFromURL:(NSURL*)url completionHandler:(void(^)(NSData * data))completion {
    Network *service = [[Network alloc] initCachingResponse:YES];
    [service getFromULR:url.absoluteString completionHandler:completion];
}
    //https://gist.github.com/andrei512/3894888
- (void)loadGIFData:( NSData *)data {
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        //get the number of images of
        size_t imageCount = CGImageSourceGetCount(src);
        if (imageCount == 0 ) { return; }
        frames = [NSMutableArray arrayWithCapacity:imageCount];
        
        for (size_t i = 0; i < imageCount; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = properties[(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = frameProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    [self setImage:[frames objectAtIndex:0]];
    [self setAnimationImages:frames];
    [self setAnimationDuration:animationTime];
    [self startAnimating];
}

@end
