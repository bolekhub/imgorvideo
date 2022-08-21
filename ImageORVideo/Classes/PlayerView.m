//
//  PlayerView.m
//  ImageORVideo
//
//  Created by Boris Chirino on 20/8/22.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerView()
@property (nonatomic, nullable) AVPlayer *player;
@property (nonatomic, nonnull, readonly)  AVPlayerLayer *playerLayer;
@end

@implementation PlayerView
NSString *contextStatus = @"he";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColor.blueColor];

    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer self];
}

- (AVPlayer*)player {
    return [self.playerLayer player];
}
    
- (void)setPlayer:(AVPlayer *)player {
    [self.playerLayer setPlayer:player];
}

-(AVPlayerLayer*)playerLayer {
    return (AVPlayerLayer*)[self layer];
}

- (void)playItem:(AVPlayerItem*)item {
    AVPlayer *_player = [AVPlayer playerWithPlayerItem:item];
    [self setPlayer:_player];
    [self.player setMuted:YES];
    [self.player setActionAtItemEnd: AVPlayerActionAtItemEndNone];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self setupObservers];
    [self.player play];
}

- (void)videoPLayerReachedEnd {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

-(void)setupObservers {
    [self.player addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                     context:&contextStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.player.currentItem
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        [self videoPLayerReachedEnd];
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ( context == &contextStatus) {
        if ([change[NSKeyValueChangeNewKey] intValue] == AVPlayerStatusReadyToPlay ) {
            NSLog(@"readyToplay");
        }
    }
}
@end

