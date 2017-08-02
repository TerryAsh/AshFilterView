//
//  AshFilterView+CollectionView.m
//  Pods
//
//  Created by 陈震 on 2017/7/31.
//
//

#import "AshFilterView+CollectionView.h"
#import <ChameleonFramework/Chameleon.h>

NSString * kCollectionCellID = @"kCollectionCellID";
static NSInteger kCellButtonTag = 1023;

@implementation AshFilterView (CollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numberOfTab = _numOfTabs;
    return numberOfTab;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID
                                                                           forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor flatWhiteColor];
    
    UIButton *btn = [cell viewWithTag:kCellButtonTag];
    if (nil == btn) {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [btn setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor flatOrangeColor] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [cell addSubview:btn];
        btn.tag = kCellButtonTag;
        [cell addSubview:btn];
    }
    
    NSString *title = @"";
    if ([self.dataSource respondsToSelector:@selector(ash_filterView:titleForTab:)]) {
        title = [self.dataSource ash_filterView:self titleForTab:indexPath.row];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.selected = (indexPath.row == _selectedIndex);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.needsHideBottom = NO;
    _selectedIndex = indexPath.row;
   [collectionView reloadData];
    [self scrollTo:indexPath.row];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfTab = 0;
    if ([self.dataSource respondsToSelector:@selector(ash_filterViewNumberOfTabs:)]) {
        numberOfTab = [self.dataSource ash_filterViewNumberOfTabs:self];
    }
    CGFloat cellWidth = 0;
    if (numberOfTab) {
        cellWidth = self.frame.size.width / numberOfTab;
    }
    return (CGSize){cellWidth - .5,_tabbar.frame.size.height};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return .5f;
}

@end
