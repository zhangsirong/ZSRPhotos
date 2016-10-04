//
//  ZSRAssetGridController.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRAssetGridController.h"
#import "NSIndexSet+Convenience.h"
#import "ZSRGridViewCell.h"
#import "ZSRAssetController.h"

@interface ZSRAssetGridController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger currentIndex;


@end

@implementation ZSRAssetGridController

static NSString * const reuseIdentifier = @"GridCell";
static CGSize AssetGridThumbnailSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    [self createCollectionView];
    
    self.view.backgroundColor = [UIColor redColor];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

-(void)createCollectionView{
    CGFloat padding = 2;
    CGFloat row = 4;
    CGFloat itemWidth = (kScreenWidth - (row + 1) *padding)/row;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumLineSpacing = padding ;
    flowLayout.minimumInteritemSpacing = padding;
    flowLayout.sectionInset = UIEdgeInsetsMake(padding, padding, 0, padding);//上左下右
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[ZSRGridViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    CGFloat scale = [UIScreen mainScreen].scale;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        AssetGridThumbnailSize = CGSizeMake(200, 200);
    }else{
        AssetGridThumbnailSize = CGSizeMake(itemWidth * scale, itemWidth * scale);
    }
}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize thumbnailSize = AssetGridThumbnailSize;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    CGFloat pro = MAX(asset.pixelHeight, asset.pixelWidth) / MIN(asset.pixelHeight, asset.pixelWidth);
    if (MAX(asset.pixelHeight, asset.pixelWidth) > 4096 && pro > 2) {
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        thumbnailSize = CGSizeMake(60, 60);
    }
    
    ZSRGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:thumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.image = result;
                              }];
    return cell;
}

#pragma mark - UICollecionViewDelegete
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZSRAssetController *assetController = [[ZSRAssetController alloc] init];
    assetController.assetsFetchResults = self.assetsFetchResults;
    assetController.currentIndex = indexPath.item;
    [self.navigationController pushViewController:assetController animated:YES];
}

- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * scale, CGRectGetHeight(self.view.bounds) * scale);
    return targetSize;
}

#pragma mark - PHPhotoLibraryChangeObserver
-(void)photoLibraryDidChange:(PHChange *)changeInstance{
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        UICollectionView *collectionView = self.collectionView;
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            [collectionView reloadData];
        } else {
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        [self resetCachedAssets];
    });
}

#pragma mark - private
- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
}
@end
