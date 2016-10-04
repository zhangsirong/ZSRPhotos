//
//  ZSRBaseController.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRBaseController.h"

@implementation ZSRBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupNavBar {
    NSMutableDictionary *titleTextAttrs = [NSMutableDictionary dictionary];
    titleTextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttrs;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:216.0/255 blue:181.0/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0 green:216.0/255 blue:181.0/255 alpha:1.0];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
