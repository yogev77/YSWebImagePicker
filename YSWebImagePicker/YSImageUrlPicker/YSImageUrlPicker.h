//
//  YSImagePicker.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@protocol YSImageUrlPickerDataSource <NSObject>

-(NSURL*)YSImagePickerImageURLForIndex:(int)index;
-(int)YSImagePickerNumberOfImages;

@end

@protocol YSImageUrlPickerDelegate <NSObject>

-(void)YSImagePickerDidPresentedLastItem;
-(void)YSImagePickerDidSelectImageAtIndex:(int)index;

@end


@interface YSImageUrlPicker : UIViewController

@property(nonatomic,weak) id <YSImageUrlPickerDataSource> dataSource;
@property(nonatomic,weak) id <YSImageUrlPickerDelegate> delegte;

-(void)reloadData;
@end
