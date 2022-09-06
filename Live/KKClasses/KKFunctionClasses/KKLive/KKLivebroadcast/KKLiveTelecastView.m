//
//  KKLiveTelecastView.m
//  yunbaolive
//
//  Created by Peter on 2021/10/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveTelecastView.h"

//trtc
#import "TRTCVoiceRoom.h"
#import <TXLiteAVSDK_Professional/TRTCCloud.h>
#import <TXLiteAVSDK_Professional/TXAudioEffectManager.h>
#import <V2TIMManager.h>

//美颜
#import "FUAPIDemoBar.h"
#import "FUManager.h"
#import "authpack-ios-gw0929_2021-09-29-12-27.h"




#import "KKMyBeautyCache.h"


#import "KKLiveSocketInfoModel.h"

//预览
#import "KKLiveShootPreview.h"
//房间类型选择
#import "KKChangeLiveRoomTypeView.h"
#import "KKLiveTelecastCountdownView.h"

#import "KKUserInfoView.h"
#import "KKLiveBottomMenuView.h"
#import "KKSocketChatView.h"

//弹窗
#import "GrounderSuperView.h"
#import "KKLiveRoomUserOnlineView.h"
#import "KKLiveGiftView.h"
#import "KKTextToolBar.h"
#import "KKViewerAnchorMoreFunctionView.h"
#import "KKLiveUserComeRoomAnimationView.h"
#import "KKLiveEndView.h"
#import "KKConnectMicrophoneView.h"

#import "upmessageInfo.h"
#import "catSwitch.h"
#import "adminLists.h"
#import "expensiveGiftV.h"
#import "continueGift.h"
#import "userLoginAnimation.h"
#import "play_linkMic.h"
#import "anchorPKAlert.h"
#import "anchorPKView.h"
#import "anchorOnline.h"

#import "PersonMessageViewController.h"
#import "jubaoVC.h"


#define upViewH     296
//kk顶部显示用户入场动画高度 40
#define kkuseraimationH 21.33

//连麦小窗口Y值
#define kkCallAnchorY (100+ kkStatusbarH)

@interface KKLiveTelecastView ()<anchorPKAlertDelegate,anchorPKViewDelegate,play_linkmic>

@end

@interface KKLiveTelecastView ()<KKLiveShootPreviewDelegate,TRTCCloudDelegate,TRTCVideoFrameDelegate,FUAPIDemoBarDelegate,frontviewDelegate,KKSocketChatViewDelegate,KKLiveBottomMenuViewDelegate,KKLiveGiftViewDelegate,upmessageKickAndShutUp,adminDelegate,KKLiveSocketInfoDelegate,KKAnchorMoreFunctionDelegate>


@property(weak,nonatomic)UIImageView *pkBackImgView;

@property(weak,nonatomic)UIView *kkCameraView;
@property(weak,nonatomic)UIScrollView *backScrollView;
@property(weak,nonatomic)UIView *kkContentView;
@property(weak,nonatomic)UIButton *kkCoverBtn;

//预览
@property(weak,nonatomic)KKLiveShootPreview *kkLivePreview;
@property(strong,nonatomic)UIScrollView *roomTypeView;
@property(strong,nonatomic)NSMutableArray *roomTypeBtnArray;

@property (nonatomic,copy) NSString * roomType;
@property (nonatomic,copy) NSString * roomTypeValue;
//开播的房间信息
@property(strong,nonatomic)NSDictionary *kkRoomDic;

//美颜
@property (strong, nonatomic) FUAPIDemoBar *demoBar;
@property(weak,nonatomic)UIButton *kkBeautyTouchBtn;


@property(weak,nonatomic)KKUserInfoView *kkUserInfoV;
@property(weak,nonatomic)GrounderSuperView *kkBarrageView;

@property(weak,nonatomic)KKSocketChatView *kkChatView;
@property(weak,nonatomic)KKLiveBottomMenuView *kkBottomMenuView;

//房间socket数据
@property(strong,nonatomic)KKLiveSocketInfoModel *kkLiveInfoModel;

@property(weak,nonatomic)KKLiveGiftView *giftview;
//聊天输入框
@property(weak,nonatomic)KKTextToolBar *kktextToolBar;
//底部更多功能视图
@property(weak,nonatomic)KKViewerAnchorMoreFunctionView *kkMoreFunctionView;

//管理员列表
@property(strong,nonatomic)adminLists *adminlist;
@property(strong,nonatomic)UIViewController *zhezhaoList;

@property(weak,nonatomic)UIView *kkContinuousView;//连送视图
@property(strong,nonatomic) continueGift *continueGifts;//连送礼物
@property(weak,nonatomic)expensiveGiftV *haohualiwuV;//豪华礼物

@property (nonatomic,assign) BOOL isTorch;//是否开启闪光，默认No

@property(weak,nonatomic)userLoginAnimation *useraimation;//进场动画(横条飘进)
//普通用户进场动画
@property(weak,nonatomic)KKLiveUserComeRoomAnimationView *kkUserComeInAnimationView;

//魅力值
@property (nonatomic,copy) NSString * votesTatal;

@property (nonatomic,assign) BOOL isAnchorLink;
@property (nonatomic,assign) BOOL isLianmai;//是否正在连麦

@property(strong,nonatomic) play_linkMic *playrtmp;//连麦小窗口
@property(strong,nonatomic)    anchorPKAlert *pkAlertView;
@property(strong,nonatomic)anchorPKView *pkView;
@property(strong,nonatomic)UIButton *startPKBtn;


//返回后台时间60s
@property (nonatomic,assign) NSInteger backTime;//检测后台时间（超过60秒执行断流操作）
@property (nonatomic,assign) BOOL isclosenetwork;//判断断网回后台

//判断网络状态
@property(strong,nonatomic)AFNetworkReachabilityManager *managerAFH;
//是否允许连麦，测试用
//@property (nonatomic,weak) UIButton *kkMicrophoneBtn;

@property (nonatomic,strong) NSDictionary *kkUserMicrophoneDic;

@property (nonatomic,weak) KKConnectMicrophoneView *kkConnectMicrophoneV;

@end

@implementation KKLiveTelecastView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //添加子控件
        [self kkInitView];
    }
    return self;
}

- (void)kkInitView
{
    UIImageView * pkBackImgView = [[UIImageView alloc] init];
    self.pkBackImgView = pkBackImgView;
    pkBackImgView.image = [UIImage imageNamed:@"pk背景"];
    pkBackImgView.userInteractionEnabled = YES;
    pkBackImgView.hidden = YES;
    [self addSubview:pkBackImgView];

    UIView *kkCameraView = [[UIView alloc]init];
    [self addSubview:kkCameraView];
    self.kkCameraView = kkCameraView;
    
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    self.backScrollView = backScrollView;
    [self addSubview:backScrollView];

    backScrollView.pagingEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    backScrollView.userInteractionEnabled = YES;
    
    UIView *kkContentView = [[UIView alloc] init];
    self.kkContentView = kkContentView;
    [self.backScrollView addSubview:kkContentView];
    kkContentView.backgroundColor = [UIColor clearColor];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ddd)];
