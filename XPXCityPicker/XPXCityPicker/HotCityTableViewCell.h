//
//  HotCityTableViewCell.h
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HotCityTableViewCellDelegate <NSObject>
/**
 *  点击热门城市
 *
 *  @param button 点击button
 */
- (void)clickHotCityTableViewCell:(UIButton *)button;
@end

@interface HotCityTableViewCell : UITableViewCell
/**
 *  热门城市数组
 */
@property(nonatomic,copy)NSArray *hotCityArray;
@property(nonatomic,assign)id<HotCityTableViewCellDelegate>delegate;
/**
 *  获取cell高度
 *
 *  @return cell高度
 */
+ (CGFloat)getCellHeight;
@end
