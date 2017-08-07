//
//  AshHierarchyListView.h
//  Pods
//
//  Created by 陈震 on 2017/7/31.
//
//

#import <UIKit/UIKit.h>

@protocol AshHierarchyListViewDelegate;

@interface AshHierarchyListView : UIView

@property (nonatomic ,copy) NSArray<NSDictionary<NSString* ,NSArray<NSString *> *> *> * datas;
@property (nonatomic ,weak) id<AshHierarchyListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end

@protocol AshHierarchyListViewDelegate <NSObject>

- (void)onAshHierarchyListView:(AshHierarchyListView *) hierarchyView didSelectItems:(NSArray *)items;

@end