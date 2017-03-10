//
//  XPXCityPickerVC.m
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "XPXCityPickerVC.h"
#import "HotCityTableViewCell.h"
#import "LocationCityTableViewCell.h"

//RGB颜色
#define RGB(Red,Green,Blue,Alpha) [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:Alpha]
#define SECTION_BACKCOLOR [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]
#define GREEN_COLOR RGB(6, 207, 197, 1)

@interface XPXCityPickerVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,LocationCityTableViewCellDelegate,HotCityTableViewCellDelegate> {
    UILabel *charLabel;
}

@property (nonatomic,retain) UISearchController  *searchController;
@property (nonatomic,strong) NSMutableArray      *searchArray;

@property (nonatomic,retain) UITableView  *cityTableView;
@property (nonatomic,copy)   NSArray      *allCityArrTemp;
@property (nonatomic,copy)   NSArray      *allCityArr;
@property (nonatomic,copy)   NSArray      *hotCityArr;
@property (nonatomic,copy)   NSArray      *indexList;
@property (nonatomic,retain) UIButton     *locationCellBtn;

@end

@implementation XPXCityPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"城市选择";
    [self createNvcRightBtn];
    
    [self getData]; // 获取数据
    [self creatView];
}

#pragma mark - 加载数据
- (void)getData {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citytest" ofType:@"plist"];
    NSDictionary *cityDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    // 取到所有城市
    NSArray *allCityArrTemp = cityDict[@"allcity"];
    self.allCityArrTemp = allCityArrTemp;
    // 对所有城市升序排序
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];//yes升序排列，no,降序排列
    NSArray *myary = [allCityArrTemp sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd1]];//注意这里的ary进行排序后会生产一个新的数组指针myary，ary还是保持不变的。
    
    // 对所有城市按字母分组
    NSString       *lastKey    = @"a";
    NSMutableArray *ABCArr     = [NSMutableArray array];
    NSMutableArray *ABCArrTemp = [NSMutableArray array];
    
    // 索引
    NSMutableArray *list       = [[NSMutableArray alloc]init];
    [list addObject:@"定"];
    [list addObject:@"热"];
    
    for (NSDictionary *dic in myary) {
        if ([[dic[@"pinyin"] substringToIndex:1] isEqualToString:lastKey]) {
            [ABCArrTemp addObject:dic];
        } else {
            // 首字母不同时添加到分组数组
            [ABCArr addObject:ABCArrTemp];
            ABCArrTemp = [NSMutableArray array];
            
            [list addObject:[lastKey uppercaseString]];
        }
        // 每次取第一个字母
        lastKey = [dic[@"pinyin"] substringToIndex:1];
    }
    // 排序后的数组包含数组包含字典
    self.allCityArr = [ABCArr copy];
    self.indexList  = [list copy];
    
    
    // 热门城市
    NSArray *hotCityArrTemp = cityDict[@"hotcity"];
    self.hotCityArr = [hotCityArrTemp copy];
}
#pragma mark - 初始化视图
- (void)creatView {
    
    // tableView
    self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; // CGRectGetMaxY(grayBack.frame)
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    [self.view addSubview:self.cityTableView];
    // 索引字体颜色
    self.cityTableView.sectionIndexColor = GREEN_COLOR;
    // 索引背景颜色
    self.cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    // searchController
    self.searchArray = [NSMutableArray array];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //    self.searchController.hidesNavigationBarDuringPresentation = NO; // 搜索中不隐藏导航栏
    self.searchController.searchBar.placeholder = @"请输入要搜索的城市";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);
    self.cityTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }
    return self.indexList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchArray.count;
    }
    if (section == LocationSection) {
        return 1;
    } else if (section == HotCitySection) {
        return 1;
    } else {
        NSArray *charaArray = self.allCityArr[section-2];
        return charaArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.searchArray[indexPath.row][@"name"];
        return cell;
    }
    if (indexPath.section == LocationSection) {
        static NSString *locationIdentifier = @"LocationSection";
        LocationCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier];
        if (!cell) {
            cell = [[LocationCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        if (self.locationCity) {
            [cell.currentCity setTitle:self.locationCity forState:UIControlStateNormal];
        } else {
            [cell.currentCity setTitle:@"正在定位..." forState:UIControlStateNormal];
        }
        self.locationCellBtn = cell.currentCity;
        return cell;
    } else if (indexPath.section == HotCitySection) {
        static NSString *hotIdentifier = @"HotCitySection";
        HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier];
        if (!cell) {
            cell = [[HotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.hotCityArray = self.hotCityArr;
        return cell;
    } else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.allCityArr[indexPath.section-2][indexPath.row][@"name"];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HotCitySection) {
        return [HotCityTableViewCell getCellHeight];
    } else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0.01;
    }
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = SECTION_BACKCOLOR;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 25)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = GREEN_COLOR;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerLabel];
    if (section == LocationSection) {
        headerLabel.text = @"定位城市";
    } else if (section == HotCitySection) {
        headerLabel.text = @"热门城市";
    } else {
        NSString *chara = self.indexList[section];
        headerLabel.text = chara;
    }
    return headerView;
}
#pragma mark - 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return nil;
    }
    return self.indexList;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self showBigSelectedCharacter:title];
    if ([title isEqual:@"定"]) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return 0;
    } else if([title isEqual:@"热"]) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return 1;
    } else {
        NSInteger selectSection = 0;
        for (int i = 0; i<self.indexList.count; i++) {
            if ([self.indexList[i] isEqual:title]) {
                selectSection = i;
                break;
            }
            selectSection = 0;
        }
        if (self.allCityArr.count > 0) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:selectSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return selectSection;
        } else {
            return 0;
        }
    }
}