//    [kkContentView addGestureRecognizer:tap];
    
    
    UIButton *kkCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkCoverBtn = kkCoverBtn;
    [self.kkContentView addSubview:kkCoverBtn];
    [kkCoverBtn addTarget:self action:@selector(kkCoverClick) forControlEvents:UIControlEventTouchUpInside];
    
    KKLiveShootPreview *kkLivePreview = [[KKLiveShootPreview alloc] init];
    self.kkLivePreview = kkLivePreview;
    [self.kkContentView addSubview:kkLivePreview];
    kkLivePreview.kkDelegate = self;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self kkLayoutBaseView];
//
}

- (void)kkLayoutBaseView
{

    [self.pkBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkCameraView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KKScreenWidth);
        make.height.mas_equalTo(KKScreenHeight);

    }];

    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);//KKScreenWidth
        make.top.width.height.mas_equalTo(self.backScrollView);
    }];
    
    [self.kkCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];
    
}

- (void)kkLayoutPreview
{
    [self.kkLivePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];
}

#pragma mark ==== //初始化预览
- (void)kkInitPreview
{
    [self kkLayoutBaseView];

    [self kkLayoutPreview];

    //kk六道美颜
    [[FUManager shareManager] loadFilter];
    _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectZero];
    _demoBar.mDelegate = self;
//    self.demoBar.hidden = YES;
    [self kkInitBeauty];
    [self kkTRTCPreviewLiveInit];
    
}

- (void)kkTRTCLiveInit:(NSDictionary *)dic
{
    //点击接听进入这个方法，
     TRTCParams *kkTRTCParams = [[TRTCParams alloc]init];
     kkTRTCParams.userSig = dic[@"spkeysing"];
     kkTRTCParams.sdkAppId = [dic[@"shishivideoid"] intValue];
     kkTRTCParams.roomId = [[KKChatConfig getOwnID] intValue];
     kkTRTCParams.userId = [KKChatConfig getOwnID];
     kkTRTCParams.role = TRTCRoleAnchor;
    
//        TRTCAppSceneLIVE
     [[TRTCCloud sharedInstance] enterRoom:kkTRTCParams appScene:TRTCAppSceneLIVE];
    [[TRTCCloud sharedInstance] startLocalAudio:TRTCAudioQualityDefault];
    //推流
    [ [TRTCCloud sharedInstance]  startPublishing:dic[@"stream"] type:TRTCVideoStreamTypeBig];

}


- (void)kkTRTCPreviewLiveInit
{
    TRTCVideoEncParam *videoEncParam = [[TRTCVideoEncParam alloc] init];
    videoEncParam.videoResolution = TRTCVideoResolution_960_540;
    videoEncParam.videoFps = 15;
    videoEncParam.videoBitrate = 1300;
    videoEncParam.resMode = TRTCVideoResolutionModePortrait;
    videoEncParam.enableAdjustRes = true;

    TRTCCloud *kkTRTCCloud = [TRTCCloud sharedInstance];
    [kkTRTCCloud setDelegate:self];
    [kkTRTCCloud setVideoEncoderParam:videoEncParam];

    //开启本地画面预览，自己画面
    [kkTRTCCloud startLocalPreview:YES view:self.kkCameraView];
    [kkTRTCCloud startLocalAudio:TRTCAudioQualityDefault];//
    [kkTRTCCloud setLocalVideoProcessDelegete:self pixelFormat:TRTCVideoPixelFormat_Texture_2D bufferType:TRTCVideoBufferType_Texture];
//     [kkTRTCCloud setGSensorMode:TRTCGSensorMode_Disable];//重力感应
//    [TRTCCloud setConsoleEnabled:YES];
//    [TRTCCloud setLogDelegate:self];
}


- (uint32_t)onProcessVideoFrame:(TRTCVideoFrame * _Nonnull)srcFrame dstFrame:(TRTCVideoFrame * _Nonnull)dstFrame
{
    uint32_t  texture = [[FUManager shareManager] renderItemWithTexture:srcFrame.textureId Width:srcFrame.width Height:srcFrame.height];
            dstFrame.textureId = texture;
    return 0 ;
}
 
- (void)onRemoteUserEnterRoom:(NSString *)userId
{
    if (self.kkUserMicrophoneDic) {
        if ([self.kkUserMicrophoneDic[@"uid"] isEqualToString:userId]) {
            [[TRTCCloud sharedInstance] startRemoteView:userId streamType:TRTCVideoStreamTypeSmall view:[UIView new]];
        }
    }
}
- (void)onError:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg extInfo:(nullable NSDictionary*)extInfo
{
    KKLog(@"%@",errMsg);
}
- (void)onEnterRoom:(NSInteger)result
{
    if (result>0) {
        NSLog(@"进房成功");
    }
}

- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available
{
    if (self.kkUserMicrophoneDic) {
        if ([self.kkUserMicrophoneDic[@"uid"] isEqualToString:userId]) {
            [[TRTCCloud sharedInstance] startRemoteView:userId streamType:TRTCVideoStreamTypeBig view:[UIView new]];
        }
    }
}
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason
{
    if (self.kkUserMicrophoneDic) {
        if ([self.kkUserMicrophoneDic[@"uid"] isEqualToString:userId]) {
            [self kkusercloseConnect:userId];
        }
    }
}

#pragma mark ===预览视图代理事件 KKLiveShootPreviewDelegate//

//关闭预览
- (void)kkClosePreView
{
    [self doClosePreView];
}
//房间类型
- (void)kkLiveRoomTypeBtnClick
{
    [self dochangelivetype];
}
//切换摄像头
- (void)kkSwitchCamerBtnClick
{
    [self rotateCamera];
}

- (void)kkPresentAlertContro:(UIViewController *)alert
{
    if ([self.kkDelegate respondsToSelector:@selector(kkPresentAlertContro:)]) {
        [self.kkDelegate kkPresentAlertContro:alert];
    }
}

//美颜
- (void)kkpreBeautyBtnClick
{
    [self showFitterView];
}
//退出预览
- (void)doClosePreView{

    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [KKUserDefaults setBool:NO forKey:@"isLiveing"];
    if ([self.kkDelegate respondsToSelector:@selector(kkClosePreView)]) {
        [self.kkDelegate kkClosePreView];
    }
}

#pragma mark ==== 选择房间类型
- (void)dochangelivetype
{
    KKChangeLiveRoomTypeView *kkTypeView = [[KKChangeLiveRoomTypeView alloc]init];
    [kkTypeView kkShow];
    WeakSelf;
    kkTypeView.kkAlertControkBlock = ^(UIAlertController * _Nonnull alert) {
        if ([weakSelf.kkDelegate respondsToSelector:@selector(kkPresentAlertContro:)]) {
            [weakSelf.kkDelegate kkPresentAlertContro:alert];
        }
    };
    kkTypeView.kkChangeRoomTypeBlock = ^(NSString * _Nonnull roomType, NSString * _Nonnull roomTypeValue, NSString * _Nonnull roomName) {
        weakSelf.kkLivePreview.roomType = roomType;
        weakSelf.kkLivePreview.roomTypeValue = roomTypeValue;
    };
}

