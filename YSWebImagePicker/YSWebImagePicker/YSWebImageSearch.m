//
//  YSWebImageSearch.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YSWebImageSearch.h"
#import "ASIHTTPRequest.h"
#import "NSString+Utils.h"

/* BING example
 http://api.search.live.net/json.aspx?AppId=5B0D22D739247C06BE7F990ECBEC1A144F9B7C39&Sources=image&Query=prague&Image.Count=3&Image.Offset=0&Image.Filters=Size:Medium
 */


@interface YSWebImageSearch() <ASIHTTPRequestDelegate>

-(NSArray*)imagesFromJsonReponse:(NSString*)response;
-(void)fetchImages;
-(void)reset;

@property (readwrite, copy) NSArray *images;
@property (nonatomic, strong) NSString* searchTerm;

@end


@implementation YSWebImageSearch
@synthesize imageCountPerPage =_imageCountPerPage;
@synthesize images =_images;
@synthesize searchTerm = _searchTerm;

@synthesize delegate;

NSString * const BING_SEARCH_PATH = @"http://api.search.live.net/json.aspx";
NSString * const APP_ID = @"5B0D22D739247C06BE7F990ECBEC1A144F9B7C39";
int IMAGE_COUNT_PER_PAGE = 5;
int MAX_IMAGES_PER_PAGE = 50;

int pageIndex =0;


//---------------------------------------------------
#pragma mark - Public API
//---------------------------------------------------

-(NSNumber*)imageCountPerPage
{
    if(!_imageCountPerPage)
        _imageCountPerPage = [NSNumber numberWithInt:IMAGE_COUNT_PER_PAGE];
    
    return _imageCountPerPage;
}

-(void)setImageCountPerPage:(NSNumber *)imageCountPerPage
{
    _imageCountPerPage = [imageCountPerPage intValue] > MAX_IMAGES_PER_PAGE ? 
                [NSNumber numberWithInt:MAX_IMAGES_PER_PAGE] : imageCountPerPage;
}

-(void)searchImagesForTerm:(NSString *)term
{
    [self reset];
    self.searchTerm = term;
    [self fetchImages];
}


-(void)fetchNextPage{
    [self fetchImages];
}

-(void)setSource:(eSearchSource)searchSource
{
    //not implemented
}


//---------------------------------------------------
#pragma mark - Private API
//---------------------------------------------------

-(void)requestFinished:(ASIHTTPRequest *)request
{
   
    NSString *responseString = [request responseString];       
    NSArray* newImages =[self imagesFromJsonReponse:responseString];
    
    if(!newImages || ![newImages count])
    {
        [self reset];
        [delegate YSWebImageSearchFailed:eWebImageSearchFail_NoResults];
    }
    else
    {
        pageIndex++;
        self.images = [self.images arrayByAddingObjectsFromArray:newImages];
        NSLog(@"YSWebImageSearch.requestFinished.images: %@",self.images);
        [delegate YSWebImageSearchImagesDataUpdated:self.images];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"YSWebImageSearch.requestFailed: %@",error.description);
    
    [self reset];
    [delegate YSWebImageSearchFailed:eWebImageSearchFail_NoInternet];
}


-(void)reset
{
    pageIndex =0;
    self.images = [NSArray array];
}


-(void)fetchImages
{
    NSString* escapedSearchTerm = [self.searchTerm encodeForURL]; //@"%D7%A9%D7%9E%D7%A9";
    NSString* varAppId = [NSString stringWithFormat:@"?AppId=%@",APP_ID];
    NSString* varQuery = [NSString stringWithFormat:@"&Query=%@",escapedSearchTerm];
    NSString* varImageCount =  [NSString stringWithFormat:@"&Image.Count=%@",self.imageCountPerPage];
    NSString* varImageOffset =  [NSString stringWithFormat:@"&Image.Offset=%i",pageIndex * [self.imageCountPerPage intValue]+pageIndex];
    NSString* varSources = @"&Sources=image";
    NSString* varImageFilters  = @"&Image.Filters=Size:Large";
    
    NSString* requestString = [NSString stringFromStringArray:
                               [NSArray arrayWithObjects:BING_SEARCH_PATH,
                                varAppId,varSources,varQuery,
                                varImageCount,varImageOffset,varImageFilters,nil]];

     NSURL *url = [NSURL URLWithString:requestString];
    NSLog(@"YSWebImageSearch.searchTerm.url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}



-(NSArray*)imagesFromJsonReponse:(NSString*)response 
{
    //1.format to json
    //2. create YSImageData from json
    
    NSError* error;
    NSDictionary *JSON = 
    [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding] 
                                    options: NSJSONReadingMutableContainers 
                                      error:&error];
    
    if(error)
    {
        NSLog(@"YSWebImageSearch.imagesFromJsonReponse - Error: %@",error.description);
        return nil;
    }
    
    NSArray* images = [[[JSON objectForKey:@"SearchResponse"]
                        objectForKey:@"Image"] 
                       objectForKey:@"Results"];
    
    NSMutableArray* webImageDataArray = [NSMutableArray array];
    for(int i=0;i<[images count];i++)
    {
        YSWebImageData* imageData = [YSWebImageData imageDataFromBingImageData:
                                     [images objectAtIndex:i]];
        [webImageDataArray addObject:imageData];
    }
    return webImageDataArray;
    
}


@end
