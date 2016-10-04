//
//  ZSRAlbumsCell.h
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSRAlbumsCell : UITableViewCell

+ (CGFloat)heightWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
