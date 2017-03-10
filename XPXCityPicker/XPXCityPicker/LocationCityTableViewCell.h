//
//  LocationCityTableViewCell.h
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationCityTableViewCellDelegate <NSObject>
/**
 *  点击定位城市
 *
 *  @param button 点击button
 */
- (void)clickLocationCityTableViewCell:(UIButton *)button;
@end

@interface LocationCityTableViewCell : UITableViewCell
@property(nonatomic,assign)id<LocationCityTableViewCellDelegate>delegate;
/**
 *  当前定位城市
 */
@property(nonatomic,retain)UIButton *currentCity;
@end