-(void)rotateCamera{
//2.7.5六道修改
//    [[[TRTCCloud sharedInstance] getDeviceManager] switchCamera:YES];
    [[TRTCCloud sharedInstance] switchCamera];
}

//开始直播
- (void)startLiveBtnClick:(NSDictionary *)dic
{
    
    NSMutableDictionary * kkdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    kkdic[@"uid"] = [NSString kk_isNullString:dic[@"liveuid"]];
     self.kkRoomDic = kkdic;
    
    [self kkInitLiveRoomData];

     [self kkTRTCLiveInit:kkdic];
    //     开始直播
     [self kkInitRoomUI];

}

- (void)kkInitLiveRoomData
{
    //初始化数据
    self.isTorch = NO;
    self.isAnchorLink = NO;
    self.isLianmai = NO;
    self.isclosenetwork = NO;
    self.backTime = 0;
    [self kkInitLiveRoomNotifi];

}
#pragma mark ===============            //直播中的视图初始化


-(void)kkInitRoomUI{

    KKUserInfoView *kkUserInfoV = [[KKUserInfoView alloc] init];
    self.kkUserInfoV = kkUserInfoV;
    [self.kkContentView addSubview:kkUserInfoV];
    kkUserInfoV.frontviewDelegate = self;
    kkUserInfoV.kkLiveRoomDic = self.kkRoomDic;
    kkUserInfoV.kkIsLive = YES;
    
    KKLiveBottomMenuView *kkBottomMenuView = [[KKLiveBottomMenuView alloc] init];
    self.kkBottomMenuView = kkBottomMenuView;
    [self.kkContentView addSubview:kkBottomMenuView];
    kkBottomMenuView.kkBottomMenuViewDelegate = self;
    kkBottomMenuView.kkIsTRTC = NO;
    
    KKSocketChatView *kkChatView = [[KKSocketChatView alloc] init];
    self.kkChatView = kkChatView;
    kkChatView.kkIsLive = YES;
    [self.kkContentView addSubview:kkChatView];
    kkChatView.kkChatViewDelegate = self;

    GrounderSuperView *kkBarrageView = [[GrounderSuperView alloc] init];
    self.kkBarrageView = kkBarrageView;
    [self.kkContentView addSubview:kkBarrageView];

    //socket初始化
    [self.kkLiveInfoModel kkLoadLiveViewerInfo:self.kkRoomDic];

    [self kkInitFunctionView];
    [self kkLayoutRoomView];
    
    KKLiveTelecastCountdownView *kkCountdownV = [[KKLiveTelecastCountdownView alloc]init];
    [kkCountdownV kkShow];

}

- (void)kkInitFunctionView
{
    KKTextToolBar *kktextToolBar = [[KKTextToolBar alloc]init];
    [self.kkContentView addSubview:kktextToolBar];
    self.kktextToolBar = kktextToolBar;
    WeakSelf;
    kktextToolBar.kkMessagePushBtnClickBlock = ^(UITextField * _Nonnull kkTextField) {
        [weakSelf kkPushMessage:kkTextField];
    };
    
    userLoginAnimation *useraimation =  [[userLoginAnimation alloc]init];
    self.useraimation = useraimation;
    [self.kkContentView addSubview:useraimation];
    useraimation.hidden = YES;
    
    //普通用户进场动画
    KKLiveUserComeRoomAnimationView *kkUserComeInAnimationView = [[KKLiveUserComeRoomAnimationView alloc]init];
    self.kkUserComeInAnimationView  = kkUserComeInAnimationView;
    kkUserComeInAnimationView.hidden = YES;
    
    UIView *kkContinuousView = [[UIView alloc]init];
    self.kkContinuousView = kkContinuousView;
    [self.kkContentView addSubview:kkContinuousView];
//    kkContinuousView.hidden = YES;

//    UIButton *kkMicrophoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.kkContentView addSubview:kkMicrophoneBtn];
//    self.kkMicrophoneBtn = kkMicrophoneBtn;
//    [kkMicrophoneBtn addTarget:self action:@selector(linkSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [kkMicrophoneBtn setImage:[UIImage imageNamed:@"KKLiveRoom_userInfo_attention"] forState:UIControlStateNormal];

}

- (void)kkLayoutRoomView
{
    [self.kkUserInfoV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(100+ kkStatusbarH);//215
    }];

    [self.kkBottomMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ShowDiff));
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.kkChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-5);
//        make.top.mas_equalTo(self.kkTRTCVoiceV.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(200);
    }];
    
    [self.kkBarrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkUserInfoV.mas_bottom);
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(140);
    }];
    
    [self kkLayoutFunctionView];

}
- (void)kkLayoutFunctionView
{

    [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.kkContentView.mas_bottom);
    }];
    [self.useraimation mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.kkChatView.mas_top);
        make.width.mas_equalTo(KKScreenWidth);
        make.height.mas_equalTo(kkuseraimationH);
    }];

    [self.kkUserComeInAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.kkChatView.mas_top);
        make.width.mas_equalTo(KKScreenWidth);
        make.height.mas_equalTo(20);
    }];

    [self.kkContinuousView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.kkChatView.mas_top);
        make.width.mas_equalTo(KKScreenWidth);//300
        make.height.mas_equalTo(140);
    }];
//    [self.kkMicrophoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(-100);
//        make.width.height.mas_equalTo(50);
//    }];
    
}

- (void)kkInitLiveRoomNotifi
{
    //增加监听，当键盘出现或改变时收出消息
    [kkNotifCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [kkNotifCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //注册进入后台的处理
    [kkNotifCenter addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];//app回到前台
    [kkNotifCenter addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];//app进入后台
    
    [kkNotifCenter addObserver:self selector:@selector(shajincheng) name:@"shajincheng" object:nil];
    WeakSelf;
    self.managerAFH = [AFNetworkReachabilityManager sharedManager];
    [self.managerAFH setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                (@"未识别的网络");
              weakSelf.isclosenetwork = YES;
                [weakSelf backGround];
//                [notifications displayNotificationWithMessage:@"网络断开连接" forDuration:8];
                break;
            case AFNetworkReachabilityStatusNotReachable:
//                (@"不可达的网络(未连接)");
                weakSelf.isclosenetwork = YES;
                [weakSelf backGround];
//                [notifications displayNotificationWithMessage:@"网络断开连接" forDuration:8];
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                weakSelf.isclosenetwork = NO;
                [weakSelf forwardGround];
//                [notifications dismissNotification];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                weakSelf.isclosenetwork = NO;
                [weakSelf forwardGround];
//                [notifications dismissNotification];
                break;
            default:
                break;
        }
    }];
    [self.managerAFH startMonitoring];

    
}

