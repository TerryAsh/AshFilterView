//
//  AshFilterView.m
//  Pods
//
//  Created by 陈震 on 2017/7/28.
//
//

#import "AshFilterView.h"
#import "AshFilterView+CollectionView.h"
#import "AshFilterView+ListView.h"
#import "AshHierarchyListView.h"
#import "FrameAccessor.h"
#define kAshFilterSubListTag 1002

@interface AshFilterView()<UIGestureRecognizerDelegate>
{
}

@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,readonly) UICollectionView *tabbar;

@end

@implementation AshFilterView
@synthesize tabbar = _tabbar;
@synthesize containerView = _containerView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect containerframe = self.containerView.frame;
        containerframe.size.height = frame.size.height - self.tabbar.frame.size.height;
        self.containerView.frame = containerframe;
        
        _selectedListEntries = [NSMutableArray new];
    }
    return self;
}

- (void)reloadData{
    [_selectedListEntries removeAllObjects];
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    bzero(_types, sizeof(_types));
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:preferredTypAt:)]) {
        _numOfTabs = [self.dataSource ash_filterViewNumberOfTabs:self] ;
        for (int i = 0 ; i < _numOfTabs; i++) {
            _selectedListEntries[i] = [NSMutableArray new];
            
            //add sub view
            _types[i] = [self.dataSource ash_filterView:self preferredTypAt:i];
            switch (_types[i]) {
                case kAshFilterViewTypeMultipleList:
                case kAshFilterViewTypeSingleList:{
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:listdatasAt:)]) {
                        NSArray<NSString *> * datas = [self.dataSource ash_filterView:self listdatasAt:i];
                        UITableView *listView = [self _createListTable];
                        listView.tag = kAshFilterSubListTag + i;
                    }
                }
                    break;
                case kAshFilterViewTypeHierarchy:{
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:hierarchyDatasAt:)]) {
                        NSArray<NSDictionary<NSString * ,NSArray<NSString *> *> *> * datas = [self.dataSource ash_filterView:self hierarchyDatasAt:0];
                        AshHierarchyListView *hirarchyList = [self _createHierarchyTable];
                        hirarchyList.datas = datas;
                        hirarchyList.tag = kAshFilterSubListTag + i;
                    }
                }
                    break;
                case kAshFilterViewTypeCollection:
                    break;
                default:
                    break;
            }
            //
        }
    }
    
    [self scrollTo:0];
}
- (void)scrollTo:(NSInteger)index{
    if (index >= _numOfTabs) {
        return;
    }
    _selectedIndex = index;
    UIView *dstView =[self.containerView viewWithTag:(kAshFilterSubListTag + index)];
    if ([dstView respondsToSelector:@selector(reloadData)]) {
        [dstView performSelector:@selector(reloadData)];
    }
    [self.containerView bringSubviewToFront:dstView];
}

#pragma mark private

- (AshHierarchyListView *)_createHierarchyTable{
    CGRect frame = self.containerView.frame;
    frame.size.height *= .5;
    frame.origin.y = 0;
    AshHierarchyListView *multiListView = [[AshHierarchyListView alloc] initWithFrame:frame];
    [self.containerView addSubview:multiListView];
    return multiListView;
}

- (UITableView *)_createListTable{
    CGRect frame = self.containerView.frame;
    frame.size.height *= .5;
    frame.origin.y = 0;
    UITableView *listView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    listView.dataSource = self;
    listView.delegate = self;
    [listView registerClass:[UITableViewCell class]
     forCellReuseIdentifier:kAshFilterViewListCellID];
    [self.containerView addSubview:listView];
    return listView;
}

#pragma mark getter setter

- (UIView *)containerView{
    if (!_containerView) {
        CGFloat tabbarHeight = self.tabbar.frame.size.height;
        CGRect frame = CGRectMake(0, tabbarHeight, self.frame.size.width, 55);
        _containerView = [[UIView alloc] initWithFrame:frame];
        _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onPressedContainer)];
        rec.numberOfTouchesRequired = 1;
        rec.delegate = self;
        [_containerView addGestureRecognizer:rec];
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UICollectionView *)tabbar{
    if (!_tabbar) {
        CGRect collectFrame = CGRectMake(0, 0, self.frame.size.width, 55);
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _tabbar = [[UICollectionView alloc] initWithFrame:collectFrame collectionViewLayout:layout];
        _tabbar.backgroundColor = [UIColor lightGrayColor];
        [_tabbar registerClass:[UICollectionViewCell class]
    forCellWithReuseIdentifier:kCollectionCellID];
        _tabbar.delegate = self;
        _tabbar.dataSource = self;
        [self addSubview:_tabbar];
    }
    return _tabbar;
}

- (void)setNeedsHideBottom:(BOOL)needsHideBottom{
    if (_needsHideBottom == needsHideBottom) {
        return;
    } else {
        _needsHideBottom = needsHideBottom;
    }
    if (needsHideBottom) {
        [UIView animateWithDuration:.2 animations:^{
            self.containerView.alpha = 0.;
        } completion:^(BOOL finished) {
            self.containerView.hidden = YES;
            self.height = self.tabbar.height;
        }];
    } else {
        self.containerView.hidden = NO;
        self.height = self.tabbar.height + self.containerView.height;
        [UIView animateWithDuration:.2 animations:^{
            self.containerView.alpha = 1.;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)setDataSource:(id<AshFilterViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self.tabbar reloadData];
}

#pragma mark --handler
- (void)onPressedContainer{
    self.needsHideBottom = YES;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return [touch.view isEqual:self.containerView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
