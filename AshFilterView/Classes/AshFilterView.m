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
@synthesize selectedTabIndex = _selectedTabIndex;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect containerframe = self.containerView.frame;
        containerframe.size.height = frame.size.height - self.tabbar.frame.size.height;
        self.containerView.frame = containerframe;
        
        _selectedListRows = [NSMutableArray new];
    }
    return self;
}

- (void)reloadTabbar{
    [self.tabbar reloadData];
}

- (void)reloadData{
    _selectedTabIndex = - 1;
    [_selectedListRows removeAllObjects];
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    bzero(_types, sizeof(_types));
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:preferredTypAt:)]) {
        _numOfTabs = [self.dataSource ash_filterViewNumberOfTabs:self] ;
        UIView *subView = nil;
        for (int i = 0 ; i < _numOfTabs; i++) {
            _selectedListRows[i] = [NSMutableArray new];
            
            //add sub view
            _types[i] = [self.dataSource ash_filterView:self preferredTypAt:i];
            switch (_types[i]) {
                case kAshFilterViewTypeMultipleList:
                case kAshFilterViewTypeSingleList:{
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:listdatasAt:)]) {
                        NSArray<NSString *> * datas = [self.dataSource ash_filterView:self listdatasAt:i];
                        subView = [self _createListTableContainer];
                    }
                }
                    break;
                case kAshFilterViewTypeHierarchy:{
                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ash_filterView:hierarchyDatasAt:)]) {
                        NSArray<NSDictionary<NSString * ,NSArray<NSString *> *> *> * datas = [self.dataSource ash_filterView:self hierarchyDatasAt:i];
                        AshHierarchyListView *hirarchyList = [self _createHierarchyTable];
                        hirarchyList.datas = datas;
                        subView = hirarchyList;
                    }
                }
                    break;
                case kAshFilterViewTypeCollection:
                    break;
                case kAshFilterViewTypeCustomized:{
                    if (self.dataSource &&
                            [self.dataSource respondsToSelector:@selector(ash_filterView:customizedViewAt:)]) {
                        subView = [self.dataSource ash_filterView:self customizedViewAt:i];
                    }
                }
                    break;
                default:
                    break;
            }
            //
            subView.tag = kAshFilterSubListTag + i;
            subView.hidden = (i != 0);
            [self.containerView addSubview:subView];
        }
    }
    
    [self scrollTo:0];
}
- (void)scrollTo:(NSInteger)index{
    if (index >= _numOfTabs || index == _selectedTabIndex) {
        return;
    }
    UIView *currentView =[self.containerView viewWithTag:(kAshFilterSubListTag + _selectedTabIndex)];
    currentView.hidden = YES;
    
    _selectedTabIndex = index;
    UIView *dstView =[self.containerView viewWithTag:(kAshFilterSubListTag + index)];
    dstView.hidden = NO;
    [self.containerView bringSubviewToFront:dstView];
    
    AshFilterViewType_t viewStyle = _types[index];
    switch (viewStyle) {
        case kAshFilterViewTypeMultipleList:
        case kAshFilterViewTypeSingleList:{
            [dstView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj respondsToSelector:@selector(reloadData)]) {
                    [obj performSelector:@selector(reloadData)];
                    *stop = YES;
                }
            }];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark private

- (AshHierarchyListView *)_createHierarchyTable{
    CGRect frame = self.containerView.frame;
    frame.size.height *= .5;
    frame.origin.y = 0;
    AshHierarchyListView *multiListView = [[AshHierarchyListView alloc] initWithFrame:frame];
    return multiListView;
}

- (UIView *)_createListTableContainer{
    CGRect frame = self.containerView.frame;
    frame.size.height *= .5;
    frame.origin.y = 0;
    UIView *container = [[UIView alloc] initWithFrame:frame];
    
    UITableView *listView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    listView.height -= 60;
    listView.dataSource = self;
    listView.delegate = self;
    [listView registerClass:[UITableViewCell class]
     forCellReuseIdentifier:kAshFilterViewListCellID];
    [container addSubview:listView];
    
    UIButton *ensureButton = [self _createEnsureButton];
    ensureButton.top = listView.bottom;
    [container addSubview:ensureButton];

    return container;
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

#pragma mark private
- (UIButton *)_createEnsureButton{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(onPressedEnsureBtn:)
  forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    return btn;
}

#pragma mark --handler
- (void)onPressedContainer{
    self.needsHideBottom = YES;
}

- (void)onPressedEnsureBtn:(UIButton *) btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ash_filterView:didSelectedListRowNumbers:)]) {
        NSArray<NSNumber *> *selectedRowAtCertainTab = _selectedListRows[_selectedTabIndex];
        [self.delegate ash_filterView:self
            didSelectedListRowNumbers:selectedRowAtCertainTab];
    }
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
