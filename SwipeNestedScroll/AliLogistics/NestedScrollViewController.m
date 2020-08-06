//
//  NestedScrollViewController.m
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//  仿淘宝物流 滑动无卡顿 页面只嵌套view  方法简易

#import "NestedScrollViewController.h"
#import "NestedTableView.h"
#import <MAMapKit/MAMapKit.h>

@interface NestedScrollViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate>

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UITableView *tableView;

/** map */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSArray <MAPointAnnotation *> *annotations;

@end

#define TableEnterHeight 300//进入初始显示距离顶部的高
#define TableMinimumHeight 88//滑动到最底部的最小高度

@implementation NestedScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor greenColor];
    [self initUI];
}

- (void)initUI{
    
    [self.view addSubview:self.mapView];
    [self.mapView addAnnotations:self.annotations];
    
    _tableView=[[NestedTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    //设置透明色，保证在偏移量下面能看见mapView
    _tableView.backgroundColor = [UIColor clearColor];
    //设置滚动到底部固定tableView显示大小为100
    _tableView.contentInset = UIEdgeInsetsMake((self.view.frame.size.height - [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height  - TableMinimumHeight), 0, 0, 0);
    //设置进入界面tableview的显示高度
    _tableView.contentOffset = CGPointMake(0, -TableEnterHeight);
    
    [self showAnnotations];
    
    [self.view addSubview:self.closeBtn];
    
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y + TableEnterHeight;
    
    _tableView.backgroundColor =(offset > TableEnterHeight-([UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height + 44))?[UIColor whiteColor]:[UIColor clearColor];
    
//    CGFloat alpha = offset / TableEnterHeight;
//    alpha=(alpha >= 1.0)?1.0:alpha;
//    _tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self showAnnotations];
    }
}

/** 停止滑动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= 0){
        return;
    }
    //在这可以做类似缩放地图等操作
    [self showAnnotations];
}


- (void)showAnnotations{
    CGFloat bottomInset = self.view.frame.size.height + self.tableView.contentOffset.y;
    
    [self.mapView showAnnotations:self.mapView.annotations edgePadding:(UIEdgeInsetsMake(50, 50, bottomInset, 50)) animated:YES];
}



- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height, 50, 44)];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)closeViewClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor redColor];
        _mapView.rotateEnabled = NO;
        _mapView.rotateCameraEnabled= NO;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsUserLocation = NO;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (NSArray<MAPointAnnotation *> *)annotations {
    
    if (!_annotations) {
        NSMutableArray *arrayM = [NSMutableArray array];
        CLLocationCoordinate2D coordinates[3] = {{34.219169,108.893092}, {34.21775,108.893092}, {34.217608,108.890689}};
        
        for (int i = 0; i < 3; i++) {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinates[i];
            [arrayM addObject:annotation];
        }
        _annotations = [arrayM copy];
    }
    return _annotations;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"location";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.pinColor = MAPinAnnotationColorGreen;
        }
        return annotationView;
    }
    
    return nil;
}

@end
