//
//  AshFilterView.h
//  Pods
//
//  Created by 陈震 on 2017/7/28.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kAshFilterViewTypeCustomized = 1,
    kAshFilterViewTypeSingleList,
    kAshFilterViewTypeMultipleList,
    kAshFilterViewTypeHierarchy,
    kAshFilterViewTypeCollection,
} AshFilterViewType_t;

@protocol AshFilterViewDelegate;
@protocol AshFilterViewDataSource;

@interface AshFilterView : UIView{
    @private
    UIView *_containerView;
    UICollectionView *_tabbar;
    NSInteger _numOfTabs;
    NSMutableArray<NSMutableArray<NSNumber *> *> *_selectedListRows;
    AshFilterViewType_t _types[1024];
}
@property (readonly) NSInteger selectedTabIndex;
@property (nonatomic ,weak) id<AshFilterViewDelegate> delegate;
@property (nonatomic ,weak) id<AshFilterViewDataSource> dataSource;
@property (nonatomic ,assign) BOOL needsHideBottom;
//desinated
- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadTabbar;
- (void)reloadData;

- (void)scrollTo:(NSInteger) index;

@end

@protocol AshFilterViewDelegate <NSObject>

@optional
- (void)ash_filterView:(AshFilterView *) filterView
   didSelectedListRowNumbers:(NSArray<NSNumber *> *) selectedRowNumbers;

- (void)ash_filterView:(AshFilterView *) filterView
didSelectedHierarchyItems:(NSArray<NSString *> *) selectedItems;

@end

@protocol AshFilterViewDataSource<NSObject>

@required
- (NSInteger)ash_filterViewNumberOfTabs:(AshFilterView *) filterView ;

- (NSString *)ash_filterView:(AshFilterView *) filterView titleForTab:(NSInteger) tabIndex;

- (AshFilterViewType_t)ash_filterView:(AshFilterView *) filterView
                     preferredTypAt:(NSInteger)tabIndex;

- (UIView *)ash_filterView:(AshFilterView *) filterView
          customizedViewAt:(NSInteger)tabIndex;

- (NSArray<NSDictionary<NSString* ,NSArray<NSString *> *> *> *)ash_filterView:(AshFilterView *) filterView
                                                             hierarchyDatasAt:(NSInteger)tabIndex;

- (NSArray<NSString *> *)ash_filterView:(AshFilterView *) filterView
                              listdatasAt:(NSInteger)tabIndex;

@end
