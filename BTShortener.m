//
//  BTShortener.m
//  Chirpings
//
//  Created by Thaddeus Ternes on 5/20/11.
//  Copyright 2011 Bluetoo Ventures. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of Bluetoo Ventures nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL BLUETOO VENTURES BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

- (void)shortenLink:(NSString *)url success:(void(^)())successblock failure:(void(^)())failureblock
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
