//
//  Nerwork.m
//  ImageORVideo
//
//  Created by Boris Chirino on 6/8/22.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import "DataCache.h"

@interface Network ()<NSURLSessionDataDelegate>

typedef void (^SessionCompletionHandler)(NSData * _Nullable data);

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) SessionCompletionHandler completion;

@property (nonatomic, strong) NSData *receivedData;

@property (nonatomic) BOOL cacheResponse;
@end


@implementation Network

- (instancetype)initCachingResponse:(BOOL)cachingResponse {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration: config
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _cacheResponse = cachingResponse;
    }
    return self;
}

- (void)getFromULR:(NSString*)stringURL completionHandler:(void(^)(NSData * _Nullable data))completion {
    NSData *chachedVersion = [self fromCacheWithKey:stringURL];
    if (chachedVersion) {
        self.completion(chachedVersion);
    } else {
        NSURL *url = [NSURL URLWithString:stringURL];
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url];
        self.completion = completion;
        [dataTask resume];
    }
}

#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    self.receivedData = data;
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.receivedData != nil && error == nil) {
        self.completion(self.receivedData);
        NSString *key = task.response.URL.absoluteString;
        [self cacheDataWithKey:key];
        _receivedData = nil;
    } else {
        self.completion(NULL);
    }
}

#pragma mark cache method
- (void)cacheDataWithKey:(NSString*)key {
    if (self.cacheResponse) {
        [DataCache setData:self.receivedData forKey:key];
    }
}

- (NSData*)fromCacheWithKey:(NSString*)key {
    if (self.cacheResponse) {
        return [DataCache dataForKey:key];
    }
    return  nil;
}

#pragma mark Subscribing to app events

@end

