//
//  KKLiveTelecastViewController.m
//  yunbaolive
//
//  Created by Peter on 2021/10/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLivebroadcastController.h"

#import "KKLiveTelecastView.h"

//#import <DeviceCheck/DeviceCheck.h>

@interface KKLivebroadcastController ()<KKLiveTelecastViewDelegate>

@end

@implementation KKLivebroadcastController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =nil;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    KKLiveTelecastView *kkview = [[KKLiveTelecastView alloc]init];
    [self.view addSubview:kkview];
    [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    kkview.kkDelegate = self;
    [kkview kkInitPreview];

}

//关闭预览
- (void)kkClosePreView
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)kkPresentAlertContro:(UIViewController *)alert
{
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

//关闭直播间
- (void)kkCloseLiveRoom
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
