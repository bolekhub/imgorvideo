//
//  NSData+NSData_FileFormats.h
//  ImageORVideo
//
//  Created by Boris Chirino on 23/8/22.
//

#import <Foundation/Foundation.h>

typedef enum DataFormats: NSUInteger {
    DataFormatUndefined,
    DataFormatJPEG,
    DataFormatPNG,
    DataFormatGIF,
    DataFormatSVG,
    DataFormatVIDEO
} DataFormatsType;

@interface NSData (FILEFORMATS)
NS_ASSUME_NONNULL_BEGIN
-(DataFormatsType)format;
-(NSURL*)fileURL;
NS_ASSUME_NONNULL_END
@end
