//
//  AshHierarchyListView.h
//  Pods
//
//  Created by 陈震 on 2017/7/31.
//
//

#import <UIKit/UIKit.h>

@interface AshHierarchyListView : UIView

@property (nonatomic ,copy) NSArray<NSDictionary<NSString* ,NSArray<NSString *> *> *> * datas;

- (instancetype)initWithFrame:(CGRect)frame;

@end
