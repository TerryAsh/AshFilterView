//
//  AshFilterView+ListView.m
//  Pods
//
//  Created by 陈震 on 2017/8/2.
//
//

#import "AshFilterView+ListView.h"

NSString * const kAshFilterViewListCellID = @"AshFilterViewListCellID";

@implementation AshFilterView (ListView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRows = 0;
    numOfRows = [self _listDatas].count;
    return numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAshFilterViewListCellID];
    cell.textLabel.text = [self _listDatas][indexPath.row];
    
    NSMutableArray<NSNumber *> * selectedItems = [self _selectedItems];
    if ([selectedItems containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray<NSNumber *> * selectedItems = [self _selectedItems];
    
    if (kAshFilterViewTypeSingleList == [self _currentListType]) {
        if (![selectedItems containsObject:@(indexPath.row)]) {
            [selectedItems removeAllObjects];
            [selectedItems addObject:@(indexPath.row)];
        }
        [tableView reloadData];
    } else {
        if (![selectedItems containsObject:@(indexPath.row)]) {
            [selectedItems addObject:@(indexPath.row)];
        }else {
            [selectedItems removeObject:@(indexPath.row)];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma private
- (NSArray<NSString *> *)_listDatas{
    NSArray<NSString *> *datas = @[];
    if ([self.dataSource respondsToSelector:@selector(ash_filterView:listdatasAt:)]) {
        datas = [self.dataSource ash_filterView:self listdatasAt:_selectedIndex];
    }
    return datas;
}

- (NSMutableArray<NSNumber *> *)_selectedItems{
   return  _selectedListEntries[_selectedIndex];
}

- (AshFilterViewType_t)_currentListType{
    return _types[_selectedIndex];
}

@end
