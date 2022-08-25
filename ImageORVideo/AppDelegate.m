//
//  AppDelegate.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "AppDelegate.h"
#import "DataCache.h"
#import "Network.h"
#import "ViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [DataCache setup];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyBoard instantiateViewControllerWithIdentifier: @"sb_mainvc"];
    UIScreen *screen = [UIScreen mainScreen] ;

    _window = [[UIWindow alloc] initWithFrame: screen.bounds ];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
