//
//  KKUserInfoView.m
//  yunbaolive
//
//  Created by Peter on 2021/6/10.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKUserInfoView.h"


#import "Config.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

#import <AVFoundation/AVFoundation.h>

#import "ListCollection.h"
#import "SDCycleScrollView.h"

#import "KKLiveRoomBottomFunctionModel.h"

#import "KKHorizontalScrollTextView.h"
#import "KKLiveRoomRankAlertView.h"
#import "KKAlertH5WebView.h"
#import "KKLiveRoomActivityView.h"

#import "KKWebH5ViewController.h"

//38.66
#define kkleftViewH 30
#define kkOnLinePersonBtnW 35


@interface KKUserInfoView ()<listDelegate>

@property(nonatomic,weak)UIButton *ZheZhaoBTN;//遮罩层

@property(nonatomic,weak)UIView *leftView;//左上角信息
@property(nonatomic,weak)UIButton *newattention;
@property(weak,nonatomic)UIImageView *kkUserIconImgV;
@property(weak,nonatomic)UILabel *kkUserNameLab;
@property(nonatomic,weak)UILabel *kkUserIDLab;

//关闭直播间按钮
@property(weak,nonatomic)UIButton *kkRoomCloseBtn;
//在线人数
@property(weak,nonatomic)UIButton *kkOnLinePersonBtn;

@property(weak,nonatomic)ListCollection *kkRoomPersonListView;

//活动
@property(weak,nonatomic)KKLiveRoomActivityView *kkActivityView;


@property(weak,nonatomic)KKHorizontalScrollTextView *kkChatScrollTextV;


@property(weak,nonatomic)UIView *kkLiveTimeV;
@property(weak,nonatomic)UIView *kkLiveTimeRedDotV;
@property(weak,nonatomic)UILabel *kkLiveTimeLab;//
@property (nonatomic,assign) int kkkLiveTimeNum;

@property (nonatomic,assign) NSInteger kkIsAttention;



@end

@implementation KKUserInfoView

-(void)kkIsAttention:(NSString *)isAttention
{
    if ([isAttention isEqual:@"0"]) {
        //未关注
        self.kkIsAttention = 0;
        [_newattention setBackgroundImage:[UIImage imageNamed:@"KKLiveRoom_userInfo_attention"] forState:UIControlStateNormal];
    }
    else{
        //关注
        self.kkIsAttention = 1;
        [self.newattention setBackgroundImage:[UIImage imageNamed:@"KKLiveRoom_userInfo_guard"] forState:UIControlStateNormal];

    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.kkkLiveTimeNum = 0;
        //添加子控件
        [self kkInitView];

    }
    return self;
}


