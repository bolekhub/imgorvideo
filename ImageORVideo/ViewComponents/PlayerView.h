//
//  PlayerView.h
//  ImageORVideo
//
//  Created by Boris Chirino on 20/8/22.
//

#import <UIKit/UIKit.h>
@class AVPlayerItem, AVPlayer;
@protocol PlayerViewEventsProtocol <NSObject>
-(void)player:(AVPlayer*)player readyToPlay:(BOOL)ready;
@end

@interface PlayerView : UIView
@property (weak) id<PlayerViewEventsProtocol> playerDelegate;
- (void)playItem:(AVPlayerItem*)item;
@end

