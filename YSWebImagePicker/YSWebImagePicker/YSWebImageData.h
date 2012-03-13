//
//  YSWebImageData.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSWebImageData : NSObject

@property (nonatomic,strong) NSString* mediaUrl;
@property (nonatomic,strong) NSString* thumbnailUrl;
@property (nonatomic,strong) NSString* sourceUrl;
@property (nonatomic,strong) NSString* title;

+(YSWebImageData*)imageDataFromBingImageData:(NSDictionary*)bingImageData;
@end


/*
 
 BingImageData:
 
 {
     ContentType = "image/gif";
     DisplayUrl = "http://www.free-clipart-pictures.net/dog_clipart.html";
     FileSize = 7083;
     Height = 200;
     MediaUrl = "http://www.free-clipart-pictures.net/free_clipart/dog_clipart/dog_clipart_puppy.gif";
     Thumbnail =         {
     ContentType = "image/jpeg";
     FileSize = 5603;
     Height = 160;
     Url = "http://ts3.mm.bing.net/images/thumbnail.aspx?q=1631390215342&id=a524feb4d142c235e6bb05f2fb306534";
     Width = 160;
     };
     Title = "Free dog clipart graphics. Puppy, female dog, bone, bulldog, k-9 ...";
     Url = "http://www.free-clipart-pictures.net/dog_clipart.html";
     Width = 200;
 }
 
 
*/
