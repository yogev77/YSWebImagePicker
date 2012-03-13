//
//  YSWebImagePicker.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultNumberOfImagesPerPage 50

@protocol YSWebImagePickerDelegate <NSObject>

-(void)YSWebImagePickerDidSelectImage:(UIImage*)image;

@optional
-(void)YSWebImagePickerFailedToLoadPickedImage;

@end

@interface YSWebImagePicker : UIViewController

@property(nonatomic,weak) id<YSWebImagePickerDelegate>delegate;
@end
