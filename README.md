# XPXCityPicker
###城市选择控件(含城市ID),城市及ID为[国家统计局最新数据](http://www.stats.gov.cn/tjsj/tjbz/xzqhdm/201608/t20160809_1386477.html)<br>
---
### 1、用法示例：
* 1.导入头文件<br>
  `#import "XPXCityPickerVC.h"`<br>
* 2.创建城市选择对象<br>
```
 XPXCityPickerVC *city = [[XPXCityPickerVC alloc]init];
 city.locationCity = @"上海";
 city.selectCityNameAndId = ^(NSString *cityName, NSString *cityId) {
  
  NSLog(@"%@ %@",cityName, cityId);
  
 };
 [self.navigationController pushViewController:city animated:YES];
```
<br>
---
### 2、图片示例：
![1.png](https://github.com/leoxpx/XPXCityPicker/blob/master/1.png)
![2.png](https://github.com/leoxpx/XPXCityPicker/blob/master/2.png)
![3.png](https://github.com/leoxpx/XPXCityPicker/blob/master/3.png)
