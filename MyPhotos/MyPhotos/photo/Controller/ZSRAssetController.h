//
//  ZSRAssetController.h
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSRBaseController.h"
@interface ZSRAssetController : ZSRBaseController

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, assign) NSInteger currentIndex;

@end
