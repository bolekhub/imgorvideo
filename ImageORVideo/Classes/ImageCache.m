//
//  ImageCache.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "ImageCache.h"
#import "Network.h"
#import <UIKit/UIKit.h>

@interface ImageCache ()

@property (nonatomic, strong, nonnull) NSCache *cache;

@property (nonatomic, strong, nonnull) NSMutableSet *cacheKeys;

@end

@implementation ImageCache

+ (instancetype) shared {
    static ImageCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageCache alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cacheKeys = [[NSMutableSet alloc] initWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(savecache)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadPersistedDataCache)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

+ (void)setup {
    [[ImageCache shared] loadPersistedDataCache];
}

+ (void)setData:(NSData*)data forKey:(NSString*)key {
    [[ImageCache shared].cacheKeys addObject:key];
    [[ImageCache shared].cache setObject:data forKey:key];
}

+ (NSData*)dataForKey:(NSString*)key {
   return [[ImageCache shared].cache objectForKey:key];
}

- (void)savecache {
    NSError *error;
    NSMutableDictionary *toDiskCache = [NSMutableDictionary dictionary];
    
    for (NSString *key in [ImageCache shared].cacheKeys) {
        NSData *data = [self.cache objectForKey:key];
        if (data) {
            [toDiskCache setValue:data forKey:key];
        }
    }
    NSData *packedData = [NSKeyedArchiver archivedDataWithRootObject:toDiskCache requiringSecureCoding:YES error:&error];
    NSURL *documentsURL = [NSFileManager.defaultManager URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask][0];
    NSURL *fullPath = [documentsURL URLByAppendingPathComponent:@"cacheData"];
    [packedData writeToURL:fullPath options:NSDataWritingAtomic error:&error];
    NSLog(@"saved cache %@", error);
}

- (void)loadPersistedDataCache {
    NSError *error;
    
    NSURL *documentsURL = [NSFileManager.defaultManager URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask][0];
    NSURL *fullPath = [documentsURL URLByAppendingPathComponent:@"cacheData"];
    NSData *archivedData = [NSData dataWithContentsOfURL:fullPath];
    NSDictionary *storedDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSDictionary class]
                                      fromData:archivedData
                                         error:&error];
    //put back cache
    [storedDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)  {
        @synchronized (self) {
            [self.cache setObject:obj forKey:key];
        }
    }];
}

- (void)recoverCache {
}

@end
