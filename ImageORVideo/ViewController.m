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
    NSURL *url = [NSURL URLWithString:@"https://youtu.be/J38Yq85ZoyY"];
    //NSURL *url = [NSURL URLWithString:@"https://placehold.jp/150x150.png"];


    [self.animatedView playVideoAtURL:url];
}

@end
