//
//  BTShortener.m
//  Chirpings
//
//  Created by Thaddeus Ternes on 5/20/11.
//  Copyright 2011 Bluetoo Ventures. All rights reserved.
//

#import "BTShortener.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface BTShortener (Private)
- (void)shortenWithIsGd:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock;
- (void)shortenWithBitly:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock;
- (void)shortenWithTinyURL:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock;
@end

@implementation BTShortener
@synthesize service;
@synthesize shortenedUrl;

- (void)shortenLink:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock
{
    switch(service)
    {
        case BTShortenerIsGd:
            [self shortenWithIsGd:url success:successblock failure:failureblock];
            break;

        case BTShortenerBitly:
            [self shortenWithBitly:url success:successblock failure:failureblock];
            break;
            
        case BTShortenerTinyURL:
            [self shortenWithTinyURL:url success:successblock failure:failureblock];
            break;
            
        default:
            break;
            // Contributions welcome
            assert(0);
    }
}

- (void)shortenWithIsGd:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock
{
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *isUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://is.gd/create.php?format=json&url=%@", encodedUrl]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:isUrl];
    
    [request setCompletionBlock:^() {
        NSDictionary *result = [[request responseString] JSONValue];
        self.shortenedUrl = [result objectForKey:@"shorturl"];
        if(shortenedUrl)
        {
            successblock();
        }
        else
        {
            NSString *errmsg = [NSString stringWithString:@"Response did not contain shortened URL"];
            failureblock(errmsg);
        }
    }];
    [request setFailedBlock:^() {
        NSString *errmsg = [NSString stringWithFormat:@"Failed to shorten: %@", [[request error] localizedDescription]];
        failureblock(errmsg);
    }];
    
    [request start];
    return;
}

- (void)shortenWithBitly:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock
{
    NSString *errmsg = [NSString stringWithString:@"bit.ly support not implemented"];
    failureblock(errmsg);
    return;
}


- (void)shortenWithTinyURL:(NSString *)url success:(void(^)())successblock failure:(void(^)(NSString *errmsg))failureblock
{
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *isUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", encodedUrl]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:isUrl];
    
    [request setCompletionBlock:^() {
        self.shortenedUrl = [request responseString];
        NSRange expectTiny = [shortenedUrl rangeOfString:@"tinyurl.com"];
        
        if(expectTiny.location != NSNotFound)
        {
            successblock();
        }
        else
        {
            NSString *errmsg = [NSString stringWithString:@"Response did not contain shortened URL"];
            failureblock(errmsg);
        }
    }];
    [request setFailedBlock:^() {
        NSString *errmsg = [NSString stringWithFormat:@"Failed to shorten: %@", [[request error] localizedDescription]];
        failureblock(errmsg);
    }];
    
    [request start];
    return;
}

@end