//通知事件
-(void)appactive{
//    (@"哈哈哈哈哈哈哈哈哈哈哈哈 app回到前台");
    [self forwardGround];
}
-(void)appnoactive{
    [self backGround];
//    (@"0000000000000000000 app进入后台");
}
-(void)forwardGround{
    if (self.backTime != 0) {
        [self.kkLiveInfoModel.kkSocketLive phoneCall:YZMsg(@"主播回来了")];
    }
    //进入前台
    if (self.backTime > 60) {
        [self kkCloseLiveRoom];
    }
    if (self.isclosenetwork == NO) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];
        self.backTime = 0;
    }
}
-(void)backGround{
        //进入后台
       
    [self sendEmccBack];

    [self backGroundGCDTimer];
}
//来电话
-(void)sendEmccBack
{
    [self.kkLiveInfoModel.kkSocketLive phoneCall:YZMsg(@"主播离开一下，精彩不中断，不要走开哦")];
}


- (void)backGroundGCDTimer {
    int timeInterval = 1.0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"backgroundselector"
                                                           timeInterval:timeInterval
                                                                  queue:dispatch_get_main_queue()
                                                                repeats:YES
                                                          fireInstantly:NO
                                                                 action:^{
                                                                     [weakSelf backgroundselector];
                                                                 }];
}


-(void)backgroundselector{
    self.backTime +=1;
//    (@"返回后台时间%d",backTime);
    if (self.backTime > 60) {
        [self kkCloseLiveRoom];
    }
}
//杀进程
-(void)shajincheng{
    [self kkCloseLiveRoom];
}


#pragma mark ==== frontviewDelegate    功能代理事件
//点击主播弹窗
-(void)zhubomessage
{
    NSDictionary *subdic = @{@"id":[self.kkRoomDic valueForKey:@"uid"]};
    [self GetInformessage:subdic];
}
//在线人数点击事件
- (void)kkOnLinePersonBtnClick
{
    KKLiveRoomUserOnlineView *view = [[KKLiveRoomUserOnlineView alloc] init];
    view.kkLiveID = self.kkRoomDic[@"uid"];
    view.kkStream = self.kkRoomDic[@"stream"];
    WeakSelf;
    view.kkDidSelectItemBlock = ^(NSDictionary * _Nonnull dic) {
        [weakSelf GetInformessage:dic];
    };
    [view kkShow];
}
//关闭直播间
- (void)kkRoomCloseBtnClick
{
    UIAlertController  *alertlianmaiVCtc = [UIAlertController alertControllerWithTitle:YZMsg(@"确定退出直播吗？") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self kkCloseLiveRoom];
    }];
    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 9.0) {
    }
    else{
        [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    [alertlianmaiVCtc addAction:defaultActionss];
    [alertlianmaiVCtc addAction:cancelActionss];
    if ([self.kkDelegate respondsToSelector:@selector(kkPresentAlertContro:)]) {
        [self.kkDelegate kkPresentAlertContro:alertlianmaiVCtc];
    }
}
//KKSocketChatViewDelegate
//遮罩事件
- (void)kkChatCoverClick
{
    [self kkCoverClick];
}
//聊天消息事件
- (void)kkChatMessageClick:(NSDictionary *)dic
{
    [self GetInformessage:dic];
}

-(void)kkCoverClick
{
    [self.giftview removeFromSuperview];
    WeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
       [weakSelf changeGiftViewFrameY:KKScreenHeight *3];
    }];
    
    [self.kkLiveInfoModel kkStarMove];
    [self.kktextToolBar.kkTextField resignFirstResponder];
    [self kkLayoutRoomView];
}
-(void)changeGiftViewFrameY:(CGFloat)Y{
    
    self.giftview.frame = CGRectMake(0,Y, _window_width, 300+ShowDiff);
    if (Y >= KKScreenHeight) {
        self.kkContinuousView.frame = CGRectMake(0, self.kkChatView.top-150,300,140);
    }
//    int kktype = [[KKUserDefaults valueForKey:kkGiftDynamic] intValue];
//    if (kktype) {
//        self.kkContinuousView.hidden = NO;
//    }else{
//        self.kkContinuousView.hidden = YES;
//    }

}


#pragma mark --======= 获取键盘高度  键盘的显示与隐藏
- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    [self doCancle];
//    self.kkUserInfoV.hidden = YES;
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat heightw = keyboardRect.size.height;
    WeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        [self kkChangeChatViewY:heightw];
        //
        [weakSelf.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.width.mas_equalTo(self.kkContentView);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(-(heightw+44));
            }];
        [weakSelf changeGiftViewFrameY:_window_height*10];

    }];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    WeakSelf;
    [UIView animateWithDuration:0.1 animations:^{
//        weakSelf.kkUserInfoV.hidden = NO;
        [weakSelf changeGiftViewFrameY:_window_height*3];
        [weakSelf kkLayoutRoomView];
    }];
}

//距离底部高度
- (void)kkChangeChatViewY:(CGFloat)h
{
    [self.kkChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-h);
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(200);
    }];
}

//KKLiveBottomMenuViewDelegate
//显示礼物功能
- (void)kkGiftBtnClick
{
    [self changeGiftViewFrameY:_window_height *3];

    KKLiveGiftView *kkview = [[KKLiveGiftView alloc]init];
    self.giftview = kkview;
    kkview.kkGiftDelegate = self;
    kkview.kkLiveInfoDic = self.kkRoomDic;

    [self.kkContentView addSubview:kkview];
    [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];

}
- (void)kkShowAlertMoney:(UIAlertController *)alert
{
    if ([self.kkDelegate respondsToSelector:@selector(kkPresentAlertContro:)]) {
        [self.kkDelegate kkPresentAlertContro:alert];
    }
}
//聊天
- (void)kkChatBtnClick
{
    [self.kktextToolBar.kkTextField becomeFirstResponder];
}

