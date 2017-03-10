//
//  LocationCityTableViewCell.m
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "LocationCityTableViewCell.h"

@implementation LocationCityTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.currentCity = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
        self.currentCity.backgroundColor = [UIColor whiteColor];
        [self.currentCity.layer setCornerRadius:5];
        [self.currentCity addTarget:self action:@selector(buttonTitle:) forControlEvents:UIControlEventTouchUpInside];
        self.currentCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.currentCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.currentCity];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-25-15, 14, 12, 15)];
        icon.image = [UIImage imageNamed:@"ios-loc"];
        [self.contentView addSubview:icon];
    }
    return self;
}

- (void)buttonTitle:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickLocationCityTableViewCell:)]) {
        [self.delegate clickLocationCityTableViewCell:button];
    }else
    {
        NSLog(@"定位当前城市代理不响应");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
