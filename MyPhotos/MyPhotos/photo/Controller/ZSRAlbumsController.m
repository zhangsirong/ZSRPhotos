//
//  ZSRAlbumsController.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRAlbumsController.h"
#import "ZSRAlbumsCell.h"
#import "ZSRAssetGridController.h"

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const OtherReuseIdentifier = @"OtherReuseIdentifier";

@interface ZSRAlbumsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *otherFetchArray;//其他智能文件夹
@property (nonatomic, strong) PHFetchResult *allPhotoResults;//全部文件
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZSRAlbumsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
    self.view.backgroundColor = [UIColor redColor];
    [self createTableView];
    [self setupPhotosResult];
}

-(void)createTableView{
    if (self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor greenColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
        [self.view addSubview:tableView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.otherFetchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSRAlbumsCell *cell = nil;
    PHAsset *asset = nil;
    NSUInteger count = 0;
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *fetchingOptions = [[PHImageRequestOptions alloc] init];
    fetchingOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = 60.f;
    CGSize  size  = CGSizeMake(dimension * scale, dimension * scale);
    
    if (indexPath.section == 0) {
        PHFetchResult * fetchResult = self.allPhotoResults;
        cell = [ZSRAlbumsCell cellWithTableView:tableView reuseIdentifier:AllPhotosReuseIdentifier];
        cell.textLabel.text = @"所有照片";
        asset = [fetchResult lastObject];
        count = fetchResult.count;
        
    }else{
        PHCollection *collection = self.otherFetchArray[indexPath.row];
        cell = [ZSRAlbumsCell cellWithTableView:tableView reuseIdentifier:OtherReuseIdentifier];
        cell.textLabel.text = collection.localizedTitle;
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        asset = [assetsFetchResult lastObject];
        count = assetsFetchResult.count;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", count];
    [manager requestImageForAsset:asset
                       targetSize:size
                      contentMode:PHImageContentModeAspectFill
                          options:fetchingOptions
                    resultHandler:^(UIImage *result, NSDictionary *info) {
                        cell.imageView.image = result;
                    }];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZSRAlbumsCell heightWithTableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZSRAssetGridController *gridController = [[ZSRAssetGridController alloc] init];
    
    if (indexPath.section == 0) {
        gridController.assetsFetchResults = self.allPhotoResults;
        gridController.title = @"所有照片";
        
    }else{
        PHAssetCollection *assetCollection = self.otherFetchArray[indexPath.row];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        gridController.assetsFetchResults = assetsFetchResult;
        gridController.title = assetCollection.localizedTitle;
    }
    [self.navigationController pushViewController:gridController animated:YES];
}

#pragma mark - private
- (void)setupPhotosResult {
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *albumRegular = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (PHCollection *collection in smartAlbums) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        //去掉相片为0的相簿
        if (assetsFetchResult.count > 0) {
            [array addObject:collection];
        }
    }
    
    for (PHCollection *collection in albumRegular) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (assetsFetchResult.count > 0) {
            [array addObject:collection];
        }
    }
    self.otherFetchArray = array;
    self.allPhotoResults = allPhotos;
}

@end
