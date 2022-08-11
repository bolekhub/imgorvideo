//
//  AnimationView.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "AnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageORVideo-Swift.h"

#import "ImageCache.h"


@interface AnimationView (PRIVATE)
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *videoView;

@end

//@synthesize imageView = _imageView;
@implementation AnimationView
    AVPlayer *_videoPlayer;
    AVPlayerLayer *_videoPlayerLayer;
    UIImageView *_imageView;
    UIView *_videoView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.videoView];
        [self addSubview:self.imageView];
        [self.videoView fullFitWithTopMargin:0 bottomMargin:0 leftMargin:0 rightMargin:0];
        [self.imageView fullFitWithTopMargin:0 bottomMargin:0 leftMargin:0 rightMargin:0];
    }
    return self;
}

-(UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hidden = YES;
    }
    return _imageView;
}

-(UIView*)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
        [_videoView setBackgroundColor:[UIColor blackColor]];
        _videoView.hidden = YES;
    }
    return _videoView;
}

- (void) playVideoAtURL:(NSURL*)url {
    if ([url.lastPathComponent.pathExtension isEqualToString:@"png"]) {
        [self.imageView setHidden:NO];
        [self.videoView setHidden:YES];
        NSData *imageData = [ImageCache dataForKey:url.absoluteString];
        [self.imageView setImage:[UIImage imageWithData:imageData]];
    } else {
        [self.videoView setHidden:NO];
        [self.imageView setHidden:YES];

            //self.videoView.frame = self.frame;
        AVAsset *asset = [AVAsset assetWithURL:url];
        NSArray *assetKeys = @[
            @"playable",
            @"hasProtectedContent"
        ];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:assetKeys];
        
        _videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        [_videoPlayer setMuted: YES];
        [_videoPlayer setActionAtItemEnd: AVPlayerActionAtItemEndNone];
        
        _videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
        [_videoPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPlayerLayer setFrame:self.videoView.frame];
        
        
        [self.videoView.layer addSublayer:_videoPlayerLayer];
        [_videoPlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPLayerReachedEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_videoPlayer currentItem]];
    }
}

- (void)videoPLayerReachedEnd {
    [_videoPlayer seekToTime:kCMTimeZero];
    [_videoPlayer play];
}
@end