- (void)kkInitView
{
    
    //添加遮罩层
    UIButton *ZheZhaoBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    self.ZheZhaoBTN = ZheZhaoBTN;
    _ZheZhaoBTN.backgroundColor = [UIColor clearColor];
    [_ZheZhaoBTN addTarget:self action:@selector(zhezhaoBTN) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ZheZhaoBTN];//添加遮罩

    UIView *leftView = [[UIView alloc]init];
    self.leftView = leftView;
    [self addSubview:leftView];
    _leftView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [_leftView addGestureRecognizer:tapleft];
    
    //关注主播
    UIButton *newattention = [UIButton buttonWithType:UIButtonTypeCustom];
    self.newattention = newattention;
    [self.leftView addSubview:newattention];
    [_newattention setBackgroundImage:[UIImage imageNamed:@"KKLiveRoom_userInfo_attention"] forState:UIControlStateNormal];
    [_newattention addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *kkUserIconImgV  = [[UIImageView alloc]init];
    self.kkUserIconImgV = kkUserIconImgV;
    kkUserIconImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.leftView addSubview:kkUserIconImgV];
    
    UILabel *kkUserNameLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkUserNameLab = kkUserNameLab;
    [self.leftView addSubview:kkUserNameLab];
    
    UILabel *kkUserIDLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#C5BEBE"] textFont:kkFontRegularMT(7) andTextAlignment:NSTextAlignmentLeft];
    self.kkUserIDLab = kkUserIDLab;
    [self.leftView addSubview:kkUserIDLab];

    
    UIButton *kkRoomCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:kkRoomCloseBtn];
    self.kkRoomCloseBtn = kkRoomCloseBtn;
    [kkRoomCloseBtn setImage:[UIImage imageNamed:@"KKLive_SecondPage_RoomClose"] forState:UIControlStateNormal];
    [kkRoomCloseBtn addTarget:self action:@selector(kkRoomCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    kkRoomCloseBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);

    UIButton *kkOnLinePersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:kkOnLinePersonBtn];
    self.kkOnLinePersonBtn = kkOnLinePersonBtn;
    [kkOnLinePersonBtn addTarget:self action:@selector(kkOnLinePersonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    kkOnLinePersonBtn.backgroundColor = [KKBlackTitleLabColor colorWithAlphaComponent:0.2];//设置父视图透明而子视图不受影响
    [kkOnLinePersonBtn setTitleColor:KKWhiteColor forState:UIControlStateNormal];
    kkOnLinePersonBtn.titleLabel.font = kkFontBoldMT(13.33);
    
    
    
    ListCollection *kkRoomPersonListView = [[ListCollection alloc]initWithListArray:[NSMutableArray array] andID:[self.zhuboDic valueForKey:@"uid"] andStream:[NSString stringWithFormat:@"%@",[self.zhuboDic valueForKey:@"stream"]]];
    self.kkRoomPersonListView = kkRoomPersonListView;
    [self addSubview:kkRoomPersonListView];
    kkRoomPersonListView.delegate = self;
        
    KKLiveRoomActivityView * kkActivityView = [[KKLiveRoomActivityView alloc]init];
    self.kkActivityView = kkActivityView;
    [self addSubview:kkActivityView];
    
    [self kkInitHorizontalScrollTextView];
    
    
    UIView * kkLiveTimeV= [[UIView alloc]init];
    self.kkLiveTimeV = kkLiveTimeV;
    [self addSubview:kkLiveTimeV];
    kkLiveTimeV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];

    kkLiveTimeV.hidden = YES;
    
    UIView *kkLiveTimeRedDotV = [[UIView alloc]init];
    self.kkLiveTimeRedDotV = kkLiveTimeRedDotV;
    [kkLiveTimeV addSubview:kkLiveTimeRedDotV];
    kkLiveTimeRedDotV.backgroundColor = normalColors;

    
    UILabel *kkLiveTimeLab = [[UILabel alloc]init];
    self.kkLiveTimeLab = kkLiveTimeLab;
    [kkLiveTimeV addSubview:kkLiveTimeLab];
    kkLiveTimeLab.textColor = [UIColor whiteColor];
    kkLiveTimeLab.font = [UIFont systemFontOfSize:10];
    kkLiveTimeLab.textAlignment = NSTextAlignmentCenter;
    kkLiveTimeLab.text = @"00:00";

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.ZheZhaoBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(kkStatusbarH + 10);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(kkleftViewH);
    }];
    self.leftView.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:kkleftViewH/2 fromView:self.leftView];

    [self.newattention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.centerY.mas_equalTo(self.leftView);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(22);
    }];
    
    [self.kkUserIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.centerY.mas_equalTo(self.leftView);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(26);
    }];
    self.kkUserIconImgV.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:13 fromView:self.kkUserIconImgV];

    
    [self.kkUserNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserIconImgV.mas_right).mas_offset(4);
        make.top.mas_equalTo(self.kkUserIconImgV.mas_top);//6
        make.right.mas_equalTo(self.newattention.mas_left).mas_offset(-5);
        make.height.mas_equalTo(12);
    }];
    
    [self.kkUserIDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserNameLab);
        make.bottom.mas_equalTo(self.kkUserIconImgV.mas_bottom);
        make.height.mas_equalTo(8);
    }];
    
    
    [self.kkRoomCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(self.leftView);
        make.height.width.mas_equalTo(44);
    }];
    
    [self.kkOnLinePersonBtn mas_makeConstraints:^(MASConstraintMaker *make) {          make.right.mas_equalTo(self.kkRoomCloseBtn.mas_left).mas_offset(-3);//14
        make.centerY.mas_equalTo(self.kkRoomCloseBtn);
        make.height.mas_equalTo(kkOnLinePersonBtnW);
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);

    }];

    
    [self.kkRoomPersonListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRoomCloseBtn);
        make.left.mas_equalTo(self.leftView.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.kkOnLinePersonBtn.mas_left).mas_offset(-5);
        make.height.mas_equalTo(40);
    }];
    
    [self.kkActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkRoomPersonListView.mas_bottom).mas_offset((3));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.kkChatScrollTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(24);
    }];
    
    
    
    [self.kkLiveTimeV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.leftView);
        make.height.mas_equalTo(20);
    }];
    
    [self.kkLiveTimeRedDotV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.kkLiveTimeV);
        make.width.height.mas_equalTo(3);
    }];
    [self.kkLiveTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkLiveTimeRedDotV.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.kkLiveTimeV);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.kkLiveTimeV.mas_right).mas_offset(-10);
    }];

}


- (void)kkLiveGroupChatNewMessage:(NSNotification *)not{
    NSDictionary *dic = [not object];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [self.kkChatScrollTextV kkAddTextMove:dic];
    }
}

