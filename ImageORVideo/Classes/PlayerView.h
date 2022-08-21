//
//  PlayerView.h
//  ImageORVideo
//
//  Created by Boris Chirino on 20/8/22.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
@class AVPlayerItem;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView
- (void)playItem:(AVPlayerItem*)item;
@end

NS_ASSUME_NONNULL_END
