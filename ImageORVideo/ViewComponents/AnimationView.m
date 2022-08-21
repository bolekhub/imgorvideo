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

@interface AnimationView (PRIVATE)
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PlayerView *playerView;
@end

@implementation AnimationView
    UIImageView *_imageView;
    PlayerView *_playerView;
    NSArray *imageExtensions = @[@"png", @"jpg", @"tiff", @"gif"];
    NSArray *videoExtensions = @[@"mp4", @"avi", @"mpg"];


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
        _playerView.hidden = YES;
    }
    return _playerView;
}

- (void) playVideoAtURL:(NSURL*)url {
    if ([imageExtensions containsObject:url.lastPathComponent.pathExtension]) {
        [self.imageView setHidden:NO];
        [self.playerView setHidden:YES];
        NSData *imageData = [DataCache dataForKey:url.absoluteString];
        if (!imageData) {
            [self.imageView loadImageFromURL:url completionHandler:^(NSData * _Nullable data) {
                UIImage *img = [UIImage gifWithData:data];
                [self.imageView setImage:[UIImage imageWithData:data]];
            }];
        } else {
            UIImage *img = [UIImage gifWithData:imageData];

            [self.imageView setImage:[UIImage imageWithData:imageData]];
        }
    } else if ([videoExtensions containsObject:url.lastPathComponent.pathExtension]) {
        [self.playerView setHidden:NO];
        [self.imageView setHidden:YES];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        [self.playerView playItem:playerItem];
    }
}

@end


