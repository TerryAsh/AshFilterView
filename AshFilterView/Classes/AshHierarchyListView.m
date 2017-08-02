//
//  AshMultiListView.m
//  Pods
//
//  Created by 陈震 on 2017/7/31.
//
//

#import "AshHierarchyListView.h"
#import "FrameAccessor.h"
static NSString *AshMultiListCellID = @"AshMultiListCellID";

@interface AshHierarchyListView()<UITableViewDelegate ,UITableViewDataSource>{
}

@property (nonatomic ,strong) NSMutableArray<UITableView *> *tables;
@property (nonatomic ,strong) NSMutableArray<NSString *> *selectedKeys;

@end

@implementation AshHierarchyListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _tables = [NSMutableArray new];
        _selectedKeys = [NSMutableArray new];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDatas:(NSArray<NSDictionary<NSString *,NSArray<NSString *> *> *> *)datas{
    _datas = datas.copy;
    
    //clear selected
    [self.selectedKeys removeAllObjects];
    for (int i = 0 ; i <= datas.count; i++) {
        [self.selectedKeys addObject:@""];
    }
    self.selectedKeys[0] = datas[0].allKeys[0];
    
    //clean old tables
    [self.tables enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.tables removeAllObjects];
    

    //build new tables
    
    for (NSInteger  i = 0; i <= datas.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.frame
                                                              style:UITableViewStylePlain];
        tableView.left = i * self.width * .5;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.tables addObject:tableView];
        
        [self addSubview:tableView];
        
    }
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tabIndex = [self.tables indexOfObject:tableView];
    if (tabIndex == 0) {
        return self.datas[0].allKeys.count;
    } else {
        NSString *selectedKey = self.selectedKeys[tabIndex - 1];
        if (selectedKey) {
            return self.datas[tabIndex - 1][selectedKey].count;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AshMultiListCellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:AshMultiListCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger tabIndex = [self.tables indexOfObject:tableView];
    NSString *selectedKey = self.selectedKeys[tabIndex];

    if (tabIndex == 0) {
        cell.textLabel.text = self.datas[tabIndex].allKeys[indexPath.row];
    } else {
        NSString * preSelectedKey = self.selectedKeys[tabIndex - 1];
        if (preSelectedKey) {
            NSArray<NSString *> * data = self.datas[tabIndex -1][preSelectedKey];
            cell.textLabel.text = data[indexPath.row];
        }
    }
    
    if ([selectedKey isEqualToString:cell.textLabel.text]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tabIndex = [self.tables indexOfObject:tableView];
    //reload selected rows
    if (0 == tabIndex) {
        self.selectedKeys[0] = self.datas[0].allKeys[indexPath.row];
    } else {
        NSString *selectedKey = self.selectedKeys[tabIndex - 1];
        if (selectedKey) {
            NSArray<NSString *> * data = self.datas[tabIndex -1][selectedKey];
            self.selectedKeys[tabIndex] = data[indexPath.row];
            for (int i = tabIndex  + 1 ; i < self.selectedKeys.count; i++) {
                self.selectedKeys[i] = @"";
            }
        }
    }
    [self.tables enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
    //animate
    CGFloat offset = self.width / (tabIndex + 2);
    if (tabIndex < self.tables.count - 1){
        if(self.tables[1].left != offset) {
            [self.tables enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.left = idx * offset;
                [obj reloadData];
            }];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
