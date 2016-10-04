//
//  ZSRAssetCell.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRAssetCell.h"
#import "ZSRPhotoView.h"
@interface ZSRAssetCell()

@property (nonatomic, strong) ZSRPhotoView *photoView;

@end

@implementation ZSRAssetCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    [self.photoView removeFromSuperview];
    self.photoView = [[ZSRPhotoView alloc] initWithFrame:self.bounds andImage:contentImage];
    self.photoView.autoresizingMask = (1 << 6) -1;
    [self.contentView addSubview:self.photoView];
}

@end
