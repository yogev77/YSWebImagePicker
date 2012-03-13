//
//  YSImagePickerCell.h
//  YSWebImagePicker
//
//  Created by yogev shelly on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AQGridViewCell.h"

@interface YSImageUrlPickerCell : AQGridViewCell

@property (nonatomic,strong) UIImageView*imageView;
-(void)loadImageFromURL:(NSURL*)imageUrl;
@end
