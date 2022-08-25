//
//  AnimationView.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "AnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageORVideo-Swift.h"
#import "DataCache.h"
#import "UIImageView+Network.h"
#import "PlayerView.h"
#import "Network.h"
#import "NSData+NSData_FileFormats.h"

// This is an extension. (not a category). Extension are the one used when you own the implemntation.
// Sometimes are called anonymous category due to the lack of a name between braces.
@interface AnimationView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PlayerView *playerView;
@property (nonatomic, strong) Network *service;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.playerView];
        [self addSubview:self.imageView];
        [self.imageView fullFitWithTopMargin:0 bottomMargin:0 leftMargin:0 rightMargin:0];
        [self.playerView fullFitWithTopMargin:0 bottomMargin:0 leftMargin:0 rightMargin:0];
        _service = [[Network alloc] initCachingResponse:YES];
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleLarge];
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

-(UIView*)playerView {
    if (!_playerView) {
        _playerView = [[PlayerView alloc] init];
        _playerView.playerDelegate = self;
        _playerView.hidden = YES;
    }
    return _playerView;
}

- (void) showMediaAtURL:(NSURL*)url {
    [self.service getFromULR:url.absoluteString completionHandler:^(NSData * _Nullable data) {
        DataFormatsType dataType = [data format];
        switch (dataType) {
            case DataFormatJPEG:
            case DataFormatPNG:
            case DataFormatGIF:
            case DataFormatSVG: {
                [self toogle:self.imageView visible:YES];
                [self.imageView loadGIFData:data];
                break;
            }
            case DataFormatVIDEO: {
                [self toogle:self.playerView visible:YES];
                [self addSubview:self.activityIndicator];
                [self.activityIndicator startAnimating];
                AVAsset *asset = [AVAsset assetWithURL:url];
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [self.playerView playItem:playerItem];
                break;
            }
            case DataFormatUndefined:
                break;
        }
    }];
}

- (void)toogle:(UIView*)view visible:(BOOL)visible {
    [self.imageView setHidden:YES];
    [self.playerView setHidden:YES];
    [view setHidden:NO];
}

- (void)player:(AVPlayer *)player readyToPlay:(BOOL)ready {
    if ( ready ) {
        [self.activityIndicator stopAnimating];
    }
}

@end

