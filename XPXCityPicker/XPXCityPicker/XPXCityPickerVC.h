//
//  XPXCityPickerVC.h
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SectionNumber) {
    LocationSection,
    HotCitySection,
    CitySection
};

@interface XPXCityPickerVC : UIViewController
/**
 *  定位城市名称
 */
@property (nonatomic,copy) NSString *locationCity;
/**
 *  选择的城市回调
 */
@property (nonatomic,copy) void (^selectCityNameAndId)(NSString *cityName, NSString *cityId);

@end