- (void)kkMoreBtnClick
{
    KKViewerAnchorMoreFunctionView *kkview = [[KKViewerAnchorMoreFunctionView alloc]init];
    self.kkMoreFunctionView = kkview;
    self.kkMoreFunctionView.hidden = NO;
    kkview.kkDelegate = self;
    kkview.kkRoomType = 1;
    [self addSubview:kkview];
    [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}
#pragma mark ====//更多功能代理   KKAnchorMoreFunctionDelegate
//美颜
- (void)kkBeauty
{
    [self showFitterView];

}
//翻转
- (void)kkSwitchCamera
{
    [self rotateCamera];
}
//闪光灯
- (void)kkFlashlight
{
    if ([[TRTCCloud sharedInstance] isCameraTorchSupported]) {
        self.isTorch = !self.isTorch;
        [[TRTCCloud sharedInstance] enbaleTorch:self.isTorch];
    }else{
        [MBProgressHUD kkshowMessage:@"只有后置摄像头才能使用闪光灯"];
    }

}
//直播连麦
- (void)kkAnchorCall
{
    anchorOnline * anchorView = [[anchorOnline alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    [anchorView kkShow];
    WeakSelf;
    anchorView.kkStartLinkBlock = ^(NSDictionary * _Nonnull dic) {
        [weakSelf.kkLiveInfoModel.kkSocketLive anchor_startLink:dic];
    };
}


#pragma mark =============  普通用户列表 头像 点击弹窗
-(void)GetInformessage:(NSDictionary *)subdic{

    CGRect kkUserViewR = CGRectMake(0,KKScreenHeight -upViewH ,KKScreenWidth,upViewH);
    upmessageInfo  *userView = [[upmessageInfo alloc]initWithFrame:kkUserViewR  andPlayer:@""];
    //添加用户列表弹窗
    userView.upmessageDelegate = self;
    userView.frame= kkUserViewR;
    [userView kkShowView];
    [userView getUpmessgeinfo:subdic andzhuboDic:self.kkRoomDic];
}

//用户头像弹窗代理   upmessageKickAndShutUp
//禁言
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID
{
    [self.kkLiveInfoModel.kkSocketLive shutUp:ID andName:name];
}
//踢人
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID
{
    [self.kkLiveInfoModel.kkSocketLive kickuser:ID andName:name];
}

-(void)pushZhuYe:(NSString *)IDS{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = IDS;
    [KKMyAPI kk_PostUserTypeInfoWithParameters:param successBlock:^(id  _Nullable response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            if ([response[@"isauth"] isEqualToString:@"1"]) {
                //主播
//                [self doCancle];
                PersonMessageViewController *rVC = [[PersonMessageViewController alloc]init];
                rVC.kkLiveUid = IDS;
                [[MXBADelegate sharedAppDelegate] pushViewController:rVC animated:YES];
            }else{
                [MBProgressHUD kkshowMessage:@"该用户未认证"];
            }
            
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
        
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];

}
    
-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID andIsatt:(NSString *)isatt
{
//    [self doCancle];
    [self.kktextToolBar.kkTextField becomeFirstResponder];
    self.kktextToolBar.kkTextField.text = [NSString stringWithFormat:@"@%@",name];
}

-(void)doupCancle
{
    //    [self doCancle];
}
-(void)adminList
{
//    [self doCancle];
//    self.tableView.hidden = YES;
    self.adminlist.view.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
    [kkNotifCenter postNotificationName:@"adminlist" object:nil];

    WeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
       weakSelf.adminlist.view.frame = CGRectMake(0,0, _window_width, _window_height);
        weakSelf.zhezhaoList.view.hidden = NO;
    }];

}

-(void)superAdmin:(NSString *)state
{
    [self kkCloseLiveRoom];
}

-(void)doReportAnchor:(NSString *)touid
{
    jubaoVC *vc = [[jubaoVC alloc]init];
    vc.dongtaiId = touid;
    vc.isLive = YES;
    [[MXBADelegate sharedAppDelegate]  pushViewController:vc animated:YES];
}
//
////主播端
-(void)setAdminSuccess:(NSString *)isadmin andName:(NSString *)name andID:(NSString *)ID
{
    [self.kkLiveInfoModel.kkSocketLive setAdminID:ID andName:name andCt:isadmin];
}



-(void)kkPushMessage:(UITextField *)sender
{
    if (self.kktextToolBar.kkTextField.text.length >50) {
        [MBProgressHUD showError:YZMsg(@"字数最多50字")];
        return;
    }
    self.kktextToolBar.kkMessagePushBTN.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.kktextToolBar.kkMessagePushBTN.enabled = YES;
    });
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [self.kktextToolBar.kkTextField.text stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        return ;
    }
    
    if(self.kktextToolBar.kkCatSwitch.state == YES)//发送
    {//kK六道 sstate为no
        if (self.kktextToolBar.kkTextField.text.length <=0) {
            return;
        }
        [self sendBarrage];
        self.kktextToolBar.kkTextField.text =nil;
        self.kktextToolBar.kkMessagePushBTN.selected = NO;
        return;
    }
    else{

        NSString *content = self.kktextToolBar.kkTextField.text;
        [self.kkLiveInfoModel.kkSocketLive sendMessage:content];

        self.kktextToolBar.kkTextField.text =nil;
        self.kktextToolBar.kkMessagePushBTN.selected = NO;
    }
}



//发送消息
-(void)sendBarrage
{
    /*******发送弹幕开始 **********/
//    NSString *url = [purl stringByAppendingFormat:@"?service=Live.sendBarrage"];
    NSDictionary *subdic = @{
                             @"":[Config getOwnID],
                             @"":self.kkRoomDic[@""],
                             @"":@"1",
                             @"":@"1",
                             @"":self.kktextToolBar.kkTextField.text
                             };
    WeakSelf;
    [YBToolClass postNetworkWithUrl:@"" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *barragetoken = [[info firstObject] valueForKey:@"barragetoken"];
            //刷新本地魅力值
            LiveUser *liveUser = [Config myProfile];
            liveUser.coin = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"coin"]];
            [Config updateProfile:liveUser];
            [KKChatConfig updateProfile:liveUser];

            [weakSelf.kkLiveInfoModel.kkSocketLive sendBarrage:barragetoken];

        }
    } fail:^{
        
    }];
}


-(void)adminZhezhao{
    self.zhezhaoList.view.hidden = YES;
//    self.tableView.hidden = NO;
    WeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
       weakSelf.adminlist.view.frame = CGRectMake(0,_window_height*2, _window_width, _window_height*0.3);
    }];
}

#pragma mark ============ socket代理 KKLiveSocketInfoDelegate
//弹幕
- (void)kksendBarrage:(NSDictionary *)dic
{
    [self.kkBarrageView setModel:dic];
    NSString * danmuPrice = [self.kkRoomDic valueForKey:@"barrage_fee"];
    [self addCoin:danmuPrice];

}

//用户进入直播间
- (void)kkUserComeIn:(NSDictionary *)dic
{
    NSString *kklevel = [NSString stringWithFormat:@"%@",[dic valueForKey:@"level"]];

    if ([kklevel intValue] >= 10) {
        [self.useraimation addUserMove:dic];
    }else{
        //kk六道添加，用户进入直播间，给个弹窗通知
        [self.kkUserComeInAnimationView kkAddUserMove:dic];
    }
    [self.kkUserInfoV kkUserAccess:dic];
}
//用户离开
- (void)kkUserDisconnect:(NSDictionary *)dic
{
    [self.kkUserInfoV kkUserLeave:dic];
    //连麦小窗口
    if (self.playrtmp) {
        if ([[dic valueForKey:@"uid"] integerValue] == self.playrtmp.tag-1500) {
            [self releasePlayLinkView];
        }
    }
}

//顶部观众信息 和直播间人数
- (void)kkChangeLookLivePersion:(NSDictionary *)dic andPersionCount:(long long)count
{
//    if (dic) {
//        [self.kkUserInfoV kkUserLeave:dic];
//    }
    //kk六道更新直播间人数
    [self.kkUserInfoV kkChangeLookVideoPersionNum:count];
}
//socket消息
- (void)kkSocketMessageSuccess:(NSDictionary *)dic
{
    [self.kkChatView kkAddSocketMessage:dic];
}

//房间被管理员关闭,关闭直播间
- (void)kkRoomCloseByAdmin
{
    
}

