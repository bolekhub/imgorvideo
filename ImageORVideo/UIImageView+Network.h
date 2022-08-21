//
//  UIImageView+URL.h
//  ImageORVideo
//
//  Created by Boris Chirino on 19/8/22.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageViewNetwork)
- (void)loadImageFromURL:(NSURL*_Nonnull)url completionHandler:(void(^_Nonnull)(NSData * _Nullable data))completion;
@end
