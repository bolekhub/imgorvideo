//
//  ViewController.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSURL *url = [NSURL URLWithString:@"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"];
    
    //NSURL *url = [NSURL URLWithString:@"https://placehold.jp/150x150.png"];
    
    NSURL *url = [NSURL URLWithString:@"https://media.giphy.com/media/duzpaTbCUy9Vu/giphy.gif"];

    [self.animatedView playVideoAtURL:url];
}

@end