- (void)kkInitHorizontalScrollTextView
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kkLiveGroupChatNewMessage:) name:KKLiveGroupMessageID object:nil];

    KKHorizontalScrollTextView *kkChatScrollTextV = [[KKHorizontalScrollTextView alloc]init];
    self.kkChatScrollTextV = kkChatScrollTextV;
    [self addSubview:kkChatScrollTextV];
    kkChatScrollTextV.hidden = YES;
    
}



- (void)setKkIsRefreshUserList:(BOOL)kkIsRefreshUserList
{
    _kkIsRefreshUserList = kkIsRefreshUserList;
    [self.kkRoomPersonListView listReloadNoew];

}
-(void)kkUserAccess:(NSDictionary *)dic
{
    [self.kkRoomPersonListView userAccess:dic];
}
-(void)kkUserLeave:(NSDictionary *)dic
{
    [self.kkRoomPersonListView userLive:dic];
}

- (void)setKkRoomPersonArr:(NSMutableArray *)kkRoomPersonArr
{
    _kkRoomPersonArr = kkRoomPersonArr;
    [self.kkRoomPersonListView listarrayAddArray:kkRoomPersonArr];
}


//点击关注主播
-(void)guanzhuzhubo{
    
    if (self.kkIsLive) {
        [MBProgressHUD kkshowMessage:@"主播不能关注自己"];
        return;
    }
    if (self.kkIsAttention) {
        [self kkLiveGuardShow];
        return;
    }
    
   
    
}


- (void)kkLiveGuardShow
{
    KKAlertH5WebView *kkBarrageWebView = [[KKAlertH5WebView alloc]init];
    [[self superview] addSubview:kkBarrageWebView];
    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=zshouhu"];
    kkurl = [NSString kk_AppendH5URL:kkurl];
    kkBarrageWebView.kkUrls = kkurl;
    [kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([self superview]);
    }];

}

//改变左上角 映票数量
-(void)changeState:(NSString *)texts{
    
    [self.zhuboDic setValue:texts forKey:@"votestotal"];
    
    NSString *kkyingPiao = @"";
    CGFloat  kkTicketNum = [texts integerValue]/10000;
     if (kkTicketNum >= 1) {
         kkyingPiao = [NSString stringWithFormat:@"%.1f万",kkTicketNum];
     }else{
         kkyingPiao = [NSString stringWithFormat:@"%@",texts];
     }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",[common name_votes],kkyingPiao];

//    _yingpiaoLabel.text = str;

}

//改变直播间人数量
-(void)kkChangeLookVideoPersionNum:(long long )persionNums
{
    CGFloat kkOnLineNum = persionNums/10000;
    if (kkOnLineNum >= 1) {
        [self.kkOnLinePersonBtn setTitle:[NSString stringWithFormat:@"%.1fw",kkOnLineNum ] forState:UIControlStateNormal];
        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];

    }else{
        [self.kkOnLinePersonBtn setTitle:[NSString stringWithFormat:@"%lld",persionNums ] forState:UIControlStateNormal];

        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];
    }
}


//在线人数点击事件，暂时不做
- (void)kkOnLinePersonBtnClick
{
    if ([self.frontviewDelegate respondsToSelector:@selector(kkOnLinePersonBtnClick)]) {
        [self.frontviewDelegate kkOnLinePersonBtnClick];
    }
}
- (void)kkRoomCloseBtnClick
{
    if ([self.frontviewDelegate respondsToSelector:@selector(kkRoomCloseBtnClick)]) {
        [self.frontviewDelegate kkRoomCloseBtnClick];
    }
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];

}

//跳魅力值页面
-(void)kkyingpiaoClick{

    KKLiveRoomRankAlertView *kkalertView = [[KKLiveRoomRankAlertView alloc]init];
    kkalertView.kkRankDic = self.zhuboDic;

    kkalertView.kkTotalRankBtnClickBlock = ^(KKLiveRoomRankAlertView * _Nonnull kkRankAlertView) {
        KKWebH5ViewController *nVC = [[KKWebH5ViewController alloc]init];
        nVC.kkJumpType = 1;
        [[MXBADelegate sharedAppDelegate] pushViewController:nVC animated:YES];
    };
    [kkalertView kkShow];
}
-(void)zhuboMessage{
    if ([self.frontviewDelegate respondsToSelector:@selector(zhubomessage)]) {
        [self.frontviewDelegate zhubomessage];
    }
}
-(void)zhezhaoBTN{
    if ([self.frontviewDelegate respondsToSelector:@selector(zhezhaoBTNdelegate)]) {
        [self.frontviewDelegate zhezhaoBTNdelegate];
    }
}


- (void)liveTimeChangeGCDTimer {
    int timeInterval = 1.0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"liveTimeChange"
                                                           timeInterval:timeInterval
                                                                  queue:dispatch_get_main_queue()
                                                                repeats:YES
                                                          fireInstantly:NO
                                                                 action:^{
                                                                     [weakSelf liveTimeChange];
                                                                 }];
}



