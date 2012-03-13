//
//  NSString+NonStandardPercentEscapes.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)


-(NSString*)encodeForURL
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                   kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return encodedString ? encodedString : @""; 
}


+(NSString *)stringFromStringArray:(NSArray*)stringArray
{
    NSString* mergedString = @"";
    
    for(int i =0;i<[stringArray count];i++)
    {
        mergedString = [mergedString stringByAppendingString:[stringArray objectAtIndex:i]];
    }
    
    return mergedString;
}


@end

