//
//  AshViewController.m
//  AshFilterView
//
//  Created by Ash on 07/28/2017.
//  Copyright (c) 2017 Ash. All rights reserved.
//

#import "AshViewController.h"
#import <AshFilterView/AshFilterView.h>

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
    self.filterTabTitles = @[@"级连列表",@"单选列表",@"多选列表"];
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

- (AshFilterViewType_t)ash_filterView:(AshFilterView *)filterView preferredTypAt:(NSInteger)tabIndex{
    switch (tabIndex) {
        case 0:
            return kAshFilterViewTypeHierarchy;
            break;
        case 1:
            return kAshFilterViewTypeSingleList;
            break;
            
        default:
            return kAshFilterViewTypeMultipleList;
            break;
    }
}
@end
