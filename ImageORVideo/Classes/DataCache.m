//
//  ImageCache.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "DataCache.h"
#import "Network.h"
#import <UIKit/UIKit.h>

@interface DataCache ()

@property (nonatomic, strong, nonnull) NSCache *cache;

@property (nonatomic, strong, nonnull) NSMutableSet *cacheKeys;

@end

@implementation DataCache

+ (instancetype) shared {
    static DataCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataCache alloc] init];
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
    [[DataCache shared] loadPersistedDataCache];
}

+ (void)setData:(NSData*)data forKey:(NSString*)key {
    [[DataCache shared].cacheKeys addObject:key];
    [[DataCache shared].cache setObject:data forKey:key];
    [[DataCache shared] savecache];
}

+ (NSData*)dataForKey:(NSString*)key {
   return [[DataCache shared].cache objectForKey:key];
}

- (void)savecache {
    NSError *error;
    NSMutableDictionary *toDiskCache = [NSMutableDictionary dictionary];
    
    for (NSString *key in [DataCache shared].cacheKeys) {
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
