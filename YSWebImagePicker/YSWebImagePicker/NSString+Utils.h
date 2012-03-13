//
//  NSString+NonStandardPercentEscapes.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
-(NSString*)encodeForURL;
+(NSString *)stringFromStringArray:(NSArray*)stringArray;
@end
