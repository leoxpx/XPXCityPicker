//
//  ViewController.m
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "ViewController.h"
#import "XPXCityPickerVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"XPXCityPicker";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    button.center = CGPointMake(self.view.center.x, 300);
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cityPickClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)cityPickClick {
    XPXCityPickerVC *city = [[XPXCityPickerVC alloc]init];
    city.locationCity = @"上海";
    city.selectCityNameAndId = ^(NSString *cityName, NSString *cityId) {
        self.title = [NSString stringWithFormat:@"%@ %@", cityName, cityId];
        NSLog(@"%@ %@",cityName, cityId);
    };
    [self.navigationController pushViewController:city animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