//僵尸粉
- (void)kkAddZombieByArray:(NSArray *)array
{
    self.kkUserInfoV.kkRoomPersonArr = array.mutableCopy;
    self.kkUserInfoV.kkIsRefreshUserList = YES;
}
//魅力值更新
- (void)kkVotesTatal:(NSString *)votes
{
    self.votesTatal = votes;
    [self.kkUserInfoV changeState:votes];
}
//送礼物 1是豪华，其他是连送
- (void)kkSendGift:(NSDictionary *)giftInfo andGiftType:(int )type
{
    if (!self.continueGifts) {
        self.continueGifts = [[continueGift alloc]init];
        [self.kkContinuousView addSubview:self.continueGifts];
        //初始化礼物空位
        [self.continueGifts initGift];
    }
    if (type == 1) {
        [self expensiveGift:giftInfo];
    }
    else{
        [self.continueGifts GiftPopView:giftInfo andLianSong:[NSString stringWithFormat:@"%d",type]];
    }
}


//增加影票
- (void)kkAddVotesTatal:(NSString *)votes
{
    [self addCoin:votes];
}

#pragma mark =============连麦

- (void)linkSwitchBtnClick:(UIButton *)sender{
    //测试用，移到H5房间设置页面了
    [YBToolClass postNetworkWithUrl:@"" andParameter:@{@"ismic":@(!sender.selected)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            sender.selected = !sender.selected;
        }
        [MBProgressHUD showError:msg];
    } fail:^{
    }];
}

//用户与主播连麦,主播同意
- (void)kkAnchor_agreeUserLink:(NSDictionary *)dic
{
    self.kkUserMicrophoneDic = dic;
    WeakSelf;
    //用户连麦
    KKConnectMicrophoneView *kkConnectMicrophoneV = [[KKConnectMicrophoneView alloc]init];
//    self.kkConnectMicrophoneV = kkConnectMicrophoneV;
    [self.kkContentView addSubview:kkConnectMicrophoneV];
    self.kkConnectMicrophoneV = kkConnectMicrophoneV;
    kkConnectMicrophoneV.kkUserDic = dic;
    [kkConnectMicrophoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-5);
        make.width.height.mas_equalTo(90);
    }];
    kkConnectMicrophoneV.kkConnectBtnClickBlock = ^(NSString * _Nonnull string) {
    };
    kkConnectMicrophoneV.kkDisconnectBtnClickBlock = ^(KKConnectMicrophoneView * _Nonnull view) {
        [[TRTCCloud sharedInstance] stopRemoteView:view.kkUserDic[@"uid"] streamType:TRTCVideoStreamTypeSmall];

        [view removeFromSuperview];
        weakSelf.kkConnectMicrophoneV = nil;
        [weakSelf.kkLiveInfoModel.kkSocketLive closeconnectuser:view.kkUserDic[@"uid"]];
    };

}


//连麦
- (void)kkplayLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid
{
    //用户连主播，主播同意后，发送的自己URL，并没用到，这里没什么逻辑
    
}
//用户下麦
- (void)kkusercloseConnect:(NSString *)uid
{
    [MBProgressHUD kkshowMessage:@"用户断开连麦"];
    [[TRTCCloud sharedInstance] stopRemoteView:uid streamType:TRTCVideoStreamTypeSmall];
    [self.kkConnectMicrophoneV removeFromSuperview];
    self.kkConnectMicrophoneV = nil;
    self.isAnchorLink = NO;
    self.isLianmai = NO;
}


#pragma mark ======以上是用户和主播连麦


//主播同意连麦
- (void)kkAnchor_agreeLink:(NSDictionary *)dic
{
    [self releasePlayLinkView];
    //六道
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
       [jsonDict setObject:@([dic[@"uid"] intValue]) forKey:@"roomId"];
       [jsonDict setObject:dic[@"uid"] forKey:@"userId"];
       NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
       NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       [[TRTCCloud sharedInstance] connectOtherRoom:jsonString];

    self.isAnchorLink = YES;
    self.pkBackImgView.hidden = NO;
    self.isLianmai = YES;

    [UIView animateWithDuration:0.3 animations:^{
    }];
    [self.kkCameraView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(kkCallAnchorY);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(_window_width/2);
        make.height.mas_equalTo(_window_width*2/3);
    }];

    play_linkMic * playrtmp = [[play_linkMic alloc]initWithRTMPURL:@{@"playurl":minstr([dic valueForKey:@"pkpull"]),@"pushurl":@"0",@"userid":minstr([dic valueForKey:@"pkuid"])} andFrame:CGRectMake(_window_width/2, kkCallAnchorY, _window_width/2, _window_width*2/3) andisHOST:YES];
    self.playrtmp = playrtmp;
    
    playrtmp.delegate = self;
    playrtmp.tag = 1500 + [minstr([dic valueForKey:@"pkuid"]) intValue];

    [self addSubview:playrtmp];
    [self insertSubview:playrtmp aboveSubview:self.kkCameraView];
    [self addSubview:self.startPKBtn];
    
    self.startPKBtn.frame = CGRectMake((KKScreenWidth-80)/2,KKScreenHeight-ShowDiff-50-40, 80, 40);

}
- (void)kkAnchor_stopLink:(NSDictionary *)dic
{
    [self releasePlayLinkView];
    self.isAnchorLink = NO;

    [self.startPKBtn removeFromSuperview];
    [[TRTCCloud sharedInstance] disconnectOtherRoom];
    WeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.kkCameraView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(0);
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(KKScreenWidth);
            make.height.mas_equalTo(KKScreenHeight);
        }];
    }];
    
    if (self.pkView) {
        [self.pkView removeFromSuperview];
        self.pkView = nil;
    }

    [self changeLivebroadcastLinkState:NO];
    [UIApplication sharedApplication].idleTimerDisabled = YES;

}

//PK
- (void)kkShowPKView
{
    if (self.pkAlertView) {
        [self.pkAlertView removeTimer];
        [self.pkAlertView removeFromSuperview];
        self.pkAlertView = nil;
    }

    [self.startPKBtn removeFromSuperview];
    if (self.pkView) {
        [self.pkView removeFromSuperview];
        self.pkView = nil;
    }
    
    CGRect kkrect = CGRectMake(0, kkCallAnchorY, _window_width, _window_width*2/3+20);
    anchorPKView *pkView = [[anchorPKView alloc]initWithFrame:kkrect andTime:@"300"];
    self.pkView = pkView;
    self.pkView.delegate = self;
    [self addSubview:self.pkView];

}
- (void)kkShowPKResult:(NSDictionary *)dic
{
    int win;
    if ([minstr([dic valueForKey:@"win_uid"]) isEqual:@"0"]) {
        win = 0;
    }else if ([minstr([dic valueForKey:@"win_uid"]) isEqual:[KKChatConfig getOwnID]]) {
        win = 1;
    }else{
        win = 2;
    }

    [self.pkView showPkResult:dic andWin:win];

}
- (void)kkChangePkProgressViewValue:(NSDictionary *)dic
{
    NSString *blueNum;
    NSString *redNum;
    CGFloat progress = 0.0;
    if ([minstr([dic valueForKey:@"pkuid1"]) isEqual:[KKChatConfig getOwnID]]) {
        blueNum = minstr([dic valueForKey:@"pktotal1"]);
        redNum = minstr([dic valueForKey:@"pktotal2"]);
    }else{
        redNum = minstr([dic valueForKey:@"pktotal1"]);
        blueNum = minstr([dic valueForKey:@"pktotal2"]);
    }
    if ([blueNum isEqual:@"0"]) {
        progress = 0.2;
    }else if ([redNum isEqual:@"0"]) {
        progress = 0.8;
    }else{
        CGFloat ppp = [blueNum floatValue]/([blueNum floatValue] + [redNum floatValue]);
        if (ppp < 0.2) {
            progress = 0.2;
        }else if (ppp > 0.8){
            progress = 0.8;
        }else{
            progress = ppp;
        }
    }

    [self.pkView updateProgress:progress withBlueNum:blueNum withRedNum:redNum];

}

