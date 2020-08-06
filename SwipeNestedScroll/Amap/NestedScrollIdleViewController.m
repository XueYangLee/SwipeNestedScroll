//
//  NestedScrollIdleViewController.m
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//  仿高德地图 滑动有定点卡顿 嵌套viewController

#import "NestedScrollIdleViewController.h"
#import "NestedScrollIdleTopViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface NestedScrollIdleViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) NestedScrollIdleTopViewController *topVC;

@end

@implementation NestedScrollIdleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor greenColor];
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.mapView];
    
    [self addChildViewController:self.topVC];
    [self.shadowView addSubview:self.topVC.view];
    [self.view addSubview:self.shadowView];
    
    [self.view addSubview:self.closeBtn];
}


- (void)swipe:(UISwipeGestureRecognizer *)swipe{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.shadowView.frame.origin.y; // 这是上一次Y的位置
//    NSLog(@"==== === %f == =====",self.vc.table.contentOffset.y);

    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"==== down =====");
        
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.topVC.tableView.contentOffset.y == 0) {
            self.topVC.tableView.scrollEnabled = NO;
        }
        
        if (offsetY >= Y1 && offsetY < Y2) {
            // 停在y2的位置
            stopY = Y2;
        }else if (offsetY >= Y2 ){
            // 停在y3的位置
            stopY = Y3;
        }else{
            stopY = Y1;
        }
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"==== up =====");
        
        if (offsetY <= Y2) {
            // 停在y1的位置
            stopY = Y1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
            self.topVC.tableView.scrollEnabled = YES;
        }else if (offsetY > Y2 && offsetY <= Y3 ){
            // 停在y2的位置
            stopY = Y2;
        }else{
            stopY = Y3;
        }
        animateY = stopY - margin;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.shadowView.frame = CGRectMake(0, animateY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.topVC.offsetY = stopY;
}

/** 返回值为NO  swipe不响应手势 table响应手势 返回值为YES swipe、table也会响应手势, 但是把table的scrollEnabled为No就不会响应table了 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    NSLog(@"----------- table =  %f ------------",self.vc.table.contentOffset.y);
    // 触摸事件，一响应 就把searchBar的键盘收起来
    [self.topVC.searchBar resignFirstResponder];
    
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.topVC.tableView.scrollEnabled == YES && self.topVC.tableView.contentOffset.y != 0) {
        return NO;
    }
    if (self.topVC.tableView.scrollEnabled == YES) {
        return YES;
    }
    return NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.topVC.searchBar resignFirstResponder];
}


- (NestedScrollIdleTopViewController *)topVC{
    if (!_topVC) {
        _topVC=[[NestedScrollIdleTopViewController alloc]init];
//        _topVC.view.frame=CGRectMake(0, Y3, self.view.frame.size.width, self.view.frame.size.height);
        
        __weak typeof(self) weakSelf = self;
        _topVC.searchClick = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UIView animateWithDuration:0.4 animations:^{
                strongSelf.shadowView.frame = CGRectMake(0, 50, strongSelf.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
            }completion:^(BOOL finished) {
                // 呼出键盘。  一定要在动画结束后调用，否则会出错
                [strongSelf.topVC.searchBar becomeFirstResponder];
            }];
            // 更新offsetY
            strongSelf.topVC.offsetY = strongSelf.shadowView.frame.origin.y;
        };

        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;//设置手势方向
        swipeDown.delegate=self;
        [_topVC.tableView addGestureRecognizer:swipeDown];
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;//设置手势方向
        swipeUp.delegate=self;
        [_topVC.tableView addGestureRecognizer:swipeUp];
    }
    return _topVC;
}

-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, Y2, self.view.frame.size.width, self.view.frame.size.height);
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowRadius = 10;
        _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
        _shadowView.layer.shadowOpacity = 0.8;
    }
    return _shadowView;
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
    }
    return _mapView;
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




@end
