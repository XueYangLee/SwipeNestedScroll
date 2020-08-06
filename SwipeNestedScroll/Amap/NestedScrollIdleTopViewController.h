//
//  NestedScrollIdleTopViewController.h
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define Y1  50
#define Y2  self.view.frame.size.height - 250
#define Y3  self.view.frame.size.height - 64

@interface NestedScrollIdleTopViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,assign) CGFloat offsetY;//shadowView在第一个视图中的位置 就3个位置：Y1 Y2 Y3;offsetY初始值为0 无所谓 不影响结果

@property (nonatomic,copy) void(^searchClick)(void);

@end

NS_ASSUME_NONNULL_END
