//
//  AshViewController.m
//  AshFilterView
//
//  Created by Ash on 07/28/2017.
//  Copyright (c) 2017 Ash. All rights reserved.
//

#import "AshViewController.h"
#import <AshFilterView/AshFilterView.h>
#import <FrameAccessor/FrameAccessor.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface AshViewController ()<AshFilterViewDataSource ,AshFilterViewDelegate>

@property (nonatomic ,strong) AshFilterView *filterView;
@property (nonatomic ,strong) NSArray<NSString *> *filterTabTitles;
@property (nonatomic ,strong) NSArray<NSString *> *multiListDatas;
@property (nonatomic ,strong) NSArray<NSString *> *singleListDatas;

@property (nonatomic ,strong) NSMutableArray<NSString *> *selectedTitles;


@end

@implementation AshViewController

- (AshFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[AshFilterView alloc] initWithFrame:self.view.frame];
        _filterView.dataSource = self;
        _filterView.delegate = self;
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.filterTabTitles = @[@"级连列表",@"单选列表",@"多选列表",@"自定义"];
    self.multiListDatas = @[@"1",@"2",@"3"];
    self.singleListDatas = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j"];
    
    self.selectedTitles = [[NSMutableArray alloc] initWithArray:self.filterTabTitles];

    [self.view addSubview:self.filterView];
    
    [self.filterView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark delegate
- (void)ash_filterView:(AshFilterView *) filterView
didSelectedListRowNumbers:(NSArray<NSNumber *> *) selectedRowNumbers{
    NSMutableString *title = [NSMutableString new];
    if (selectedRowNumbers.count > 0) {
        switch (filterView.selectedTabIndex) {
            case 1:{
                NSNumber *selectedIndex = selectedRowNumbers[0];
                NSString *selectedTitle = self.singleListDatas[selectedIndex.integerValue];
                [title appendString:selectedTitle];
            }
                break;
            case 2:{
                if (selectedRowNumbers.count > 1) {
                    [title appendString:@"多选"];
                } else {
                    NSNumber *selectedIndex = selectedRowNumbers[0];
                    NSString *selectedTitle = self.multiListDatas[selectedIndex.integerValue];
                    [title appendString:selectedTitle];
                }
            }
                break;
            default:
                break;
        }
    }
    self.selectedTitles[filterView.selectedTabIndex] = title;
    [filterView reloadTabbar];;
}

- (void)ash_filterView:(AshFilterView *) filterView
didSelectedHierarchyItems:(NSArray<NSString *> *) selectedItems{
    
}

#pragma mark dataSource
- (NSInteger)ash_filterViewNumberOfTabs:(AshFilterView *)filterView{
    return self.filterTabTitles.count;
}

- (NSString *)ash_filterView:(AshFilterView *) filterView titleForTab:(NSInteger) tabIndex{
    NSString *selectedTitle = self.selectedTitles[tabIndex];
    if (0 == selectedTitle.length) {
        selectedTitle = self.filterTabTitles[tabIndex];
    }
    return  selectedTitle;
}

- (NSArray<NSDictionary<NSString *,NSArray<NSString *> *> *> *)ash_filterView:(AshFilterView *) filterView
                                                             hierarchyDatasAt:(NSInteger)tabIndex{
//   NSDictionary<NSString *,NSArray<NSString *> *> *kv =  [NSMutableDictionary dictionaryWithDictionary:@{@"浦东区":@[@"塘桥端口端口",@"三林",@"陆家嘴"],@"闵行区":@[@"华漕1",@"爱博2",@"虹桥3"],@"长宁区":@[@"华漕11",@"爱博22",@"虹桥33"],@"松江区":@[@"华漕4",@"爱博5",@"虹桥6"],@"宝山区":@[@"华漕44",@"爱博55",@"虹桥66"],@"杨浦区7":@[@"华漕8",@"爱博9",@"虹桥0"],@"嘉定区":@[@"华漕a",@"爱博b",@"虹桥c"],@"红桥区":@[@"华漕e",@"爱博f",@"虹桥g"],@"待选去":@[@"华漕h",@"爱博i",@"虹桥j"],@"带看区":@[@"华漕k",@"爱博l",@"虹桥m"],@"业绩好区":@[@"华漕n",@"爱博o",@"虹桥p"],@"房子多区":@[@"华漕q",@"爱博r",@"虹桥s"],@"路远区":@[@"华漕t",@"爱博x",@"虹桥y"],@"汉字区":@[@"华漕z",@"爱博1a",@"虹桥2a"],@"闸北区":@[@"华漕3a",@"爱博4a",@"虹桥5a"],@"无名区":@[@"华漕6a",@"爱博7a",@"虹桥"],@"不限":@[]}];
//    return @[kv];
    NSDictionary<NSString *,NSArray<NSString *> *> *kv = @{@"区域":@[@"闸北",@"宝山"],
                                                           @"地铁":@[@"1号线",@"2号线"]};
    NSDictionary<NSString *,NSArray<NSString *> *> *kv1 = @{@"闸北":@[@"闸北1",@"闸北2"],
                                                            @"1号线":@[@"1号线1"],
                                                            @"2号线":@[@"2号线1",@"2号线2",@"2号线3"],
                                                            @"宝山":@[@"宝山1",@"宝山2"]};
    return @[kv,kv1];
}

- (NSArray<NSString *> *)ash_filterView:(AshFilterView *)filterView listdatasAt:(NSInteger)tabIndex{
    NSArray<NSString *> *datas = @[];
    switch (tabIndex) {
        case 0:
            break;
        case 1:
            datas = self.singleListDatas;
            break;
        case 2:
            datas = self.multiListDatas;
            break;
            
        default:
            break;
    }
    return datas;
}

- (UIView *)ash_filterView:(AshFilterView *)filterView customizedViewAt:(NSInteger)tabIndex{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width * (9./16))];
    imageView.backgroundColor = [UIColor redColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://ashit.qiniudn.com/football.png"]];
    return imageView;
}

- (AshFilterViewType_t)ash_filterView:(AshFilterView *)filterView preferredTypAt:(NSInteger)tabIndex{
    switch (tabIndex) {
        case 0:
            return kAshFilterViewTypeHierarchy;
            break;
        case 1:
            return kAshFilterViewTypeSingleList;
            break;
        case 2:
            return kAshFilterViewTypeMultipleList;
            break;
        default:
            return kAshFilterViewTypeCustomized;
            break;
    }
}
@end
