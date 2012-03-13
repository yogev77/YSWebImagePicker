//
//  ViewController.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "YSWebImageSearch.h"

@interface ViewController()<YSWebImagePickerDelegate,UIScrollViewDelegate,UIPopoverControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic,strong) UIPopoverController*popOver;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController
@synthesize webImagePicker =_webImagePicker;
@synthesize imageView = _imageView;
@synthesize popOver =_popOver;
@synthesize scrollView = _scrollView;


-(IBAction)presentWebImagePicker:(id)sender
{
    if(self.popOver)
    {
        [self.popOver dismissPopoverAnimated:FALSE];
        self.popOver =nil;
        return;
    }
    
    self.webImagePicker = [[YSWebImagePicker alloc] init];
    self.webImagePicker.delegate =self;
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:self.webImagePicker];
    self.popOver.delegate =self;
    [self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:TRUE];
}




-(void)YSWebImagePickerDidSelectImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.zoomScale =1;
    self.scrollView.contentSize = self.imageView.image.size;
}


-(UIImageView*)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = FALSE;
    }
    return _imageView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)inScroll {
    return self.imageView;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOver = nil;
}
//---------------------------------------------------
#pragma mark - SUPER Methods
//---------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
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
    [self.scrollView addSubview:self.imageView];

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
    return YES;
}







@end
