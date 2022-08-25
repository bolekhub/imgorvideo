//
//  ViewController.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "ViewController.h"
#import "Network.h"
#import "NSData+NSData_FileFormats.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@end

@implementation ViewController

- (IBAction)loadUrlAction:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    [self.animatedView showMediaAtURL:url];
}

@end
