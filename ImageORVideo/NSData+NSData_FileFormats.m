//
//  NSData+NSData_FileFormats.m
//  ImageORVideo
//
//  Created by Boris Chirino on 23/8/22.
//
// File signatures table: http://www.garykessler.net/library/file_sigs.html

#import "NSData+NSData_FileFormats.h"
#define kSVGTagEnd @"</svg>"


@implementation NSData(FILEFORMATS)

-(DataFormatsType)format {
    uint8_t hSignature;
    [self getBytes:&hSignature length:1];
    switch (hSignature) {
        case 0xFF:
            return DataFormatJPEG;
        case 0x89:
            return DataFormatPNG;
        case 0x47:
            return DataFormatGIF;
        case 0x66:
        case 0x00:
            return DataFormatVIDEO;
        case 0x3C: {
            if ([self rangeOfData:[kSVGTagEnd dataUsingEncoding:NSUTF8StringEncoding]
                          options:NSDataSearchBackwards
                            range: NSMakeRange(self.length - MIN(100, self.length), MIN(100, self.length))].location != NSNotFound) {
                return DataFormatSVG;
            }
        }
    }
    return DataFormatUndefined;
}
@end
