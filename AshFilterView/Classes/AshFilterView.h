//
//  AshFilterView.h
//  Pods
//
//  Created by 陈震 on 2017/7/28.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
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
    NSInteger _selectedIndex;
    NSMutableArray<NSMutableArray<NSNumber *> *> *_selectedListEntries;
    AshFilterViewType_t _types[1024];
}

@property (nonatomic ,weak) id<AshFilterViewDelegate> delegate;
@property (nonatomic ,weak) id<AshFilterViewDataSource> dataSource;
@property (nonatomic ,assign) BOOL needsHideBottom;
//desinated
- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData;

- (void)scrollTo:(NSInteger) index;

@end

@protocol AshFilterViewDelegate <NSObject>

@end

@protocol AshFilterViewDataSource<NSObject>

@required
- (NSInteger)ash_filterViewNumberOfTabs:(AshFilterView *) filterView ;

- (NSString *)ash_filterView:(AshFilterView *) filterView titleForTab:(NSInteger) tabIndex;

- (AshFilterViewType_t)ash_filterView:(AshFilterView *) filterView
                     preferredTypAt:(NSInteger)tabIndex;

- (NSArray<NSDictionary<NSString* ,NSArray<NSString *> *> *> *)ash_filterView:(AshFilterView *) filterView
                                                             hierarchyDatasAt:(NSInteger)tabIndex;

- (NSArray<NSString *> *)ash_filterView:(AshFilterView *) filterView
                              listdatasAt:(NSInteger)tabIndex;

@end
