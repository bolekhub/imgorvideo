//
//  ImageCache.m
//  ImageORVideo
//
//  Created by Boris Chirino on 4/8/22.
//

#import "DataCache.h"
#import "Network.h"
#import <UIKit/UIKit.h>
#import "NSData+NSData_FileFormats.h"

@interface DataCache ()
@property (nonatomic, strong, nonnull) NSCache *cache;
@property (nonatomic, strong, nonnull) NSMutableSet *cacheKeys;
@property (nonatomic, strong, nonnull) NSMapTable<NSString*, NSData*> *cacheMap;
@end

@implementation DataCache
    NSString  * const kCacheFileName = @"cache.dat";

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
        _cacheMap = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                              valueOptions:NSMapTableStrongMemory capacity:0];
        
    }
    return self;
}

+ (void)setup {
    [[DataCache shared] loadPersistedDataCache];
}

+ (void)setData:(NSData*)data forKey:(NSString*)key {
    [[DataCache shared].cacheMap setObject:data forKey:key];
    [[DataCache shared] savecache];
}

+ (NSData*)dataForKey:(NSString*)key {
    return [[DataCache shared].cacheMap objectForKey:key];
}

- (void)savecache {
    NSError *error;
    NSDictionary *dict = [self.cacheMap dictionaryRepresentation];
    NSData *packedData = [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:YES error:&error];
    [packedData writeToURL:[self cacheUrl] options:NSDataWritingAtomic error:&error];
}

- (void)loadPersistedDataCache {
    NSError *error;
    NSData *archivedData = [NSData dataWithContentsOfURL:[self cacheUrl]];
    
    NSDictionary *storedDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSDictionary class]
                                      fromData:archivedData
                                         error:&error];
    [storedDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)  {
        @synchronized (self) {
            [[DataCache shared].cacheMap setObject:obj forKey:key];
        }
    }];
}

- (NSURL*)cacheUrl {
    NSURL *cacheDirectory = [[NSFileManager.defaultManager URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] firstObject];
    NSURL *fullPath = [cacheDirectory URLByAppendingPathComponent:kCacheFileName];
    return  fullPath;
}

@end
