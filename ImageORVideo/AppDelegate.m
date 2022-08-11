//
//  AppDelegate.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "AppDelegate.h"
#import "ImageCache.h"
#import "Network.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
Network *service;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ImageCache setup];
    /*
    [service getFromULR:@"https://placehold.jp/150x150.png" completionHandler:^(NSData * _Nullable data) {
        UIImage *img = [UIImage imageWithData:data];
        NSLog(@"finish");
    }];
     */
//    NSTimeInterval time = [[NSDate date] timeIntervalSinceNow];
//    [self performSelector:@selector(test) withObject:nil afterDelay: time+8];
        
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)test {
    [service getFromULR:@"https://placehold.jp/150x150.png" completionHandler:^(NSData * _Nullable data) {
        UIImage *img = [UIImage imageWithData:data];
        NSLog(@"finish");
    }];
}

@end
