//
//  LDSearchDeviceViewController.m
//  Thermometer
//
//  Created by apple on 2022/4/8.
//

#import "LDSearchDeviceViewController.h"


#import "KKLiveViewerViewController.h"
#define headerH 270
@interface LDSearchDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *kkInfoArr;
@property (nonatomic,strong) UILabel *kkFooterLab;

@property (nonatomic,weak) UIButton *connectBtn;



@end

@implementation LDSearchDeviceViewController

- (void)setIsHidenBackBtn:(BOOL)isHidenBackBtn
{
    _isHidenBackBtn = isHidenBackBtn;
    if (isHidenBackBtn) {
        self.returnBtn.hidden = isHidenBackBtn;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *kkbtn = [[UIButton alloc]init];
    [self.view addSubview:kkbtn];
    kkbtn.frame = CGRectMake(100, 200, 100, 100);
    [kkbtn setTitle:@"直播" forState:UIControlStateNormal];
    [kkbtn addTarget:self action:@selector(kkbtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)kkbtnClick
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kkClosePIPViewNotifi object:nil];
    
    KKLiveViewerViewController *player = [[KKLiveViewerViewController alloc]init];

    player.kkcurrentSelectItemIndex = self.kkSelectItemIndex;
    player.scrollarray = self.infoArray;
    player.playDoc = selectedDic;
    //已经请求到了第几页数据
    player.kkPageForLoadData = page;
//    player.kkRoomListInfoURL = @"Home.getFollow";

    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
}

@end
