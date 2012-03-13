//
//  YSImagePickerCell.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YSImageUrlPickerCell.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface YSImageUrlPickerCell()<ASIHTTPRequestDelegate>

//@property (nonatomic,weak) ASIHTTPRequest*request;
@property (nonatomic,strong) NSString *imageURLPath;
@property (nonatomic,strong)ASIHTTPRequest* imageRequest;
@end

@implementation YSImageUrlPickerCell
@synthesize imageView = _imageView;
@synthesize imageURLPath = _imageURLPath;
@synthesize imageRequest = _imageRequest;

-(void)loadImageFromURL:(NSURL *)imageUrl
{
    NSLog(@"loadImageFromURL.relativeString: %@",imageUrl.relativeString);
    NSLog(@"loadImageFromURL.imageURLPath: %@",self.imageURLPath);
    
    if([imageUrl.relativeString isEqualToString:self.imageURLPath])
    {
         NSLog(@"-------- RETURN -----");
        return;
    }
    
    
     NSLog(@"-----------------");
    self.imageURLPath = imageUrl.relativeString;
    self.imageView.hidden = TRUE;

    self.imageRequest = [ASIHTTPRequest requestWithURL:imageUrl];
    self.imageRequest.delegate = self;
    [self.imageRequest startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self animated:TRUE];
}

-(void)setImageRequest:(ASIHTTPRequest *)imageRequest
{
    if(self.imageRequest)
        [self.imageRequest clearDelegatesAndCancel];
    

    _imageRequest = imageRequest;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    self.imageView.image = [UIImage imageWithData:responseData];
    self.imageView.hidden = FALSE;
    [MBProgressHUD hideHUDForView:self animated:TRUE];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
   // NSError *error = [request error];
    [MBProgressHUD hideHUDForView:self animated:TRUE];
}

- (void) layoutSubviews
{
      self.imageView.frame = self.contentView.frame;
}
 
-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = TRUE;
        [self.contentView addSubview:self.imageView];
        self.imageView.frame = self.contentView.frame;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return self;
}


@end
