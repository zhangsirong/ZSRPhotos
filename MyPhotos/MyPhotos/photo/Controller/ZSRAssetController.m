//
//  ZSRAssetController.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRAssetController.h"
#import "ZSRAssetCell.h"
static NSString * const reuseIdentifier = @"AssetCell";

@interface ZSRAssetController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *browserCollectionView;
@property (nonatomic, strong) PHAsset *currentAsset;

@end

@implementation ZSRAssetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButton];
    [self createCollectionView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.browserCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];    
}

- (void)createButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.self.frame.size.width, 50)];
    [button addTarget:self action:@selector(usePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button setTitle:@"使用照片" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

-(void)createCollectionView{
    CGSize itemSize;
    float bottomHeigth = 50.0;
    CGFloat navigationBarH = 0;
    if (self.navigationController.navigationBar) {
        navigationBarH = CGRectGetHeight(self.navigationController.navigationBar.frame);
    }
    itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds) - navigationBarH - bottomHeigth);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = itemSize;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    CGRect frame = CGRectMake(0, navigationBarH, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navigationBarH - bottomHeigth);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[ZSRAssetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.browserCollectionView = collectionView;
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSRAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setSynchronous:NO];
    PHAsset *asset = self.assetsFetchResults[indexPath.row];
    self.currentAsset = asset;
    self.currentIndex = indexPath.row;
    CGSize screenSize = CGSizeMake(kScreenWidth * kScreenScale, kScreenHeight * kScreenScale);
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:screenSize
                                                     contentMode:PHImageContentModeAspectFit
                                                         options:options
                                                   resultHandler:^(UIImage *result, NSDictionary *info)
     {
         cell.contentImage = result;
     }];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView subviews][0];
}

-(void)usePhoto:(UIButton *)button{
    ZSRAssetCell *cell = [self.browserCollectionView.visibleCells lastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DID_PICK_IMAGE" object:cell.contentImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