- (void)liveTimeChange
{
    self.kkkLiveTimeNum ++;
    if (self.kkkLiveTimeNum < 3600) {
        self.kkLiveTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",self.kkkLiveTimeNum/60,self.kkkLiveTimeNum%60];
    }else{
        if (self.kkLiveTimeV.width < 73) {

        }
        self.kkLiveTimeLab.text = [NSString stringWithFormat:@"%02d:%02d:%02d",self.kkkLiveTimeNum/3600,(self.kkkLiveTimeNum%3600)/60,(self.kkkLiveTimeNum%3600)%60];
    }

}
#pragma mark === 赋值数据
- (void)setKkIsLive:(BOOL)kkIsLive
{
    _kkIsLive = kkIsLive;
    
    if (kkIsLive) {
        [self liveTimeChangeGCDTimer];
        self.kkLiveTimeV.hidden = NO;
    }else{
        self.kkLiveTimeV.hidden = YES;
    }
}

- (void)setKkLiveDic:(NSDictionary *)kkLiveDic
{
    _kkLiveDic = kkLiveDic;
    self.kkActivityView.kkRoomDic = kkLiveDic;
}

- (void)setZhuboDic:(NSDictionary *)zhuboDic
{
    _zhuboDic = zhuboDic;
    self.kkActivityView.kkAnchorDic = zhuboDic;

    self.kkRoomPersonListView.kkLiveID = zhuboDic[@"uid"];
    self.kkRoomPersonListView.kkStreams = zhuboDic[@"stream"];
    [self.kkRoomPersonListView listReloadNoew];

    [self.kkUserIconImgV sd_setImageWithURL:[NSURL URLWithString:zhuboDic[@"avatar_thumb"]] placeholderImage:[UIImage imageNamed:kkPlaceholderHeadIconImageStr]];
    self.kkUserNameLab.text = minstr([self.zhuboDic valueForKey:@"user_nicename"]);
    self.kkUserIDLab.text = [NSString stringWithFormat:@"ID:%@",minstr([_zhuboDic valueForKey:@"uid"])];
//肉票
    [self changeState:zhuboDic[@"votestotal"]];
    

    NSString *liangname = minstr([_zhuboDic valueForKey:@"nums"]);//观看人数，主播守护数量
    float kkOnLineNum = [liangname floatValue]/10000;
    if (kkOnLineNum >= 1) {
        [self.kkOnLinePersonBtn setTitle:[NSString stringWithFormat:@"%.1fw",kkOnLineNum] forState:UIControlStateNormal];

        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];

    }else{
        [self.kkOnLinePersonBtn setTitle:liangname forState:UIControlStateNormal];

        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];
    }

}


-(void)GetInformessage:(NSDictionary *)subdic
{
    if ([self.frontviewDelegate respondsToSelector:@selector(GetInformessage:)]) {
        [self.frontviewDelegate GetInformessage:subdic];
    }
}



- (void)setKkLiveRoomDic:(NSDictionary *)kkLiveRoomDic
{
    _kkLiveRoomDic = kkLiveRoomDic;
    
    self.kkActivityView.kkRoomDic = kkLiveRoomDic;

    self.kkActivityView.kkAnchorDic = kkLiveRoomDic;

    self.kkRoomPersonListView.kkLiveID = kkLiveRoomDic[@"liveuid"];
    self.kkRoomPersonListView.kkStreams = kkLiveRoomDic[@"stream"];
    [self.kkRoomPersonListView listReloadNoew];

    [self.kkUserIconImgV sd_setImageWithURL:[NSURL URLWithString:kkLiveRoomDic[@"avatar_thumb"]] placeholderImage:[UIImage imageNamed:kkPlaceholderHeadIconImageStr]];
    self.kkUserNameLab.text = minstr([kkLiveRoomDic valueForKey:@"user_nicename"]);
    self.kkUserIDLab.text = [NSString stringWithFormat:@"ID:%@",minstr([kkLiveRoomDic valueForKey:@"liveuid"])];
//肉票
    [self changeState:kkLiveRoomDic[@"votestotal"]];
    

    NSString *liangname = @"0";//观看人数
    float kkOnLineNum = [liangname floatValue]/10000;
    if (kkOnLineNum >= 1) {
        [self.kkOnLinePersonBtn setTitle:[NSString stringWithFormat:@"%.1fw",kkOnLineNum] forState:UIControlStateNormal];

        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];

    }else{
        [self.kkOnLinePersonBtn setTitle:liangname forState:UIControlStateNormal];

        [self.kkOnLinePersonBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.kkOnLinePersonBtn.titleLabel.text.length + kkOnLinePersonBtnW);
        }];
    }

}

@end
