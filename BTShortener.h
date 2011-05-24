//
//  BTShortener.h
//  Chirpings
//
//  Created by Thaddeus Ternes on 5/20/11.
//  Copyright 2011 Bluetoo Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    BTShortenerIsGd,
    BTShortenerBitly,
    BTShortenerTinyURL
} eBTShortenerService;

@interface BTShortener : NSObject {
    eBTShortenerService service;
    NSString *shortenedUrl;
}

- (void)shortenLink:(NSString *)url success:(void(^)())successblock failure:(void(^)())failureblock;

@property (assign) eBTShortenerService service;
@property (nonatomic, retain) NSString *shortenedUrl;
@end
