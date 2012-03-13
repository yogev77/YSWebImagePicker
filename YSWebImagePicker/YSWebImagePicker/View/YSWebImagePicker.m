//
//  YSWebImagePicker.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YSWebImagePicker.h"
#import "YSWebImageSearch.h"
#import "YSImageUrlPicker.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "MBProgressHUD.h"

@interface YSWebImagePicker()<YSWebImageSearchDelegate,
                    YSImageUrlPickerDelegate,YSImageUrlPickerDataSource,UISearchBarDelegate>

@property (nonatomic,strong) YSWebImageSearch *imageSearch;
@property (nonatomic,strong) YSImageUrlPicker* imagePicker;
@property (strong, nonatomic) IBOutlet UIView *imagePickerView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
-(void)searchForTerm:(NSString*)searchTerm;
-(void)failedToLoadPickedImage;

@end

@implementation YSWebImagePicker
@synthesize imageSearch =_imageSearch;
@synthesize imagePicker = _imagePicker;
@synthesize imagePickerView = _imagePickerView;
@synthesize searchBar = _searchBar;
@synthesize delegate;

//---------------------------------------------------
#pragma mark - Public API
//---------------------------------------------------


//---------------------------------------------------
#pragma mark - Private API
//---------------------------------------------------

-(YSWebImageSearch*)imageSearch
{
        if(!_imageSearch)
        {
            _imageSearch = [[YSWebImageSearch alloc] init];
            _imageSearch.delegate = self;
            _imageSearch.imageCountPerPage = [NSNumber numberWithInt:kDefaultNumberOfImagesPerPage];
        }
        
    return _imageSearch;
        
}


-(YSImageUrlPicker*)imagePicker
{
        if(!_imagePicker)
        {
            _imagePicker = [[YSImageUrlPicker alloc] init];
            _imagePicker.delegte = self;
            _imagePicker.dataSource = self;
        }
    
        return _imagePicker;
}

-(void)searchForTerm:(NSString*)searchTerm
{
    [MBProgressHUD hideHUDForView:self.imagePickerView animated:TRUE];
    [self.imageSearch searchImagesForTerm:searchTerm];
}

-(void)hideHud
{
    [MBProgressHUD hideHUDForView:self.imagePickerView animated:TRUE];
}

-(void)failedToLoadPickedImage
{
    if([self.delegate respondsToSelector:@selector(YSWebImagePickerFailedToLoadPickedImage)])
        [self.delegate YSWebImagePickerFailedToLoadPickedImage];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.imagePickerView animated:TRUE];
    hud.customView = [[UIView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Failed To Load Image";
    hud.detailsLabelText = @"Oops, pick a different image";
    
    [self performSelector:@selector(hideHud) withObject:self afterDelay:3];
}

//---------------------------------------------------
  #pragma mark - YSWebImageSearch Delegate
//---------------------------------------------------

-(void)YSWebImageSearchFailed:(eWebImageSearchFail)eWebImageSearchFail
{
    NSString* failMessage =  eWebImageSearchFail == eWebImageSearchFail_NoInternet ?
    @"Request Failed" : @"No Results Found";
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.imagePickerView animated:TRUE];
    hud.customView = [[UIView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText =failMessage;
    
}

-(void)YSWebImageSearchImagesDataUpdated:(NSArray *)images
{    
    [self.imagePicker reloadData];
}


//---------------------------------------------------
#pragma mark - YSWebImagePickr Delegate
//---------------------------------------------------

-(int)YSImagePickerNumberOfImages
{
    return [self.imageSearch.images count];
}

-(NSURL*)YSImagePickerImageURLForIndex:(int)index
{
    YSWebImageData* imageData =  [self.imageSearch.images objectAtIndex:index];
    return [NSURL URLWithString:imageData.thumbnailUrl];
}

-(void)YSImagePickerDidPresentedLastItem
{
    [self.imageSearch fetchNextPage];
}

-(void)YSImagePickerDidSelectImageAtIndex:(int)index
{
    YSWebImageData*imageData = [self.imageSearch.images objectAtIndex:index];
    NSLog(@"YSWebImagePicker.YSImagePickerDidSelectImageAtIndex.imageData: %@", imageData);
    ASIHTTPRequest *_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:imageData.mediaUrl]];
    __weak ASIHTTPRequest *request = _request;

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [request setCompletionBlock:^{
      
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        UIImage* image =[UIImage imageWithData:responseData];
        [self.delegate YSWebImagePickerDidSelectImage:image];
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];

    }];
    [request setFailedBlock:^{
       // NSError *error = [request error];
        [self failedToLoadPickedImage];
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
    }];
    [request startAsynchronous];

}



//---------------------------------------------------
#pragma mark - YSWebImageSearch Delegate
//---------------------------------------------------

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchForTerm:searchBar.text];

}
//---------------------------------------------------
#pragma mark - SUPER Methods
//---------------------------------------------------

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [self.searchBar becomeFirstResponder];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setImagePickerView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.imagePickerView addSubview:self.imagePicker.view];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return TRUE;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
