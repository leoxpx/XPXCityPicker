//
//  HotCityTableViewCell.m
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "HotCityTableViewCell.h"
static CGFloat cellHeight;

@implementation HotCityTableViewCell
- (void)setHotCityArray:(NSArray *)hotCityArray
{
    self.backgroundColor = [UIColor whiteColor];
    _hotCityArray = hotCityArray;
    
    int totalloc=3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat edgeWidth = 20;
    CGFloat edgeHeight = 10;
    CGFloat buttonWidth = (width - 4*edgeWidth)/3;
    CGFloat buttonHeight = 30;
    
    if (_hotCityArray.count%totalloc == 0) {
        cellHeight = (_hotCityArray.count/totalloc) * (buttonHeight + edgeHeight) + edgeHeight;
    }else{
        cellHeight = (_hotCityArray.count/totalloc + 1) * (buttonHeight + edgeHeight) + edgeHeight;
    }
    
    for (int i=0; i<_hotCityArray.count; i++) {
        
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        CGFloat appviewx = edgeWidth + (buttonWidth + edgeWidth) * loc;
        CGFloat appviewy = edgeHeight + (buttonHeight + edgeHeight) * row;
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(appviewx,appviewy , buttonWidth , buttonHeight)];
        button.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [button.layer setCornerRadius:2];
        [button setTitle:_hotCityArray[i][@"name"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(buttonTitle:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
    }
    
    UIButton *button = (UIButton *)[self viewWithTag:1000 + hotCityArray.count - 1];
    if (button) {
        UILabel *whiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + edgeHeight, [UIScreen mainScreen].bounds.size.width, 30)];
        whiteLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteLabel];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithButtonTitle:(NSArray *)array
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}
- (void)buttonTitle:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickHotCityTableViewCell:)]) {
        [self.delegate clickHotCityTableViewCell:button];
    }else
    {
        NSLog(@"点击热门城市代理不响应");
    }
}

+ (CGFloat)getCellHeight
{
    return cellHeight;
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
