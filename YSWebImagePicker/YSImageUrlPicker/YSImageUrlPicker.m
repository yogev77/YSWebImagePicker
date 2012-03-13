//
//  YSImagePicker.m
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YSImageUrlPicker.h"
#import "AQGridView.h"
#import "YSImageUrlPickerCell.h"

#define kDEBUG 0

@interface YSImageUrlPicker() <AQGridViewDelegate,AQGridViewDataSource>

@property (nonatomic,strong) AQGridView* gridView;

-(void)setupView;
@end

@implementation YSImageUrlPicker
@synthesize gridView =_gridView;
@synthesize delegte,dataSource;

//---------------------------------------------------
#pragma mark - Public API
//---------------------------------------------------


-(void)reloadData
{
    [self.gridView reloadData];
}

-(void)setupView
{
    if(kDEBUG)
        self.view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.gridView];
}


//---------------------------------------------------
#pragma mark - Private API
//---------------------------------------------------

-(AQGridView*)gridView
{
    if(!_gridView)
    {
        _gridView  = [[AQGridView alloc] initWithFrame:self.view.frame];
        _gridView.delegate = self;
        _gridView.dataSource = self;
       _gridView.resizesCellWidthToFit = TRUE;
        _gridView.contentSizeGrowsToFillBounds = TRUE;
       _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _gridView.autoresizesSubviews = TRUE;
        _gridView.rightContentInset =0;
        if(kDEBUG)
            _gridView.backgroundColor = [UIColor redColor];
        /*
            TODO: there is an unwanted right inset, the workaround for now is to make the view holding this 
            Class 1 pixel wider, for this example it's @YSWebImagePicker.imagePickerView
         
         tried this, didn't help:  _gridView.rightContentInset =0;

         */

    }
    return _gridView;
}

//---------------------------------------------------
#pragma mark - AQGridView Implemntation
//---------------------------------------------------

#pragma mark - AQGridView Delegate

-(NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    return [self.dataSource YSImagePickerNumberOfImages];
}

-(AQGridViewCell*)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    NSString * CellId = [NSString stringWithFormat:@"CellId%i",index];
    
    if(index == [self.dataSource YSImagePickerNumberOfImages]-1)
        [self.delegte YSImagePickerDidPresentedLastItem];

    YSImageUrlPickerCell * imageCell = (YSImageUrlPickerCell*)[gridView dequeueReusableCellWithIdentifier:CellId];
    
    if ( imageCell == nil )
    {
        imageCell = [[YSImageUrlPickerCell alloc] initWithFrame:CGRectMake(0, 0, 500, 500) reuseIdentifier:CellId];
       imageCell.selectionStyle = AQGridViewCellSelectionStyleBlue;
    }

    [imageCell loadImageFromURL:[self.dataSource YSImagePickerImageURLForIndex:index]];


    return imageCell;
}

#pragma mark - AQGridView DataSource

-(CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    int cellInRow = 3;
    int cellWidth = self.gridView.frame.size.width/cellInRow;
    cellWidth =  cellWidth < 100 ? 100 : cellWidth > 150 ? 150 : cellWidth;
    return CGSizeMake(cellWidth , cellWidth);
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    [self.delegte YSImagePickerDidSelectImageAtIndex:index];
}





//---------------------------------------------------
#pragma mark - Super Methods
//---------------------------------------------------


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
       [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupView];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return TRUE;
}

@end
