//
//  LandroidListCell.m
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "LandroidListCell.h"

@implementation LandroidListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_landroidLabel) {
            _landroidLabel = [[UILabel alloc] init];
            _landroidLabel.font = [UIFont systemFontOfSize:14.f];
            [_landroidLabel setBackgroundColor:[UIColor colorWithRed:108/255.0 green:113/255.0 blue:118/255.0 alpha:1.f]];
            _landroidLabel.textColor = [UIColor whiteColor];
            _landroidLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_landroidLabel];
            [_landroidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.centerX.equalTo(self.contentView.mas_centerX);
            }];
            _landroidLabel.layer.cornerRadius = 10.f/HScale;
            _landroidLabel.layer.masksToBounds = YES;
        }
    }
    return self;
}

@end
