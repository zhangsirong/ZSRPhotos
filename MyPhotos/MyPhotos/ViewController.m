//
//  ViewController.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ViewController.h"
#import "ZSRAlbumsController.h"
#import "ZSRPhotoView.h"
@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) ZSRPhotoView *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPickImage:) name:@"DID_PICK_IMAGE" object:nil];
}

- (void)setupSubViews {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.self.frame.size.width, 50)];
    [button addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor greenColor]];
    [button setTitle:@"选择照片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectButton = button;
    [self.view addSubview:button];
}

-(void)selectPhoto:(UIButton *)button{
    [self showPickImageController];
}

- (void)showPickImageController {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        ZSRAlbumsController *albumsVc = [[ZSRAlbumsController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:albumsVc];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限问题" message:@"请在设置中打开访问照片权限" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:action];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }
        }];
    }
}

-(void)didPickImage:(NSNotification *)noti{
    UIImage *image = noti.object;
    [self.photoView removeFromSuperview];

    CGRect frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 80);
    ZSRPhotoView *photoView = [[ZSRPhotoView alloc] initWithFrame:frame andImage:image];
    self.photoView = photoView;
    [self.view addSubview:photoView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DID_PICK_IMAGE" object:nil];
}
@end
