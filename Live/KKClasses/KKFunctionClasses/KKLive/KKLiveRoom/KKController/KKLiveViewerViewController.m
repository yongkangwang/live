//
//  KKLiveViewerViewController.m
//  yunbaolive
//
//  Created by Peter on 2021/3/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveViewerViewController.h"

#import "KKLiveRoomScrollView.h"
#import "KKHorizontalView.h"

#import "AppDelegate.h"

@interface KKLiveViewerViewController ()<KKLiveRoomScrollViewDelegate>
//横屏
@property(weak,nonatomic)KKHorizontalView *kkHorizontalView;

@property(weak,nonatomic)KKLiveRoomScrollView *kkRoomScrollView;
@property (nonatomic,assign) BOOL kkIsHorizontal;

@end

@implementation KKLiveViewerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkIsHorizontal = NO;
    
    KKLiveRoomScrollView *kkLiveContentV = [[KKLiveRoomScrollView alloc]init];
    self.kkRoomScrollView = kkLiveContentV;
    [self.view addSubview:kkLiveContentV];
    kkLiveContentV.kkDelegate = self;
    [kkLiveContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    kkLiveContentV.playDoc = self.playDoc;
    kkLiveContentV.scrollarray = self.scrollarray;
    kkLiveContentV.kkcurrentSelectItemIndex = self.kkcurrentSelectItemIndex;
    kkLiveContentV.kkLoadPage = self.kkPageForLoadData;
    kkLiveContentV.kkLiveType = self.kkLiveType;
    kkLiveContentV.kkLiveSportsClassID = self.kkLiveSportsClassID;
    [kkLiveContentV kkInitData];
    
    //
    [kkNotifCenter addObserver:self selector:@selector(kkVerticalBtnClick) name:kkVerticalBtnClickNotif object:nil];
    
}


//上下麦弹框
- (void)kkShowAlertMicrophone:(UIAlertController *)alert
{
    [self presentViewController:alert animated:YES completion:nil];
   
}
//横屏
- (void)kkPortraitBtnClick:(NSString *)str
{
    self.kkIsHorizontal = YES;

    [self kkStartAllowRevolve];
}



//切换到竖屏
- (void)kkVerticalBtnClick
{
    self.kkIsHorizontal = NO;

    AppDelegate *selfDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    selfDel.isAllowRevolve = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
//    [UIViewController attemptRotationToDeviceOrientation];
    [self.view layoutSubviews];

    [self.kkRoomScrollView kkShowPortrait];
}


//横屏
- (void)kkStartAllowRevolve
{

    AppDelegate *selfDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    selfDel.isAllowRevolve = YES;
  BOOL kkResult = [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self.view layoutSubviews];
    if (kkResult) {

        [self kkHorizontal];
    }
    
}

- (void)kkHorizontal
{
    if (!self.kkHorizontalView) {
        KKHorizontalView *kkHorizontalView = [[KKHorizontalView alloc]init];
        [self.view addSubview:kkHorizontalView];
        self.kkHorizontalView = kkHorizontalView;
    }
    self.kkHorizontalView.hidden = NO;
    self.kkHorizontalView.alpha = 1;

    [self.kkHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view);
        make.width.mas_equalTo(KKScreenWidth);
        make.height.mas_equalTo(KKScreenHeight);

    }];
        [self.kkRoomScrollView kkShowHorizontalView:self.kkHorizontalView];
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.kkIsHorizontal) {
        return (UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight);
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
//yes是正确返回
- (BOOL)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        return YES;
    }else{
        return NO;
    }
}



@end