//PK发起倒计时
- (void)startPKBtnClick{

    [self.startPKBtn removeFromSuperview];
    if (self.pkAlertView) {
        [self.pkAlertView removeFromSuperview];
        self.pkAlertView = nil;
    }
    self.pkAlertView = [[anchorPKAlert alloc]initWithFrame:CGRectMake(0, kkCallAnchorY+_window_width*2/6, _window_width, 70) andIsStart:YES];
    self.pkAlertView.delegate = self;
    [self addSubview:self.pkAlertView];

    [self.kkLiveInfoModel.kkSocketLive launchPK];
}

- (void)releasePlayLinkView{
    if (self.playrtmp) {
        [self.playrtmp stopConnect];
        [self.playrtmp removeFromSuperview];
        self.playrtmp = nil;
    }
}

//play_linkmic
//主播关闭某人的连麦
-(void)closeuserconnect:(NSString *)uid{
    if (self.isAnchorLink) {
        [self.kkLiveInfoModel.kkSocketLive anchor_DuankaiLink];

    }else{
        [self.kkLiveInfoModel.kkSocketLive closeconnectuser:uid];
    }
    [self changeLivebroadcastLinkState:NO];
}
//anchorPKViewDelegate
- (void)kkClosePKView
{
    [self.playrtmp stopConnect];
}

- (void)removePKView
{
    if (self.pkView) {
        [self.pkView removeFromSuperview];
        self.pkView = nil;
        if (self.isAnchorLink) {
            [self addSubview:self.startPKBtn];
            self.startPKBtn.frame = CGRectMake((KKScreenWidth-80)/2,KKScreenHeight-ShowDiff-50-40, 80, 40);

        }
    }
}


/**
 更改Livebroadcast中的连麦状态
 
 @param islianmai 是否在连麦
 */
- (void)changeLivebroadcastLinkState:(BOOL)islianmai{
    self.isLianmai = islianmai;
}

#pragma mark ======   anchorPKAlertDelegate
- (void)removeShouhuView
{
    if (self.pkAlertView) {
        [self.pkAlertView removeTimer];
        [self.pkAlertView removeFromSuperview];
        self.pkAlertView = nil;
        [self addSubview:self.startPKBtn];
        self.startPKBtn.frame = CGRectMake((KKScreenWidth-80)/2,KKScreenHeight-ShowDiff-50-40, 80, 40);

    }
}

/*
 *添加魅力值数
 */
-(void)addCoin:(NSString *)coin
{
    long long ordDate = [self.votesTatal longLongValue];
    self.votesTatal = [NSString stringWithFormat:@"%lld",ordDate + [coin intValue]];
    [self.kkUserInfoV changeState:self.votesTatal];
}

-(void)expensiveGift:(NSDictionary *)giftData{
    if (!self.haohualiwuV) {
        expensiveGiftV * haohualiwuV = [[expensiveGiftV alloc]init];
        self.haohualiwuV = haohualiwuV;
        [self.kkContentView addSubview:haohualiwuV];
        WeakSelf;
        haohualiwuV.expensiveGiftBlock = ^(NSDictionary *giftData) {
            [weakSelf expensiveGift:giftData];
        };
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
    }
    if (giftData == nil) {
    }
    else
    {
         [self.haohualiwuV addArrayCount:giftData];
    }
    if(self.haohualiwuV.haohuaCount == 0){
        [self.haohualiwuV enGiftEspensive];
    }
}


#pragma mark -- =     //关闭直播做的操作
-(void)kkCloseLiveRoom{
    [self getCloseShow];//请求关闭直播接口
}

//请求关闭直播
-(void)getCloseShow
{
    [[TRTCCloud sharedInstance] exitRoom];
    [[TRTCCloud sharedInstance] stopLocalPreview];
    [[TRTCCloud sharedInstance] stopLocalAudio];
    TXAudioEffectManager *kkAudio = [[TRTCCloud sharedInstance] getAudioEffectManager];
    [kkAudio stopPlayMusic:[[KKChatConfig getOwnID] intValue]];
    [TRTCCloud destroySharedIntance];
    
    
//    [self musicPlay];
    //发送关闭直播的socket
    [self.kkLiveInfoModel.kkSocketLive closeRoom];
    [self.kkLiveInfoModel.kkSocketLive colseSocket];

    //kk六道美颜
    [[FUManager shareManager] destoryItems]; //销毁贴纸及美颜道具。

    [self kkDismissVC];
    [self liveOverTimer];//停止计时器

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [KKChatConfig getOwnID];
    params[@"token"] = [KKChatConfig getOwnToken];
    params[@"stream"] = self.kkRoomDic[@"stream"];

    [KKLiveAPI kk_GetLiveStopRoomInfoWithparameters:params successBlock:^(id  _Nullable response) {
        [self kkstopLiveRoom];
    } failureBlock:^(NSError * _Nullable error) {
        [self kkstopLiveRoom];

    } mainView:self];
    
}

- (void)kkstopLiveRoom
{
    
    NSString *url = [NSString stringWithFormat:@"%@",minstr([self.kkRoomDic valueForKey:@""])];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [self kkShowEndView:subdic];
        }else{
            [self kkShowEndView:nil];
        }
    } fail:^{
        [self kkShowEndView:nil];
    }];

}

- (void)kkShowEndView:(NSDictionary *)dic
{
    KKLiveEndView *kkview = [[KKLiveEndView alloc]init];
    kkview.kkInfoDic = dic;
    WeakSelf;
    kkview.kkGoBackBlock = ^(NSString * _Nonnull string) {
        if ([weakSelf.kkDelegate respondsToSelector:@selector(kkCloseLiveRoom)]) {
            [weakSelf.kkDelegate kkCloseLiveRoom];
        }
    };
    [kkview kkShow];

}

- (void)kkDismissVC
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLiveing"];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [kkNotifCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [kkNotifCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [kkNotifCenter removeObserver:self];

    [self.managerAFH stopMonitoring];
    self.managerAFH = nil;

    if (self.continueGifts) {
        [self.continueGifts stopTimerAndArray];
        [self.continueGifts initGift];
        [self.continueGifts removeFromSuperview];
        self.continueGifts = nil;
    }
    if (self.haohualiwuV) {
        [self.haohualiwuV stopHaoHUaLiwu];
        [self.haohualiwuV removeFromSuperview];
        self.haohualiwuV.expensiveGiftCount = nil;
    }

    if (self.playrtmp) {
        [self.playrtmp stopConnect];
        [self.playrtmp removeFromSuperview];
        self.playrtmp = nil;
    }
}