- (void)showBigSelectedCharacter:(NSString *)title {
    if (charLabel) {
        [charLabel removeFromSuperview];
    }
    
    charLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    charLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    charLabel.backgroundColor = GREEN_COLOR;
    charLabel.text = title;
    charLabel.textAlignment = NSTextAlignmentCenter;
    charLabel.font = [UIFont boldSystemFontOfSize:35];
    charLabel.textColor = [UIColor whiteColor];
    charLabel.layer.cornerRadius = 2;
    charLabel.layer.masksToBounds = YES;
    [self.view addSubview:charLabel];
    
    [UIView animateWithDuration:1 animations:^{
        charLabel.alpha = 0;
    }];
}
#pragma mark - UISearchController delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self.searchArray removeAllObjects];
    for (NSDictionary *dic in self.allCityArrTemp) {
        NSString *name = [NSString stringWithFormat:@"%@", dic[@"name"]];
        NSString *pinyin = [NSString stringWithFormat:@"%@", dic[@"pinyin"]];
        NSString *text = [NSString stringWithFormat:@"%@", self.searchController.searchBar.text];
        
        if ([name containsString:text] || [[pinyin lowercaseString] containsString:[text lowercaseString]]) {
            [self.searchArray addObject:dic];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cityTableView reloadData];
    });
}
#pragma mark - 点击返回
//点击定位城市
- (void)clickLocationCityTableViewCell:(UIButton *)button
{
    if (button.titleLabel.text.length != 0 && ![button.titleLabel.text isEqualToString:@"正在定位..."]) {
        NSLog(@"定位不提供城市ID(一般为外部传入), 三方自带");
        self.selectCityNameAndId(self.locationCity, self.locationCity);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击热门城市
- (void)clickHotCityTableViewCell:(UIButton *)button
{
    NSString *name = self.hotCityArr[button.tag-1000][@"name"];
    NSString *cityid = self.hotCityArr[button.tag-1000][@"city_id"];
    self.selectCityNameAndId(name, cityid);
    if (button.titleLabel.text.length != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击tableViewCell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        NSString *name = self.searchArray[indexPath.row][@"name"];
        NSString *cityid = self.searchArray[indexPath.row][@"city_id"];
        self.selectCityNameAndId(name, cityid);
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.section >= 2) {
        NSString *name = self.allCityArr[indexPath.section-2][indexPath.row][@"name"];
        NSString *cityid = self.allCityArr[indexPath.section-2][indexPath.row][@"city_id"];
        self.selectCityNameAndId(name, cityid);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 刷新定位
- (void)createNvcRightBtn {
    
    UIButton* nvcRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
    [nvcRightBtn setImage:[UIImage imageNamed:@"ios-ref"] forState:UIControlStateNormal];
    [nvcRightBtn addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView* customView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 60, 40)];
    customView.backgroundColor = [UIColor clearColor];
    [customView addSubview:nvcRightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customView];
}
-(void)refreshBtnClicked:(id)sender {
    // 假象
    [self startSpin];
    [self.locationCellBtn setTitle:@"正在定位..." forState:UIControlStateNormal];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopSpin];
            [self.locationCellBtn setTitle:self.locationCity forState:UIControlStateNormal];
        });
    });
}
//动画
- (void)startSpin {
    
    UIButton* rotateBtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.6f;
    rotationAnimation.repeatCount = MAXFLOAT;//设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [rotateBtn.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}
- (void)stopSpin {
    UIButton* rotateBtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    [rotateBtn.layer removeAllAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
