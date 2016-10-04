//
//  ZSRGridViewCell.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRGridViewCell.h"
@interface ZSRGridViewCell()

@property(nonatomic ,strong)UIImageView *imgView;

@end

@implementation ZSRGridViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        [self addSubview:self.imgView];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imgView.image = image;
}

@end
