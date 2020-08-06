//
//  NestedScrollIdleTopViewController.m
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NestedScrollIdleTopViewController.h"

@interface NestedScrollIdleTopViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>


@end

@implementation NestedScrollIdleTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 10;
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    cell.textLabel.text=@(indexPath.row).stringValue;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"swipeLine"]];
    image.frame=CGRectMake((view.frame.size.width-40)/2, 0, 40, 20);
    [view addSubview:image];
    
    [view addSubview:self.searchBar];
    
    return view;
}

/** 注意一定要懒加载 */
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-Y1) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.scrollEnabled = NO; // 让table默认禁止滚动
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 44)];
        _searchBar.placeholder=@"search";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.barTintColor = [UIColor whiteColor];
        [_searchBar sizeToFit];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (!self.offsetY) {
        self.offsetY = Y3;
    }
    // 如果点击时，shadowView的y坐标 在Y2 Y3的位置
    if (self.offsetY > Y1) {
        if (self.searchClick) {
            self.searchClick();
        }
        return false;
    }
    return true;
}


@end
