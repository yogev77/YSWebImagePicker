//
//  YSWebImageSearch.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSWebImageData.h"



typedef enum{
    eSearchSourceBing =0,
    eSearchSourceFlickr
}eSearchSource;

typedef enum{
    eWebImageSearchFail_NoInternet =0,
    eWebImageSearchFail_NoResults
}eWebImageSearchFail;


@protocol YSWebImageSearchDelegate <NSObject>

-(void)YSWebImageSearchImagesDataUpdated:(NSArray*)images;
-(void)YSWebImageSearchFailed:(eWebImageSearchFail)failedReason;

@end

/*
 *  Uses a given API source to fetch image results
 *  Supports: Bing
 */

@interface YSWebImageSearch : NSObject


@property (nonatomic,strong) NSNumber* imageCountPerPage;
@property (nonatomic,unsafe_unretained) id <YSWebImageSearchDelegate> delegate;
@property (readonly, copy) NSArray *images;

-(void)searchImagesForTerm:(NSString*)term;
-(void)fetchNextPage;
-(void)setSource:(eSearchSource)searchSource;

@end
