//
//  YSWebImageData.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YSWebImageData.h"

@implementation YSWebImageData
@synthesize mediaUrl =_mediaUrl;
@synthesize title =_title;
@synthesize sourceUrl =_sourceUrl;
@synthesize thumbnailUrl =_thumbnailUrl;


+(YSWebImageData*)imageDataFromBingImageData:(NSDictionary*)bingImageData
{

    YSWebImageData * imageData = [[YSWebImageData alloc] init];

    imageData.mediaUrl = [bingImageData objectForKey:@"MediaUrl"];
    imageData.thumbnailUrl = [[bingImageData objectForKey:@"Thumbnail"] objectForKey:@"Url"];
    imageData.sourceUrl = [bingImageData objectForKey:@"Url"];
    imageData.title = [bingImageData objectForKey:@"Title"];
    
    return imageData;
        
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"ImageData.mediaUrl: %@",self.mediaUrl];
}

@end
