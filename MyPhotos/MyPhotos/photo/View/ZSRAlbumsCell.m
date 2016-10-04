//
//  ZSRAlbumsCell.m
//  MyPhotos
//
//  Created by zsr on 2016/10/4.
//  Copyright © 2016年 zsr. All rights reserved.
//

#import "ZSRAlbumsCell.h"

@implementation ZSRAlbumsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.text = @"所有照片";
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
    
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView{
    return 80.0f;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    ZSRAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ZSRAlbumsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 60.0f, 60.0f);
    self.textLabel.frame = CGRectMake(80.0f, 20.0f, 240.0f, 20.0f);
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