//直播结束时 停止所有计时器
-(void)liveOverTimer{
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];


}
#pragma mark -- ====================以下是 kk六道相芯美颜==============

/**      FUAPIDemoBarDelegate       **/

-(void)restDefaultValue:(int)type{
    [KKMyBeautyCache clearBeauty];
    
    if (type == 1) {//美肤
       [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeSkin];
    }
    
    if (type == 2) {
       [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeShape];
    }

}
-(void)filterValueChange:(FUBeautyParam *)param{
    //滤镜
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBeauty];
    [FURenderer itemSetParam:handle withName:@"filter_name" value:[param.mParam lowercaseString]];
    [FURenderer itemSetParam:handle withName:@"filter_level" value:@(param.mValue)]; //滤镜程度
    
    [FUManager shareManager].seletedFliter = param;
    
    [KKUserDefaults setValue:param.mParam forKey:@"kkfilter_name"];
    [KKUserDefaults setValue:param.mTitle forKey:@"kkfilter_Title"];
    [KKUserDefaults setObject:[NSString stringWithFormat:@"%f",param.mValue] forKey:@"kkfilter_level"];

}

-(void)beautyParamValueChange:(FUBeautyParam *)param{
    if (_demoBar.selBottomIndex == 3) {//风格栏
        //
        if (param.beautyAllparams) {
            [[FUManager shareManager] setStyleBeautyParams:param.beautyAllparams];
            [FUManager shareManager].currentStyle = param;
            
        }else{// 点击无
            [FUManager shareManager].currentStyle = param;
            [[FUManager shareManager] setBeautyParameters];
        }

        return;
    }
    
    //美肤和美型 都是单个设置的参数
    if ([param.mParam isEqualToString:@"cheek_narrow"] || [param.mParam isEqualToString:@"cheek_small"]){//程度值 只去一半
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue * 0.5];
        [KKUserDefaults setValue:[NSString stringWithFormat:@"%f",param.mValue] forKey:[NSString stringWithFormat:@"kk%@",param.mParam]];

    }else if([param.mParam isEqualToString:@"blur_level"]) {//磨皮 0~6
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue * 6];
        [KKUserDefaults setValue:[NSString stringWithFormat:@"%f",param.mValue] forKey:[NSString stringWithFormat:@"kk%@",param.mParam]];

    }else{
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeauty name:param.mParam value:param.mValue];
        [KKUserDefaults setValue:[NSString stringWithFormat:@"%f",param.mValue] forKey:[NSString stringWithFormat:@"kk%@",param.mParam]];

    }
}

-(void)filterShowMessage:(NSString *)message{
    [MBProgressHUD kkshowMessage:message];
}
-(void)showTopView:(BOOL)shown{
    float h = shown?190:49;
     [_demoBar mas_updateConstraints:^(MASConstraintMaker *make) {

         make.bottom.equalTo(self.kkContentView.mas_bottom).mas_offset(-ShowDiff);
        make.left.right.equalTo(self.kkContentView);
        make.height.mas_equalTo(h);
    }];

}

//初始化美颜
-(void)kksetupView{
//    _demoBar.hidden  = NO;
    [self.kkContentView addSubview:self.demoBar];

    _demoBar.tag=0;
    _demoBar.backgroundColor = [UIColor clearColor];
    [_demoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-ShowDiff);
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(231);
    }];
}
//美颜点击事件
- (void)showFitterView{
    self.kkLivePreview.hidden = YES;
//    _touchv =[[touchview alloc]initWithFrame:CGRectMake(0, 120, KKScreenWidth, KKScreenHeight)];
//    _touchv.delegate = self;
//    _touchv.hidden = NO;

    UIButton *kkBeautyTouchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkBeautyTouchBtn = kkBeautyTouchBtn;
    [self.kkContentView addSubview:kkBeautyTouchBtn];
    [kkBeautyTouchBtn addTarget:self action:@selector(kkBeautyTouchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkBeautyTouchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];
    [self kksetupView];
}

-(void)kkBeautyTouchBtnClick
{
    self.kkLivePreview.hidden = NO;
    [_demoBar removeFromSuperview];
    [self.kkBeautyTouchBtn removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_demoBar.tag == 0) {
    }else{
        [self.demoBar removeFromSuperview];
    }
}

-(void)kkInitBeauty
{
    KKMyBeautyCache *kkBeauty = [KKMyBeautyCache myBeauty];

    //必须进行初始化
    //美型
    [_demoBar reloadShapView:[FUManager shareManager].shapeParams];
    //美肤
    [_demoBar reloadSkinView:[FUManager shareManager].skinParams];
    //滤镜
    [_demoBar reloadFilterView:[FUManager shareManager].filters];
    
    //风格
    [_demoBar reloadStyleView:[FUManager shareManager].styleParams defaultStyle:[FUManager shareManager].currentStyle];
    
    //初始化滤镜
    FUBeautyParam *kkFliter = [[FUBeautyParam alloc]init];
    kkFliter.mTitle =kkBeauty.filter_Title;
    kkFliter.mParam =kkBeauty.filter_name;
    kkFliter.mValue =kkBeauty.filter_level;
    [FUManager shareManager].seletedFliter = kkFliter;
    [_demoBar setDefaultFilter:[FUManager shareManager].seletedFliter];

    
}

#pragma mark -- ====================以上是 kk六道相芯美颜==============



//懒加载
- (adminLists *)adminlist
{
    if (!_adminlist) {

        self.zhezhaoList  = [[UIViewController alloc]init];
        self.zhezhaoList.view.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self.kkContentView addSubview:self.zhezhaoList.view];
        self.zhezhaoList.view.hidden = YES;
        _adminlist = [[adminLists alloc]init];
        _adminlist.delegate = self;
        _adminlist.view.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        [self.kkContentView addSubview:_adminlist.view];
        UITapGestureRecognizer *tapAdmin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adminZhezhao)];
        [self.zhezhaoList.view addGestureRecognizer:tapAdmin];

    }
    return _adminlist;
}


- (KKLiveSocketInfoModel *)kkLiveInfoModel
{
    if (!_kkLiveInfoModel) {
        _kkLiveInfoModel = [[KKLiveSocketInfoModel alloc] init];
        _kkLiveInfoModel.kkSocketDelegate = self;
    }
    return _kkLiveInfoModel;
}

- (UIButton *)startPKBtn
{
    if (!_startPKBtn) {
        _startPKBtn = [UIButton buttonWithType:0];
        [_startPKBtn setBackgroundImage:[UIImage imageNamed:@"发起pk"] forState:UIControlStateNormal];
        [_startPKBtn addTarget:self action:@selector(startPKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startPKBtn;
}

@end
