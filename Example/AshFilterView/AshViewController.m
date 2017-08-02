//
//  AshViewController.m
//  AshFilterView
//
//  Created by Ash on 07/28/2017.
//  Copyright (c) 2017 Ash. All rights reserved.
//

#import "AshViewController.h"
@import AshFilterView;

@interface AshViewController ()<AshFilterViewDataSource>

@property (nonatomic ,strong) AshFilterView *filterView;
@property (nonatomic ,strong) NSArray<NSString *> *filterTabTitles;

@end

@implementation AshViewController

- (AshFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[AshFilterView alloc] initWithFrame:self.view.frame];
        _filterView.dataSource = self;
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.filterTabTitles = @[@"级连列表",@"单选列表",@"多选列表"];
    [self.view addSubview:self.filterView];
    
    [self.filterView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate
#pragma mark delegate
- (NSInteger)ash_filterViewNumberOfTabs:(AshFilterView *)filterView{
    return self.filterTabTitles.count;
}

- (NSString *)ash_filterView:(AshFilterView *) filterView titleForTab:(NSInteger) tabIndex{
    return  self.filterTabTitles[tabIndex];
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
            datas = @[@"1",@"2",@"3"];
            break;
        case 2:
            datas = @[@"a",@"b",@"c",@"d",@"e"];
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
