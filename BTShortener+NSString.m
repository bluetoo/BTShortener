//
//  BTShortener+NSString.m
//  Chirpings
//
//  Created by Thaddeus Ternes on 5/21/11.
//  Copyright 2011 Bluetoo Ventures. All rights reserved.
//

#import "BTShortener+NSString.h"


@implementation NSString (BTShortenerExtensions)

- (NSString *)trim
{
    NSString *trimmed = [self stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed;
}

@end
