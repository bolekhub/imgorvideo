//
//  AnimationView.h
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import <UIKit/UIKit.h>
@class PlayerView;
@protocol PlayerViewEventsProtocol;

@interface AnimationView: UIView <PlayerViewEventsProtocol>
 - (void) showMediaAtURL:(NSURL*)url;
@end
