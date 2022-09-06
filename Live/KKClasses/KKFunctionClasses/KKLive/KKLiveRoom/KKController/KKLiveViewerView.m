//
//  KKLiveViewerView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/17.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveViewerView.h"


#import "userLoginAnimation.h"
#import "continueGift.h"
#import "expensiveGiftV.h"
#import "play_linkMic.h"
#import "anchorPKView.h"
#import "upmessageInfo.h"

#import "catSwitch.h"


#import "impressVC.h"
#import "jubaoVC.h"

//直播观众视图分为5大块，1、顶部用户信息 2、影片播放；3、TRTC连麦 4、用户聊天 5、底部功能
#import "KKUserInfoView.h"
#import "KKLiveVideoView.h"
#import "KKTRTCVoiceView.h"
#import "KKSocketChatView.h"
#import "KKLiveBottomMenuView.h"

#import "KKShowRoomTitleView.h"
#import "KKTextToolBar.h"
#import "KKLiveUserComeRoomAnimationView.h"
#import "KKHorizontalView.h"
#import "KKTRTCVideoView.h"
#import "KKTRTCChoiceVideoView.h"
#import "KKLiveRoomUserOnlineView.h"
#import "KKViewerAnchorMoreFunctionView.h"
#import "KKLiveGiftView.h"
#import "KKCommendatoryLiveRoomView.h"
#import "KKConnectMicrophoneView.h"
#import "KKLiveEndView.h"

#import "KKLiveViewerInfoModel.h"

#import "PersonMessageViewController.h"
#import "KKWebH5ViewController.h"
#import "KKMyPayMoneyViewController.h"


#import "AudioEffectSettingView.h"
#import <TXLiteAVSDK_Professional/TRTCCloud.h>
#import "GKDouyinScrollView.h"

#import "TRTCLiveRoom.h"

#define upViewH     296

//kk顶部显示用户入场动画高度 40
#define kkuseraimationH 21.33
//kk底部显示用户入场动画高度 40
#define kkBottomUserNameH     50

@interface KKLiveViewerView ()<haohuadelegate,play_linkmic,anchorPKViewDelegate,upmessageKickAndShutUp,frontviewDelegate>

//是否横屏
@property (nonatomic,assign) BOOL kkIsShowHorizontalView;
//连麦相关
@property (nonatomic,assign) int isshow;
@property (nonatomic,assign) BOOL ksynotconnected;
@property (nonatomic,assign) BOOL ksyclosed;
@property (nonatomic,assign) BOOL haslianmai;//是不是在连麦
@property (nonatomic,assign) BOOL isRegistLianMai;////判断连麦注册成功


@property (nonatomic,assign) BOOL giftViewShow;//是否显示礼物view

@property (nonatomic,assign) BOOL isSuperAdmin;//

//判断tableview可不可以滑动
@property (nonatomic,assign) BOOL canScrollToBottom;
@property(strong,nonatomic)NSMutableArray *msgList;

//等级
@property (nonatomic,copy) NSString * level;

@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *chatModels;//模型数组
@property (nonatomic,assign) long long userCount;//用户数量
@property (nonatomic,copy) NSString * titleColor;//判断 回复颜色

@property (nonatomic,assign) BOOL isRotationGame;//判断游戏


@property (nonatomic,assign) int coasttime;//扣费计时

@property(strong,nonatomic)UIAlertController *md5AlertController;

@property(weak,nonatomic)UIButton *redBagBtn;


@property(weak,nonatomic)userLoginAnimation *useraimation;//进场动画(横条飘进)
//魅力值
@property (nonatomic,copy) NSString * votesTatal;

@property(strong,nonatomic) continueGift *continueGifts;//连送礼物
@property(weak,nonatomic)UIView *kkContinuousView;//连送视图
@property (nonatomic,copy)  NSString *haohualiwu;//判断豪华礼物

@property(weak,nonatomic)expensiveGiftV *haohualiwuV;//豪华礼物

//发起连麦进行11S的倒计时
@property (nonatomic,assign) int startLinkTime;
@property (nonatomic,copy) NSString *myplayurl;
@property (nonatomic,copy) NSString * kkmyPushurl;

@property(weak,nonatomic)play_linkMic *playrtmp;//连麦小窗口

@property(weak,nonatomic)anchorPKView *pkView;

@property(weak,nonatomic)KKLiveGiftView *giftview;


@end

@interface KKLiveViewerView ()<KKLiveViewerSocketDelegate,KKHorizontalViewDelegate,KKLiveBottomMenuViewDelegate,KKSocketChatViewDelegate,KKLiveGiftViewDelegate,TRTCCloudDelegate>

//@property(weak,nonatomic)UIScrollView *backScrollView;
@property(weak,nonatomic)GKDouyinScrollView *backScrollView;


@property(weak,nonatomic)UIView *kkContentView;
@property(weak,nonatomic)UIButton *kkCoverBtn;

@property(weak,nonatomic)UIImageView *kkBgImgV;//直播背景图
@property(weak,nonatomic)UIImageView *kkTRTCBgImgV;//

//背景毛玻璃
@property(weak,nonatomic)UIVisualEffectView *kkBGImgEffectV;//
//收费房间的遮罩
@property(weak,nonatomic)UIVisualEffectView *kkBGCoverEffectV;

@property(weak,nonatomic)KKUserInfoView *kkUserInfoV;
@property(weak,nonatomic)KKLiveVideoView *kkVideoView;
@property(weak,nonatomic)KKTRTCVoiceView *kkTRTCVoiceV;
@property(weak,nonatomic)KKLiveBottomMenuView *kkBottomMenuView;
@property(weak,nonatomic)KKSocketChatView *kkChatView;
@property(weak,nonatomic)KKConnectMicrophoneView *kkConnectMicrophoneV;

//显示推荐主播
@property(weak,nonatomic)UIButton *kkShowCommendatoryLiveBtn;

//房间数据，socket数据
@property(strong,nonatomic)KKLiveViewerInfoModel *kkLiveInfoModel;

@property (nonatomic,copy) NSString * kkType_val;//房间价格
//1、密码房间  2、门票房间  3、计时房间
@property (nonatomic,copy) NSString * kkLivetype;//房间类型
//1.8六道添加，用于解决密码房间没模糊遮罩问题
@property (nonatomic,assign) BOOL kkIsCanWatch;


//用户入场显示主播标题
@property(weak,nonatomic)KKShowRoomTitleView *kkShowRoomTitleView;
//聊天输入框
@property(weak,nonatomic)KKTextToolBar *kktextToolBar;

//普通用户进场动画
@property(weak,nonatomic)KKLiveUserComeRoomAnimationView *kkUserComeInAnimationView;


@property(weak,nonatomic)UIButton *kkHorizontalBtn;

//中奖动画
@property(strong,nonatomic)NSMutableArray *kkLotteryInfoArr;


//横屏
@property(weak,nonatomic)KKHorizontalView *kkHorizontalView;

//主播所有房间信息
@property(strong,nonatomic)NSDictionary *kkLiveAllInfoDic;

@property(weak,nonatomic)KKTRTCVideoView *kkTRTCVideoView;


//视频选择
@property(strong,nonatomic)KKTRTCChoiceVideoView *kkChoiceVideoView;

//是否是trtc房间
@property (nonatomic,assign) BOOL kkIsTRTC;

//底部更多功能视图
@property(weak,nonatomic)KKViewerAnchorMoreFunctionView *kkMoreFunctionView;

@property (nonatomic,strong) KKLiveEndView *kkLiveEndV;


@end

@implementation KKLiveViewerView

//视频选择
- (KKTRTCChoiceVideoView *)kkChoiceVideoView
{
    if (!_kkChoiceVideoView) {
        _kkChoiceVideoView = [[KKTRTCChoiceVideoView alloc]init];
        [self addSubview:_kkChoiceVideoView];
        _kkChoiceVideoView.kkIsAnchor = NO;
        _kkChoiceVideoView.kkRoomType = 1;
        [_kkChoiceVideoView kkRefreshData];

        WeakSelf;
        _kkChoiceVideoView.kkShowVideoURLAlertBlock = ^(UIAlertController * _Nonnull alert) {
            if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
                [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:alert];
            }
        };
//        _kkChoiceVideoView.kkSelectVideoURLBlock = ^(NSString * _Nonnull url) {
//            [weakSelf.kkTRTCVideoView kkChangeVideoURL:url];
//            [weakSelf.kkChoiceVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.mas_equalTo(0);
//            }];
//        };
        _kkChoiceVideoView.kkCloseViewBlock = ^(NSString * _Nonnull url) {
            weakSelf.kkChoiceVideoView.hidden = YES;
        };
        _kkChoiceVideoView.kkUserSelectVideoBlock = ^(NSMutableDictionary * _Nonnull dic) {
            [weakSelf.kkTRTCVoiceV kkSendRoomCustomMsg:dic];
        };

    }
    return _kkChoiceVideoView;
}


- (void)kkPortraitBtnClick
{
    if ([self.kkViewerViewDelegate respondsToSelector:@selector(kkPortraitBtnClick)]) {
        [self.kkViewerViewDelegate kkPortraitBtnClick];
    }
}
//横屏
- (void)kkShowHorizontalView:(KKHorizontalView *)kkHorizontalView
{
    self.kkHorizontalView = kkHorizontalView;
    kkHorizontalView.kkHorizontalViewDelegate = self;
    self.kkIsShowHorizontalView = YES;

    [self.kkHorizontalView insertSubview:self.kkVideoView.kkPlayerView atIndex:0];
    [self.kkVideoView.kkPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(kkHorizontalView);
    }];

//    toolBar
    [self.kkHorizontalView addSubview:self.kktextToolBar];
    self.kktextToolBar.kkIsHorizontal = self.kkIsShowHorizontalView;

    self.kkHorizontalView.kkRowDataArr = self.kkBottomModel.kkContArr;
    self.kkHorizontalView.kkLiveDic = self.kkLiveInfo;

    [self kkLayoutFrame];

}

#pragma mark ====横屏代理事件
- (void)kkHorizontalCycleScrollViewDidSelectWithUrl:(NSString *)url
{
    [self kkPortraitBtnClickBlock];
    [self kkcycleScrollViewDidSelectWithUrl:url];
}
//轮播图
- (void)kkcycleScrollViewDidSelectWithUrl:(NSString *)url
{
     KKWebH5ViewController *VC = [[KKWebH5ViewController alloc]init];
     VC.urls = [NSString kk_AppendH5URL:url];
     VC.titles = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//
- (void)kkgongxianbang
{
    [self kkPortraitBtnClickBlock];
}
//
- (void)kkZhuboInfoClick
{
    NSDictionary *subdic = @{@"id":[self.kkLiveInfo valueForKey:@"uid"]};
    CGRect kkUserViewR = CGRectMake(KKScreenWidth -KKScreenHeight - ShowDiff,(KKScreenHeight - (upViewH - 30))/2 ,KKScreenHeight,upViewH -30);

    upmessageInfo  *userView = [[upmessageInfo alloc]initWithFrame:kkUserViewR  andPlayer:@""];
    //添加用户列表弹窗
    userView.upmessageDelegate = self;
    userView.frame= kkUserViewR;
    [userView kkShowView];
    [userView getUpmessgeinfo:subdic andzhuboDic:self.kkLiveInfo];
    
}


//切成竖屏
- (void)kkPortraitBtnClickBlock
{
    WeakSelf;
    self.kkIsShowHorizontalView = NO;
    self.giftview.kkIsShowHorizontalView = NO;

    [kkNotifCenter postNotificationName:kkVerticalBtnClickNotif object:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [weakSelf kkPortraitLayout];
    });
}

- (void)kkPortraitLayout
{

    WeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.kkHorizontalView.alpha = 0.7;
        weakSelf.kkHorizontalView.frame = self.kkVideoView.bounds;
    } completion:^(BOOL finished) {
        [self.kkVideoView addSubview:self.kkVideoView.kkPlayerView];
        [self.kkVideoView.kkPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.kkVideoView);
        }];
        weakSelf.kkHorizontalView.hidden = YES;

        [self.kkLiveInfoModel kkStarMove];
    //
        [weakSelf.kkContentView addSubview:self.kktextToolBar];
        weakSelf.kktextToolBar.kkIsHorizontal = self.kkIsShowHorizontalView;

    }];

    [self.backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];

    [self kkLayoutFrame];
}

- (void)kkTextBtnClick
{
    [self.kktextToolBar.kkTextField becomeFirstResponder];
    
}
//清屏

- (void)kkContentViewClearClick
{
    
    [self.kkLiveInfoModel kkStarMove];
    [UIView animateWithDuration:0.5 animations:^{
        self.giftview.frame = CGRectMake(KKScreenWidth, 0, KKScreenHeight, KKScreenHeight);

    } completion:^(BOOL finished) {
        [self.giftview removeFromSuperview];
        self.giftview  = nil;
    }];
    [self.kktextToolBar.kkTextField resignFirstResponder];
    [self kkCoverClick];

}

//礼物
- (void)kkHorizontalGiftBtnClick
{
    [self kkgiftViewShow];

    self.giftview.frame = CGRectMake(KKScreenWidth+200, 0, KKScreenHeight, KKScreenHeight);
    [UIView animateWithDuration:0.1 animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.giftview.frame = CGRectMake(KKScreenWidth - KKScreenHeight - ShowDiff - 10, 0, KKScreenHeight, KKScreenHeight);
        }];
        [self.giftview kkLayoutFrame:KKScreenHeight];

    }];

}
- (void)kkgiftViewShow
{
    [self kkGiftBtnClick];
    
}

#pragma mark ======= 以上是横屏处理

- (NSMutableArray *)kkLotteryInfoArr
{
    if (!_kkLotteryInfoArr) {
        _kkLotteryInfoArr = [NSMutableArray array];
    }
    return _kkLotteryInfoArr;
}


//列表信息退出
-(void)doCancle{

//    self.tableView.userInteractionEnabled = YES;
}

- (void)kkCoverBtnClick
{
    [self kkCoverClick];
}

-(void)kkCoverClick
{
    [self.giftview removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
       [self changeGiftViewFrameY:_window_height *3];
    }];

    [self changecontinuegiftframe];
    
    [self.kkLiveInfoModel kkStarMove];
    [self.kktextToolBar.kkTextField resignFirstResponder];

    [self kkLayoutFrame];
}


#pragma  mark  顶部主播信息视图代理事件

//点击主播弹窗
-(void)zhubomessage
{
    NSDictionary *subdic = @{@"id":[self.kkLiveInfo valueForKey:@"uid"]};
    [self GetInformessage:subdic];
}

#pragma mark =============  普通用户列表 头像 点击弹窗
-(void)GetInformessage:(NSDictionary *)subdic{

    CGRect kkUserViewR = CGRectMake(0,KKScreenHeight -upViewH ,KKScreenWidth,upViewH);
    upmessageInfo  *userView = [[upmessageInfo alloc]initWithFrame:kkUserViewR  andPlayer:@""];
    //添加用户列表弹窗
    userView.upmessageDelegate = self;
    userView.frame= kkUserViewR;
    [userView kkShowView];
    [userView getUpmessgeinfo:subdic andzhuboDic:self.kkLiveInfo];
}
//关注zhubo
-(void)guanzhuZhuBo
{
    [self.kkLiveInfoModel.socketDelegate attentionLive:self.level];

}
////在线人数点击事件
- (void)kkOnLinePersonBtnClick
{
    KKLiveRoomUserOnlineView *view = [[KKLiveRoomUserOnlineView alloc] init];
    view.kkLiveID = self.kkLiveInfo[@"uid"];
    view.kkStream = self.kkLiveInfo[@"stream"];
    WeakSelf;
    view.kkDidSelectItemBlock = ^(NSDictionary * _Nonnull dic) {
        [weakSelf GetInformessage:dic];
    };
    [view kkShow];
}

#pragma  mark === ////关闭直播间
- (void)kkRoomCloseBtnClick
{
    if (self.kkIsTRTC) {
        [self.kkTRTCVoiceV kkExitRoom];
        [self.kkTRTCVideoView kkResetPlayer];
        
    }else{
        if (!self.kkIsCanWatch) {
            NSDictionary *kkdic = self.kkLiveInfo;
            [kkdic setValue:@"" forKey:@"pull"];
        }
        
        int kktype = [[KKUserDefaults valueForKey:kkPIPSwitch] intValue];
        if (kktype) {
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
            [infoDic setValue:[NSString stringWithFormat:@"%zd",self.kkcurrentSelectItemIndex] forKey:@"kkPIPCurrentIndex"];
            //发送通知开启画中画
            [[NSNotificationCenter defaultCenter] postNotificationName:kkStartPipWithObject object:self.kkScrollarray userInfo:infoDic];
        }

    }
    
    //关闭直播间有时会产生两个悬浮窗，可能是多次发送通知导致的，
    [self dissmissVC];

}

#pragma mark === 用户信息弹框代理事件
//禁言
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID
{
    [self.kkLiveInfoModel.socketDelegate shutUp:name andID:ID];
}
//踢人
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID
{
    [self.kkLiveInfoModel.socketDelegate kickuser:name andID:ID];
}
//去主播主页
-(void)pushZhuYe:(NSString *)IDS
{
    if (self.kkIsShowHorizontalView) {
        [self kkPortraitBtnClickBlock];
    }

    [self kkpushpersonal:IDS];
}


- (void)kkpushpersonal:(NSString *)uid
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = uid;
    [KKMyAPI kk_PostUserTypeInfoWithParameters:param successBlock:^(id  _Nullable response) {
        
        if ([response[@"status"] intValue] == 1) {
            NSString *kkstr = [NSString kk_isNullString:response[@"isauth"]];
            if ([kkstr isEqualToString:@"1"]) {
                //主播
                [self doCancle];
                PersonMessageViewController *rVC = [[PersonMessageViewController alloc]init];
                rVC.kkLiveUid = uid;
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
//关注主播
-(void)doUpMessageGuanZhu:(NSString *)kkIsAttention
{
    [self.kkUserInfoV kkIsAttention:kkIsAttention];
}

//用户弹框发送消息
-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID andIsatt:(NSString *)isatt{
    //    kk六道添加
    [self doCancle];
    [self.kktextToolBar.kkTextField becomeFirstResponder];
    self.kktextToolBar.kkTextField.text = [NSString stringWithFormat:@"@%@",name];
}

-(void)doupCancle
{
    [self doCancle];
}

-(void)superAdmin:(NSString *)state
{
    [self.kkLiveInfoModel.socketDelegate superStopRoom];
    self.haohualiwuV.expensiveGiftCount = nil;
//    [self releaseObservers];
    [self kklastView];
}
//===举报=============
-(void)doReportAnchor:(NSString *)touid{
    if (self.kkIsShowHorizontalView) {
        [self kkPortraitBtnClickBlock];
    }

    [self doCancle];
    jubaoVC *vc = [[jubaoVC alloc]init];
    vc.dongtaiId = touid;
    vc.isLive = YES;

    [[MXBADelegate sharedAppDelegate]  pushViewController:vc animated:YES];
}




#pragma  mark ========================== 初始化房间

- (void)setKkIsCanWatch:(BOOL)kkIsCanWatch
{
    _kkIsCanWatch = kkIsCanWatch;
    if (kkIsCanWatch) {
        self.kkBGCoverEffectV.hidden = YES;
    }else{
        self.kkBGCoverEffectV.hidden = NO;
    }
}


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.kkIsCanPlay = NO;
        //添加子控件
        [self kkInitView];
    }
    return self;
}

- (void)kkInitView
{
    UIImageView *kkBGImgV = [[UIImageView alloc]init];
    self.kkBgImgV = kkBGImgV;
    [self addSubview:kkBGImgV];
    kkBGImgV.contentMode = UIViewContentModeScaleToFill;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.kkBGImgEffectV = effectview;
    [kkBGImgV addSubview:effectview];
    
    
    UIImageView *kkTRTCBgImgV = [[UIImageView alloc]init];
    self.kkTRTCBgImgV = kkTRTCBgImgV;
    [self addSubview:kkTRTCBgImgV];
    kkTRTCBgImgV.contentMode = UIViewContentModeScaleToFill;
    kkTRTCBgImgV.image = [UIImage imageNamed:@"TRTCVoiceRoom_bgImgV_icon"];
    kkTRTCBgImgV.hidden = YES;
    
    KKLiveVideoView *kkVideoView = [[KKLiveVideoView alloc] init];
    self.kkVideoView = kkVideoView;
    [self addSubview:kkVideoView];

//    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    GKDouyinScrollView * backScrollView = [[GKDouyinScrollView alloc]init];
    
    self.backScrollView = backScrollView;
    [self addSubview:backScrollView];
    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
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
    
    UIBlurEffect *kkblur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *kkBGCoverEffectV = [[UIVisualEffectView alloc] initWithEffect:kkblur];
    self.kkBGCoverEffectV = kkBGCoverEffectV;
    [kkContentView addSubview:kkBGCoverEffectV];
    kkBGCoverEffectV.hidden = YES;

    UIButton *kkCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkCoverBtn = kkCoverBtn;
    [self.kkContentView addSubview:kkCoverBtn];
    [kkCoverBtn addTarget:self action:@selector(kkCoverClick) forControlEvents:UIControlEventTouchUpInside];
    
    KKUserInfoView *kkUserInfoV = [[KKUserInfoView alloc] init];
    self.kkUserInfoV = kkUserInfoV;
    [self.kkContentView addSubview:kkUserInfoV];
    kkUserInfoV.frontviewDelegate = self;
    WeakSelf;

    KKTRTCVideoView *kkTRTCVideoView = [[KKTRTCVideoView alloc]init];
    self.kkTRTCVideoView = kkTRTCVideoView;
    [self.kkContentView addSubview:kkTRTCVideoView];
    kkTRTCVideoView.kkIsAnchor = NO;

    kkTRTCVideoView.kkShowVideoURLAlertBlock = ^(UIAlertController * _Nonnull alert) {
        if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
            [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:alert];
        }
    };
    kkTRTCVideoView.kkChoiceVideoBlock = ^(NSString * _Nonnull str) {
        weakSelf.kkChoiceVideoView.hidden = NO;
        [weakSelf.kkChoiceVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf);
        }];
    };
    kkTRTCVideoView.kkChangeWebURLBlock = ^(NSDictionary * _Nonnull dic) {
        weakSelf.kkChoiceVideoView.hidden = NO;
        [weakSelf.kkChoiceVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf);
        }];
        [weakSelf.kkChoiceVideoView kkChangeWebURL:dic];
    };
    kkTRTCVideoView.kkVideoProgressChangeBlock = ^(CGFloat progress) {
        NSMutableDictionary *kkdic = [NSMutableDictionary dictionary];
        kkdic[@"progress"] = @(progress);
        [weakSelf.kkTRTCVoiceV kkSendVideoCustomMsg:kkdic andMsgUID:@"4"];
    };
    kkTRTCVideoView.hidden = YES;

    KKTRTCVoiceView *kkTRTCVoiceV = [[KKTRTCVoiceView alloc] init];
    self.kkTRTCVoiceV = kkTRTCVoiceV;
    [self.kkContentView addSubview:kkTRTCVoiceV];

    kkTRTCVoiceV.kkShowAlertMicrophoneBlock = ^(UIAlertController * _Nonnull alert) {
        if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
            [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:alert];
        }
    };
    kkTRTCVoiceV.kkVideoInfoBlock = ^(NSDictionary * _Nonnull dic) {
        [weakSelf.kkTRTCVideoView kkChangeVideoInfo:dic];
    };
    kkTRTCVoiceV.kkVideoProgressChangeBlock = ^(NSString * _Nonnull progress) {
        [weakSelf.kkTRTCVideoView kkVideoProgressChange:progress];
    };
    kkTRTCVoiceV.hidden = YES;
    
    UIButton *kkShowCommendatoryLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkShowCommendatoryLiveBtn = kkShowCommendatoryLiveBtn;
    [self.kkContentView addSubview:kkShowCommendatoryLiveBtn];
    [kkShowCommendatoryLiveBtn setImage:[UIImage imageNamed:@"KKShowCommendatoryLiveRoomV"] forState:UIControlStateNormal];
    kkShowCommendatoryLiveBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 13, 10, 0);
    [kkShowCommendatoryLiveBtn addTarget:self action:@selector(kkShowCommendatoryLiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(kkShowCommendatoryLiveBtnClick)];
    [self.backScrollView addGestureRecognizer:recognizer];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    KKSocketChatView *kkChatView = [[KKSocketChatView alloc] init];
    self.kkChatView = kkChatView;
    [self.kkContentView addSubview:kkChatView];
    kkChatView.kkChatViewDelegate = self;
    
    KKLiveBottomMenuView *kkBottomMenuView = [[KKLiveBottomMenuView alloc] init];
    self.kkBottomMenuView = kkBottomMenuView;
    [self.kkContentView addSubview:kkBottomMenuView];
    kkBottomMenuView.kkBottomMenuViewDelegate = self;
    
    //用户连麦
    KKConnectMicrophoneView *kkConnectMicrophoneV = [[KKConnectMicrophoneView alloc]init];
    self.kkConnectMicrophoneV = kkConnectMicrophoneV;
    [self.kkContentView addSubview:kkConnectMicrophoneV];
//    kkConnectMicrophoneV.hidden = YES;
    kkConnectMicrophoneV.kkConnectBtnClickBlock = ^(NSString * _Nonnull string) {
        [weakSelf kkUserConnectLive];
    };
    kkConnectMicrophoneV.kkDisconnectBtnClickBlock = ^(KKConnectMicrophoneView * _Nonnull view) {
        [weakSelf kkUserAndAnchorCloseconnect];
    };
    
    
    [self kkInitFunctionView];
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

    KKShowRoomTitleView *kkTitleV =  [[KKShowRoomTitleView alloc]init];
    self.kkShowRoomTitleView = kkTitleV;
    [self.kkContentView addSubview:self.kkShowRoomTitleView];
    self.kkShowRoomTitleView.backgroundColor = [KKWhiteColor colorWithAlphaComponent:0];
    self.kkShowRoomTitleView.hidden = YES;

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
    kkContinuousView.hidden = YES;
    
    UIButton *kkHorizontalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkHorizontalBtn = kkHorizontalBtn;
    [self addSubview:kkHorizontalBtn];
    [_kkHorizontalBtn setImage:[UIImage imageNamed:@"KKHorizontalView_icon"] forState:UIControlStateNormal];
    [_kkHorizontalBtn addTarget:self action:@selector(kkPortraitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _kkHorizontalBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
//    kkHorizontalBtn.hidden = YES;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self kkLayoutFrame];
}

- (void)kkHorizontalLayoutFrame
{
    
}

- (void)kkLayoutFrame
{
    [self.kkBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkBGImgEffectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkBgImgV);
    }];
    [self.kkTRTCBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    WeakSelf;
    [self.kkVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([(NSString *)[weakSelf.kkLiveInfo valueForKey:@"anyway"] isEqualToString:@"0"]) {
//            make.edges.mas_equalTo(self);//切换房间会导致高度无法变化
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(KKScreenHeight);

        }else{
            make.top.mas_equalTo(100+ kkStatusbarH +30);//215 100+ kkStatusbarH
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(KKScale_Height_i7(200));//200
        }
    }];

    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KKScreenWidth);//
        make.top.width.height.mas_equalTo(self.backScrollView);
    }];
    [self.kkBGCoverEffectV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];
    
    [self.kkCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];
    
    [self.kkUserInfoV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(100+ kkStatusbarH);//215
    }];
    
    [self.kkTRTCVoiceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkUserInfoV.mas_bottom).mas_offset(KKScale_Height_i7(200)+10);//210
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(164);

    }];
    [self.kkTRTCVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkUserInfoV.mas_bottom);
        make.left.right.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(self.kkTRTCVoiceV.mas_top).mas_offset(-1);
    }];

    [self.kkShowCommendatoryLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(self.kkUserInfoV.mas_bottom).mas_offset(50);
        make.width.mas_equalTo(40);
//        make.width.mas_equalTo(200);
        make.height.mas_equalTo(70);
    }];
    
    [self.kkBottomMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ShowDiff));
        make.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.kkChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-5);
        make.top.mas_equalTo(self.kkTRTCVoiceV.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.kkContentView);
    }];
    
    [self.kkConnectMicrophoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-5);
        make.width.height.mas_equalTo(90);
    }];
    
    [self kkLayoutFunctionView];
}

- (void)kkLayoutFunctionView
{
    [self.kkShowRoomTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6.6);
        make.bottom.mas_equalTo(self.kkUserInfoV.mas_bottom);
        make.width.mas_equalTo(200 + 25);
        make.height.mas_equalTo(25);
    }];

    if (self.kkIsShowHorizontalView) {
        [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(self.kkHorizontalView);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.kkHorizontalView.mas_bottom).mas_offset((44+ ShowDiff));
        }];
    }else{
        [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(self.kkContentView);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(self.kkContentView.mas_bottom);
        }];

    }
//    [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.width.mas_equalTo(self.kkContentView);
//        make.height.mas_equalTo(44);
//        make.top.mas_equalTo(self.kkContentView.mas_bottom);
//    }];
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
        make.bottom.mas_equalTo(self.kkChatView.mas_top).mas_offset(-30);
        make.width.mas_equalTo(KKScreenWidth);//300
        make.height.mas_equalTo(140);
    }];
    
    
    [self.kkHorizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkVideoView.mas_right).mas_offset(-6);
        make.bottom.mas_equalTo(self.kkVideoView.mas_bottom).mas_offset(-6);
        make.width.height.mas_equalTo(44);
    }];
    
}


//初始化数据
- (void)setKkLiveInfo:(NSDictionary *)kkLiveInfo
{
    _kkLiveInfo = kkLiveInfo;
//    self.kkVideoView.anyway = [kkLiveInfo valueForKey:@"anyway"];
    
    [self.kkBgImgV sd_setImageWithURL:[NSURL URLWithString:[kkLiveInfo valueForKey:@"avatar"]]];
    self.kkVideoView.kkLiveInfo = kkLiveInfo;
    self.kkUserInfoV.zhuboDic = kkLiveInfo;
    self.kkTRTCVoiceV.kkLiveInfo = kkLiveInfo;

    [self kkLayoutFrame];
    
    [self kkInitNotifi];
    
}

- (void)setKkIsCanPlay:(BOOL)kkIsCanPlay
{
    _kkIsCanPlay = kkIsCanPlay;
    [self.kkTRTCVoiceV kkExitRoom];//
    [self.kkTRTCVideoView kkResetPlayer];

    [self kkstopPreviousInfo];

//    [self kkchangeRoomUpdateData];
    [self.kkChatView kkResetData];

    if (kkIsCanPlay) {

        //建立socket
        self.kkLiveInfoModel.livetype = self.kkLivetype;
        [self.kkLiveInfoModel kkLoadLiveViewerInfo:self.kkLiveInfo];
        self.kkConnectMicrophoneV.kkLiveDic = self.kkLiveInfo;
        
        if ([self.kkLiveInfo[@"livetypee"] intValue] == 1) {
            
//           普通直播
            self.kkConnectMicrophoneV.hidden = NO;

             self.kkIsTRTC  = NO;
            self.kkBottomMenuView.kkIsTRTC = NO;
            self.kkVideoView.kkIsCanPlay = kkIsCanPlay;

            [self kkCheckLive:self.kkLiveInfo];

            if ([(NSString *)[self.kkLiveInfo valueForKey:@"anyway"] isEqualToString:@"0"]) {
                self.kkHorizontalBtn.hidden = YES;
            }else{
                self.kkHorizontalBtn.hidden = NO;
            }
            self.kkTRTCVideoView.hidden = YES;
            self.kkVideoView.hidden = NO;
            self.kkTRTCVoiceV.hidden = YES;

        }else if ([self.kkLiveInfo[@"livetypee"] intValue] == 2){
//           TRTC语音聊天室
            self.kkConnectMicrophoneV.hidden = YES;

            self.kkIsTRTC  = YES;
            self.kkBottomMenuView.kkIsTRTC = YES;

            self.kkTRTCVideoView.hidden = NO;
            self.kkVideoView.hidden = YES;
            self.kkTRTCVoiceV.hidden = NO;

//            self.kkTRTCVoiceV.kkIsLive = NO;
            //在这判断是否是TRTC房间，是否是横屏
            self.kkHorizontalBtn.hidden = YES;
            self.kkTRTCBgImgV.hidden = NO;
        }

        //测试
//        self.kkIsTRTC  = YES;
//        self.kkTRTCVideoView.hidden = NO;
//        self.kkVideoView.hidden = YES;
//        self.kkTRTCVoiceV.hidden = NO;
//        self.kkTRTCVoiceV.kkIsLive = NO;
//        //在这判断是否是TRTC房间，是否是横屏
//        self.kkHorizontalBtn.hidden = YES;

        //        self.kkTRTCBgImgV.hidden = NO;
        
    }else{
        //  退出房间的逻辑
//        [self kkstopPreviousInfo];
    }
    
}


#pragma mark ====== kk六道检查房间类型 并初始化房间
-(void)kkCheckLive:(NSDictionary *)kkRoomDic
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"liveuid"] = [kkRoomDic valueForKey:@"uid"];
    param[@"stream"] = [kkRoomDic valueForKey:@"stream"];
    WeakSelf;
    [KKLiveAPI kk_PostCheckLiveInfoWithparameters:param successBlock:^(id  _Nullable response) {
        NSDictionary *dicJson = response;
        NSNumber *number = [dicJson valueForKey:@"ret"];
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [dicJson valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                //收费房间价格,默认0
                weakSelf.kkType_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                //房间类型
                weakSelf.kkLivetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                if ([type isEqual:@"0"]) {
                    //能进入的话再加载数据kk六道
                    weakSelf.kkIsCanWatch = YES;
                    [self kkchangeRoomUpdateData];
                }
                else if ([type isEqual:@"1"]){
                    weakSelf.kkIsCanWatch = NO;//1.8六道添加
                    NSString *_MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    //密码
                    weakSelf.md5AlertController = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"该房间为密码房间") preferredStyle:UIAlertControllerStyleAlert];
                    //添加一个取消按钮
                    [weakSelf.md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        weakSelf.kkIsCanWatch = NO;

                    }]];
                    
                    //在AlertView中添加一个输入框
                    [weakSelf.md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"请输入密码";
                    }];
                    
                    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
                    [weakSelf.md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *alertTextField = weakSelf.md5AlertController.textFields.firstObject;
                        //输出 检查是否正确无误
                        NSLog(@"你输入的文本%@",alertTextField.text);
                        if ([_MD5 isEqualToString:[NSString kkStringToMD5:alertTextField.text]]) {
                            weakSelf.kkIsCanWatch = YES;

                            //能进入的话再加载数据kk六道
                            [self kkchangeRoomUpdateData];

                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:YZMsg(@"密码错误")];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
                                    [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:weakSelf.md5AlertController];
                                    }
                            });

//                            if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
//                                [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:self.md5AlertController];
//                            }

                            return ;
                        }
                        
                    }]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakSelf.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
                            [weakSelf.kkViewerViewDelegate kkShowAlertMicrophone:weakSelf.md5AlertController];
                        }
                    });


                    //present出AlertView
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[MXBADelegate sharedAppDelegate] presentViewController:self.md5AlertController animated:YES completion:nil];
//
//                    });
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){

                    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:minstr([info valueForKey:@"type_msg"]) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        weakSelf.kkIsCanWatch = NO;
                    }];
                    [alertContro addAction:cancleAction];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                       
                        weakSelf.kkIsCanWatch = YES;
                        //能进入的话再加载数据kk六道
                        [self kkchangeRoomUpdateData];
                        [weakSelf doCoast];
                    }];
                    [alertContro addAction:sureAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[MXBADelegate sharedAppDelegate] presentViewController:alertContro animated:YES completion:nil];
                    });

                }
                
            }else if ([code intValue] == 1005)
            {
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
                if (self.kkLiveEndV) {
                    [self.kkLiveEndV removeFromSuperview];
                }
                [self.kkContentView addSubview:self.kkLiveEndV];
                self.kkLiveEndV.hidden = NO;
                NSMutableDictionary *kkdic = [NSMutableDictionary dictionaryWithDictionary:self.kkLiveInfo];
                kkdic[@"length"] = @"0";
                kkdic[@"votes"] = @"0";
                kkdic[@"nums"] = @"0";
                self.kkLiveEndV.kkUserInfoDic = kkdic;
                [self.kkLiveEndV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self.kkContentView);
                }];
            }
            else {
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }//ret 200判断
        
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:nil];
    
}
//检查房间后，需要初始化的数据
- (void)kkchangeRoomUpdateData
{
    //建立socket
//    self.kkLiveInfoModel.livetype = self.kkLivetype;
//    [self.kkLiveInfoModel kkLoadLiveViewerInfo:self.kkLiveInfo];

    [self kkchangePlayVideo];
    
    [self kkInitRoomInfo];
}

//切换下个直播数据
- (void)kkchangePlayVideo
{
    if (!self.kkLiveInfo) {
        return;
    }
    NSString *kkpull = [self.kkLiveInfo valueForKey:@"pull"];
    if (!kkpull.length) {
        //直播结束
        [self kklastView];
    }
//    self.kkVideoView.kkIsCanPlay = YES;
    
}

- (void)kkInitRoomInfo
{
    //更新用户配置信息
    [self kkInitBuild];
    
    //显示进场标题
    [self showTitle];
//    [self kkloadBottomData];
}

- (void)kkInitNotifi
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


#pragma mark -- ===================显示进场标题,主播填写的直播标题  ,底部功能视图
- (void)showTitle
{
    NSString * kktitleStr = [self.kkLiveInfo valueForKey:@"title"];

    if (kktitleStr.length <= 0) {
        self.kkShowRoomTitleView.hidden = YES;
        return;
    }
    self.kkShowRoomTitleView.kkShowRoomTitleDic = self.kkLiveInfo;
    self.kkShowRoomTitleView.hidden = NO;
    if (kktitleStr.length>15) {
        [self.kkShowRoomTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6.6);
            make.bottom.mas_equalTo(self.kkUserInfoV.mas_bottom);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(25);
        }];
    }else{
        CGFloat kktitleLabW = [NSString kk_stringBoundsWithTitleString:kktitleStr andFontOfSize:13 rectSizeRate:1].size.width;
        if (kktitleLabW <67) {
            kktitleLabW = kktitleLabW;
        }else{
            kktitleLabW = kktitleLabW;
        }
        
        [self.kkShowRoomTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6.6);
            make.bottom.mas_equalTo(self.kkUserInfoV.mas_bottom);
            make.width.mas_equalTo(kktitleLabW);
            make.height.mas_equalTo(25);
        }];

    }
    
}


//检查完房间后的初始化数据
- (void)kkInitBuild
{
    self.kkIsShowHorizontalView = NO;
    
    self.ksynotconnected = NO;
    self.ksyclosed = NO;
    self.isshow = 0;
    self.isRegistLianMai = NO;

    self.giftViewShow = NO;
    self.isSuperAdmin = NO;

    self.listArray = [NSMutableArray array];

    //    //计时扣费
    if ([self.kkLivetype isEqual:@"3"]) {
        [self GCDTimer];
    }
    
    self.coasttime = 60;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];

    self.haslianmai = NO;//本人是否连麦
    self.canScrollToBottom  = YES;

    self.haohualiwuV.expensiveGiftCount = [NSMutableArray array];//
    self.msgList = [[NSMutableArray alloc] init];
    self.level = (NSString *)[Config getLevel];

    self.chatModels = [NSMutableArray array];
    self.userCount = 0;

    self.titleColor = @"0";
    self.isRotationGame = NO;
    //设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    
}


#pragma mark ===== 子视图代理事件

- (void)kkShowCommendatoryLiveBtnClick
{
    KKCommendatoryLiveRoomView *kkview = [[KKCommendatoryLiveRoomView alloc]init];
    [kkview kkShow];
    WeakSelf;
    kkview.kkDidSelectItemBlock = ^(NSDictionary * _Nonnull liveDic) {
        weakSelf.kkLiveInfo = liveDic;
        weakSelf.kkIsCanPlay = YES;
    };
}

- (void)kkGiftBtnClick
{
    [self changeGiftViewFrameY:_window_height *3];

    KKLiveGiftView *kkview = [[KKLiveGiftView alloc]init];
    self.giftview = kkview;
    kkview.kkGiftDelegate = self;
    kkview.kkLiveInfoDic = self.kkLiveInfo;

    if (self.kkIsShowHorizontalView) {
        [self.kkHorizontalView addSubview:kkview];
        [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self.kkHorizontalView);
            make.width.height.mas_equalTo(KKScreenHeight);
        }];
        kkview.kkIsShowHorizontalView = YES;
    }else{
        [self.kkContentView addSubview:kkview];
        [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.kkContentView);
        }];
    }
    
}
-(void)changeGiftViewFrameY:(CGFloat)Y{
    
//    self.giftview.frame = CGRectMake(0,Y, _window_width, 300+ShowDiff);
    if (Y >= _window_height) {
        self.kkContinuousView.frame = CGRectMake(0, self.kkChatView.top-150,300,140);
    }
}
//改变连送礼物的frame
-(void)changecontinuegiftframeIndoliwu{
    
    self.kkContinuousView.frame = CGRectMake(0, _window_height - (_window_width/2+100+ShowDiff)-140,_window_width/2,140);
    int kktype = [[KKUserDefaults valueForKey:kkGiftDynamic] intValue];
    if (kktype) {
        self.kkContinuousView.hidden = NO;
    }else{
        self.kkContinuousView.hidden = YES;
    }
}

#pragma mark =====  //礼物视图代理
//-(void)sendGift:(NSMutableArray *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa
-(void)kkSendGiftInfo:(NSDictionary *)giftDic andPersistentType:(NSString *)sendType
{
    self.haohualiwu = sendType;
    NSString *info = [giftDic valueForKey:@"gifttoken"];
    self.level = [giftDic valueForKey:@"level"];
    LiveUser *users = [Config myProfile];
    users.level = self.level;
    [Config updateProfile:users];
    [self.kkLiveInfoModel.socketDelegate sendGift:self.level andINfo:info andlianfa:sendType];

}
//充值弹窗
- (void)kkShowAlertMoney:(UIAlertController *)alert
{
    if ([self.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
        [self.kkViewerViewDelegate kkShowAlertMicrophone:alert];
    }
}

-(void)pushCoinV
{
    KKMyPayMoneyViewController *VC = [[KKMyPayMoneyViewController alloc]init];
      [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
-(void)zhezhaoBTNdelegate
{
    [self kkCoverClick];//kk六道添加
}
#pragma mark ==== 以上是礼物相关


#pragma mark =====================底部功能事件

- (void)kkMoreBtnClick
{
    KKViewerAnchorMoreFunctionView *kkview = [[KKViewerAnchorMoreFunctionView alloc]init];
    self.kkMoreFunctionView = kkview;
    self.kkMoreFunctionView.hidden = NO;
    kkview.kkRoomType = 3;
    [self addSubview:kkview];
    [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

}
- (void)kkChatBtnClick
{
    [self.kktextToolBar.kkTextField becomeFirstResponder];
}

//TRTC设置
- (void)kkTRTCAudioEffectSettingClick
{
    AudioEffectSettingView * kkAudioEffectSettingView = [[AudioEffectSettingView alloc] initWithType:AudioEffectSettingViewDefault];
    [kkAudioEffectSettingView setAudioEffectManager: [[TRTCCloud sharedInstance] getAudioEffectManager] ];
    [self addSubview:kkAudioEffectSettingView];
    [kkAudioEffectSettingView show];

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
        NSDictionary *guardInfo = [self.kkLiveAllInfoDic valueForKey:@"guard"];
        NSString *content = self.kktextToolBar.kkTextField.text;
        NSString *usertype = minstr([self.kkLiveAllInfoDic valueForKey:@"usertype"]);

        [self.kkLiveInfoModel.socketDelegate sendmessage:content andLevel:self.level andUsertype:usertype andGuardType:minstr([guardInfo valueForKey:@"type"])];
        self.kktextToolBar.kkTextField.text =nil;
        self.kktextToolBar.kkMessagePushBTN.selected = NO;
    }
}


//发送消息
-(void)sendBarrage
{
    WeakSelf;
    [self.kkLiveInfoModel.socketDelegate sendBarrageID:[self.kkLiveInfo valueForKey:@"uid"] andTEst:self.kktextToolBar.kkTextField.text andDic:self.kkLiveInfo and:^(id arrays) {
        NSArray *data = [arrays valueForKey:@"data"];
        NSNumber *code = [data valueForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]])
        {
           weakSelf.level = [[[data valueForKey:@"info"] firstObject] valueForKey:@"level"];
            [weakSelf.kkLiveInfoModel.socketDelegate sendBarrage:weakSelf.level andmessage:[[[data valueForKey:@"info"] firstObject] valueForKey:@"barragetoken"]];
            //刷新本地魅力值
            LiveUser *liveUser = [Config myProfile];
            weakSelf.kktextToolBar.kkTextField.text = @"";
            liveUser.coin = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"]];
            liveUser.level = weakSelf.level;
            [Config updateProfile:liveUser];
            
            if (weakSelf.giftview) {
                [weakSelf.giftview chongzhiV:[NSString stringWithFormat:@"%@",liveUser.coin]];
            }
        }
        else
        {
            [MBProgressHUD showError:[data valueForKey:@"msg"]];

        }
    }];
}

#pragma mark -- 获取键盘高度  键盘的显示与隐藏
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self doCancle];
    self.kkUserInfoV.hidden = YES;
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat heightw = keyboardRect.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        [self tableviewheight:heightw];
        //
        if (self.kkIsShowHorizontalView) {
            [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.width.mas_equalTo(self.kkHorizontalView);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(self.kkHorizontalView.mas_bottom).mas_offset(-(heightw+44));
            }];

        }else{
            [self.kktextToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.width.mas_equalTo(self.kkContentView);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(-(heightw+44));
            }];
        }
        [self changeGiftViewFrameY:_window_height*10];
        //wangminxinliwu
        [self changecontinuegiftframe];

    }];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        self.kkUserInfoV.hidden = NO;
        //wangminxinliwu
            [self changecontinuegiftframe];
        [self changeGiftViewFrameY:_window_height*3];
        [self kkLayoutFrame];
    }];
    
}
//遮罩事件
- (void)kkChatCoverClick
{
    [self kkCoverClick];//
}
//聊天消息事件
- (void)kkChatMessageClick:(NSDictionary *)dic
{
    [self GetInformessage:dic];
}

#pragma mark ==== 以上是socket 聊天相关


-(void)tableviewheight:(CGFloat)h
{
    [self.kkChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkBottomMenuView.mas_top).mas_offset(-h);
        make.top.mas_equalTo(self.kkTRTCVoiceV.mas_bottom).mas_offset(-300);
        make.left.right.mas_equalTo(self.kkContentView);
//        make.height.mas_equalTo(200);
    }];
}

#pragma mark 以下是 KKLiveViewerSocketDelegate  聊天相关

//socket消息
- (void)kkSocketMessageSuccess:(NSDictionary *)dic
{
    [self.kkChatView kkAddSocketMessage:dic];
}

//零碎功能数据回调
- (void)kkLoadRoomFunctionDataSuccess:(NSDictionary *)dic
{
    KKLiveRoomBottomFunctionModel *kkModel = [KKLiveRoomBottomFunctionModel baseModelWithDic:dic];
//    self.kkUserInfoV.bannerArray = kkModel.kkAdvertArr.mutableCopy;

   NSString *kkIsAttention = dic[@"shifougz"];
    [self.kkLiveInfo setValue:kkIsAttention forKey:@"kkIsAttention"];
    [self.kkUserInfoV kkIsAttention:kkIsAttention];
    self.kkBottomModel = kkModel;
}
- (void)kkSocketSuccess:(NSDictionary *)dic
{
//进入房间接口回调
//    [7]    (null)    @"shishivideoid" : @"1400492109"

    self.kkUserInfoV.kkLiveDic = dic;
    self.kkLiveAllInfoDic = dic;
    if ([self.kkLiveInfo[@"livetypee"] intValue] == 2){
        //trtc语音聊天室
        self.kkTRTCVoiceV.kkRoomSDKDic = dic;
        self.kkTRTCVoiceV.kkIsLive  = NO;
    }
    
    [self.kkUserInfoV kkIsAttention:dic[@"isattention"]];
    //        self.kktextToolBar.kkBarrageMoney = self.danmuprice;//六道2.1
    //顶部用户信息变更

    if ([self.kkLivetype isEqual:@"3"] || [self.kkLivetype isEqual:@"2"]) {
        //此处用于计时收费
        //刷新所有人的影票
        [self addCoin:self.kkType_val];
        [self.kkLiveInfoModel.socketDelegate addvotesenterroom:minstr(self.kkType_val)];
    }

    [self changecontinuegiftframe];
    [self kkAnchor_PK:dic];
}

/*
 *添加魅力值数
 */
-(void)addCoin:(NSString *)coin
{
    long long ordDate = [self.votesTatal longLongValue];
    self.votesTatal = [NSString stringWithFormat:@"%lld",ordDate + [coin intValue]];
    [self.kkUserInfoV changeState: self.votesTatal];
}
//改变连送礼物的frame
-(void)changecontinuegiftframe{

}
//顶部观众信息 和直播间人数
- (void)kkChangeLookLivePersion:(NSDictionary *)dic andPersionCount:(long long)count
{
    if (dic) {
        [self.kkUserInfoV kkUserLeave:dic];
    }
    //kk六道更新直播间人数
    [self.kkUserInfoV kkChangeLookVideoPersionNum:count];
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

}

//房间被管理员关闭
- (void)kkRoomCloseByAdmin
{
    [self kklastView];
}

//僵尸粉
- (void)kkAddZombieByArray:(NSArray *)array
{
    self.kkUserInfoV.kkRoomPersonArr = array.mutableCopy;
    self.kkUserInfoV.kkIsRefreshUserList = YES;
}
//用户离开
- (void)kkUserDisconnect:(NSDictionary *)dic
{
    //连麦小窗口
    if (self.playrtmp) {
        if ([[dic valueForKey:@"uid"] integerValue] == self.playrtmp.tag-1500) {
            [self releasePlayLinkView];
        }
    }
}

//魅力值更新
- (void)kkVotesTatal:(NSString *)votes
{
    self.votesTatal = votes;
    [self.kkUserInfoV changeState: votes];
}

//送礼物 1是豪华，其他是连送
- (void)kkSendGift:(NSDictionary *)giftInfo andGiftType:(int )type
{

//    self.kkContinuousView.hidden = NO;
    if (type == 1) {
        [self expensiveGift:giftInfo];
    }
    else{
        if (!self.continueGifts) {
            self.continueGifts = [[continueGift alloc]init];
            [self.kkContentView addSubview:self.continueGifts];

            //初始化礼物空位
            [self.continueGifts initGift];
        }
        [self.continueGifts GiftPopView:giftInfo andLianSong:self.haohualiwu];
    }

    int kktype = [[KKUserDefaults valueForKey:kkGiftDynamic] intValue];
    if (kktype) {
        self.continueGifts.hidden = NO;
    }else{
        self.continueGifts.hidden = YES;
    }

}

-(void)expensiveGift:(NSDictionary *)giftData{
    if (!self.haohualiwuV) {
        expensiveGiftV * haohualiwuV = [[expensiveGiftV alloc]init];
        self.haohualiwuV = haohualiwuV;
        [self.kkContentView addSubview:haohualiwuV];
        haohualiwuV.delegate = self;
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
    int kktype = [[KKUserDefaults valueForKey:kkGiftDynamic] intValue];
    if (kktype) {
        self.haohualiwuV.hidden = NO;
    }else{
        self.haohualiwuV.hidden = YES;
    }
}

#pragma mark  以下是连麦相关

- (void)kkUserConnectLive
{//用户发起连麦

    if (self.haslianmai == NO) {
        self.haslianmai = YES;
        //发送连麦socket
        [MBProgressHUD showError:YZMsg(@"连麦请求已发送")];
        //申请上麦
        [self.kkLiveInfoModel.socketDelegate connectvideoToHost];
        TRTCCloud *kkTRTCCloud = [TRTCCloud sharedInstance];
        TRTCParams *kkTRTCParams = [[TRTCParams alloc]init];

        kkTRTCParams.userSig = self.kkLiveAllInfoDic[@"spkeysing"];
        kkTRTCParams.sdkAppId = [self.kkLiveAllInfoDic[@"shishivideoid"] intValue];
        kkTRTCParams.roomId = [self.kkLiveInfo[@"uid"] intValue];
        kkTRTCParams.userId = [KKChatConfig getOwnID];
        kkTRTCParams.role = TRTCRoleAudience;

        [kkTRTCCloud enterRoom:kkTRTCParams appScene:TRTCAppSceneLIVE];
        kkTRTCCloud.delegate = self;//TRTCCloudDelegate

        
            self.startLinkTime = 11;
            [self startLinkGCDTimer];
        
    }else{
        [self kkConnectOvertime];
    }

}


- (void)startLinkGCDTimer {
    int timeInterval = 1.0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"startLinkTimeDaoJiShi"
                                                           timeInterval:timeInterval
                                                                  queue:dispatch_get_main_queue()
                                                                repeats:YES
                                                          fireInstantly:NO
                                                                 action:^{
                                                                     [weakSelf GCDTimerChange];
                                                                 }];
}

- (void)GCDTimerChange
{
    [self startLinkTimeDaoJiShi];
}
- (void)startLinkTimeDaoJiShi{
    self.startLinkTime -- ;
    if (self.startLinkTime <= 0) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];
        [self kkConnectOvertime];
    }
}
- (void)kkConnectOvertime
{
    if (self.startLinkTime>0) {
        [MBProgressHUD kkshowMessage:YZMsg(@"您已申请，请稍等")];
        return;
    }
    UIAlertController  *alertlianmaiVC = [UIAlertController alertControllerWithTitle:@"连接超时" message:YZMsg(@"是否断开连麦") preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //关闭连麦
        self.haslianmai = NO;
        NSLog(@"关闭连麦");
        [self kkUserAndAnchorCloseconnect];
        [self.kkLiveInfoModel.socketDelegate closeConnect];
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
    [alertlianmaiVC addAction:defaultActionss];
    [alertlianmaiVC addAction:cancelActionss];
//        [self presentViewController:alertlianmaiVC animated:YES completion:nil];
    if ([self.kkViewerViewDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
        [self.kkViewerViewDelegate kkShowAlertMicrophone:alertlianmaiVC];
    }

    
}

-(void)kkUserAndAnchorCloseconnect{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf releasePlayLinkView];
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];

        weakSelf.haslianmai = NO;
        weakSelf.kkConnectMicrophoneV.kkConnectionView.hidden = YES;
        weakSelf.kkConnectMicrophoneV.KKConnectBtn.hidden = NO;
        [[TRTCCloud sharedInstance] exitRoom];
    });
}

//用户发起的连麦，得到主播同意开始连麦
- (void)kkStartConnectvideo
{
    
    WeakSelf;
    [YBToolClass postNetworkWithUrl:@"" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *infoDic = [info firstObject];
          weakSelf.myplayurl = [infoDic valueForKey:@"playurl"];
            weakSelf.kkmyPushurl = [infoDic valueForKey:@"pushurl"];

            
            [weakSelf kkAnchorAgree];
        }
        else{
            [MBProgressHUD kkshowMessage:msg];
            [weakSelf kkUserAndAnchorCloseconnect];
        }

    } fail:^{
        [weakSelf kkUserAndAnchorCloseconnect];
    }];

}


- (void)kkAnchorAgree
{
    [self kkTRTCPreviewLiveInit];
    WeakSelf;
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];

    weakSelf.haslianmai = YES;
    weakSelf.kkConnectMicrophoneV.kkConnectionView.hidden = NO;
    weakSelf.kkConnectMicrophoneV.KKConnectBtn.hidden = YES;

}

- (void)kkTRTCPreviewLiveInit
{
    TRTCCloud *kkTRTCCloud = [TRTCCloud sharedInstance];
    [kkTRTCCloud switchRole:TRTCRoleAnchor];
    //开启本地画面预览，自己画面
    [kkTRTCCloud startLocalPreview:YES view:[UIView new]];
    [kkTRTCCloud startLocalAudio:TRTCAudioQualityDefault];//
    NSString *kkuid = [NSString stringWithFormat:@"%@%@",[KKChatConfig getOwnID],@"_stream"];

    [[TRTCCloud sharedInstance]  startPublishing:kkuid type:TRTCVideoStreamTypeSmall];
    [self.kkLiveInfoModel.socketDelegate sendSmallURL:self.myplayurl andID:[Config getOwnID]];

//    [[TRTCLiveRoom shareInstance]  startPublishWithStreamID:kkuid callback:^(int code, NSString * _Nullable message) {
//    }];

    
}
//主播拒绝连麦
- (void)kkEnabledlianmaibtn
{
    [self kkUserAndAnchorCloseconnect];
}

//对方 主播或者用户断开连麦
- (void)kkNanchorHostout
{

    ////    _connectVideo.userInteractionEnabled = YES;
//    [self releasePlayLinkView];
//    [self kkEnabledlianmaibtn];
    
    [self kkUserAndAnchorCloseconnect];
    
}
- (void)onError:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg extInfo:(nullable NSDictionary*)extInfo
{
    KKLog(@"报错%@",errMsg);
}
- (void)onEnterRoom:(NSInteger)result
{
    if (result>0) {
        NSLog(@"自己进房成功");
    }
}
#pragma mark ==== 以上是用户和主播连麦


//主播连麦
- (void)kkAnchor_stopLink:(NSDictionary *)dic
{
//    if (pkView) {
//        [pkView removeFromSuperview];
//        pkView = nil;
//    }
    if (self.playrtmp) {
        [self.playrtmp stopConnect];
        [self.playrtmp removeFromSuperview];
        self.playrtmp = nil;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.kkVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
            if ([(NSString *)[self.kkLiveInfo valueForKey:@"anyway"] isEqualToString:@"0"]) {
                make.edges.mas_equalTo(self);
            }else{
                make.top.mas_equalTo(215);
                make.left.right.mas_equalTo(self);
                make.height.mas_equalTo(200);
            }
        }];

    }];
}

//主播同意连麦
- (void)kkAnchor_agreeLink:(NSDictionary *)dic{
    [UIView animateWithDuration:0.3 animations:^{
//        _player.view.frame = CGRectMake(0, 130+statusbarHeight, _window_width/2, _window_width*2/3);

        [self.kkVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
            if ([(NSString *)[self.kkLiveInfo valueForKey:@"anyway"] isEqualToString:@"0"]) {
                make.top.mas_equalTo(215);
                make.left.mas_equalTo(self);
                make.width.mas_equalTo(_window_width/2);
                make.height.mas_equalTo(_window_width*2/3);

            }else{
                make.top.mas_equalTo(130+statusbarHeight);
                make.left.right.mas_equalTo(self);
                make.height.mas_equalTo(200);
            }
        }];

    }];
    if (self.playrtmp) {
        [self.playrtmp stopConnect];
        [self.playrtmp removeFromSuperview];
        self.playrtmp = nil;
    }
    play_linkMic * playrtmp = [[play_linkMic alloc]initWithRTMPURL:@{@"playurl":minstr([dic valueForKey:@"pkpull"]),@"pushurl":@"0",@"userid":minstr([dic valueForKey:@"pkuid"])} andFrame:CGRectMake(_window_width/2, 130+statusbarHeight , _window_width/2, _window_width*2/3) andisHOST:NO];
    self.playrtmp =playrtmp;
    
    playrtmp.delegate = self;
    playrtmp.tag = 1500 + [minstr([dic valueForKey:@"pkuid"]) intValue];
//    [videoView addSubview:playrtmp];
    [self.kkVideoView addSubview:playrtmp];

}
//连麦
- (void)kkplayLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid
{
    [self releasePlayLinkView];
    play_linkMic * playrtmp = [[play_linkMic alloc]initWithRTMPURL:@{@"playurl":playurl,@"pushurl":@"0"} andFrame:CGRectMake(_window_width - 100, _window_height - 100 -statusbarHeight - 150 -ShowDiff, 100, 150) andisHOST:NO];
    self.playrtmp = playrtmp;
    [self.kkContentView addSubview:playrtmp];

    playrtmp.delegate = self;
    playrtmp.tag = 1500 + [userid intValue];
//    [self.view insertSubview:playrtmp aboveSubview:self.tableView];
    
}

- (void)releasePlayLinkView{
    if (self.playrtmp) {
        [self.playrtmp stopConnect];
        [self.playrtmp removeFromSuperview];
        self.playrtmp = nil;
    }
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];

}

//连麦代理方法
//开始连麦推流
-(void)startConnectRtmpForLink_mic
{
    [self.kkLiveInfoModel.socketDelegate sendSmallURL:self.myplayurl andID:[Config getOwnID]];
    //连麦按钮 暂定
//    [_connectVideo setImage:[UIImage imageNamed:@"live_断"] forState:0];
//    _connectVideo.userInteractionEnabled = YES;

}
//停止推流
-(void)stoppushlink
{
    [MBProgressHUD showError:YZMsg(@"推流失败")];
    [self.kkLiveInfoModel.socketDelegate closeConnect];
//    _connectVideo.userInteractionEnabled = YES;

}


//增加影票
- (void)kkAddVotesTatal:(NSString *)votes
{
    [self addCoin:votes];
}

#pragma mark  以上是连麦相关

//pk相关
- (void)kkShowPKView:(NSDictionary *)dic
{
    if (self.pkView) {
        [self.pkView removeFromSuperview];
        self.pkView = nil;
    }
    NSString *time;
    if (dic) {
        time = minstr([dic valueForKey:@"pk_time"]);
    }else{
        time = @"300";
    }
    anchorPKView  * pkView = [[anchorPKView alloc]initWithFrame:CGRectMake(0, 130+statusbarHeight, _window_width, _window_width*2/3+20) andTime:time];
    pkView.delegate = self;
    self.pkView = pkView;
    [self.kkContentView addSubview:pkView];

}

- (void)kkShowPKResult:(NSDictionary *)dic
{
    int win;
    if ([minstr([dic valueForKey:@"win_uid"]) isEqual:@"0"]) {
        win = 0;
    }else if ([minstr([dic valueForKey:@"win_uid"]) isEqual:minstr([self.kkLiveInfo valueForKey:@"uid"])]) {
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
    if ([minstr([dic valueForKey:@"pkuid1"]) isEqual:minstr([self.kkLiveInfo valueForKey:@"uid"])]) {
        blueNum = minstr([dic valueForKey:@"pktotal1"]);
        redNum = minstr([dic valueForKey:@"pktotal2"]);
    }else{
        redNum = minstr([dic valueForKey:@"pktotal1"]);
        blueNum = minstr([dic valueForKey:@"pktotal2"]);
    }
    if ([blueNum isEqual:@"0"] && [redNum isEqual:@"0"]) {
        progress = 0.5;
    }else{
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
    }
    
    [self.pkView updateProgress:progress withBlueNum:blueNum withRedNum:redNum];
}
-(void)removePKView{
    if (self.pkView) {
        [self.pkView removeFromSuperview];
        self.pkView = nil;
    }
}

#pragma mark == 礼物弹出及队列显示开始 礼物效果  以上是socket
-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!self.haohualiwuV) {
        expensiveGiftV * haohualiwuV = [[expensiveGiftV alloc]init];
        self.haohualiwuV = haohualiwuV;
        [self.kkContentView addSubview:haohualiwuV];
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
    int kktype = [[KKUserDefaults valueForKey:kkGiftDynamic] intValue];
    if (kktype) {
        self.haohualiwuV.hidden = NO;
    }else{
        self.haohualiwuV.hidden = YES;
    }

}

//被踢出房间
- (void)kkKickOutRoomClose
{
 
    
}

//刷新钻石数量
- (void)kkReloadChongzhi:(NSString *)coin
{
        if (self.giftview) {
            [self.giftview chongzhiV:coin];
        }
        

}
// 以上是 KKLiveViewerSocketDelegate  聊天相关


#pragma mark ================   主播连麦 PK ===============
- (void)kkAnchor_PK:(NSDictionary *)dic
{
    if ([minstr([dic valueForKey:@"isred"]) isEqual:@"1"]) {
        //2.1kk六道修改
        [self kkShowRedBagBtn];
    }
    NSDictionary *pkinfo = [dic valueForKey:@"pkinfo"];
    if (![minstr([pkinfo valueForKey:@"pkuid"]) isEqual:@"0"]) {
        [self kkAnchor_agreeLink:pkinfo];
        if ([minstr([pkinfo valueForKey:@"ifpk"]) isEqual:@"1"]) {
            [self kkShowPKView:pkinfo];
            NSMutableDictionary *pkDic = [NSMutableDictionary dictionary];
            [pkDic setObject:minstr([self.kkLiveInfo valueForKey:@"uid"]) forKey:@"pkuid1"];
            [pkDic setObject:minstr([pkinfo valueForKey:@"pk_gift_liveuid"]) forKey:@"pktotal1"];
            [pkDic setObject:minstr([pkinfo valueForKey:@"pk_gift_pkuid"]) forKey:@"pktotal2"];
            [self changePkProgressViewValue:pkDic];
        }
    }
    
    if (![minstr([dic valueForKey:@"linkmic_uid"]) isEqual:@"0"]) {
        [self kkplayLinkUserUrl:minstr([dic valueForKey:@"linkmic_pull"]) andUid:minstr([dic valueForKey:@"linkmic_uid"])];
    }

}

- (void)changePkProgressViewValue:(NSDictionary *)dic{
    
}


//显示连麦PK红包按钮

- (void)kkShowRedBagBtn
{
    
    if (self.redBagBtn) {
        [self.redBagBtn removeFromSuperview];
        self.redBagBtn = nil;
    }
    if (!self.redBagBtn) {
        //PK按钮
        UIButton *redBagBtn = [UIButton buttonWithType:0];
        self.redBagBtn = redBagBtn;
        [self.kkContentView addSubview:self.redBagBtn];

        [self.redBagBtn setBackgroundImage:[UIImage imageNamed:@"红包-右上角"] forState:UIControlStateNormal];
        [self.redBagBtn addTarget:self action:@selector(redBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.redBagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50);
            make.top.mas_equalTo(130+statusbarHeight);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(50);
        }];
    }
    

}
//PK功能
-(void)redBagBtnClick
{
    
    
}

- (void)GCDTimer {
    int timeInterval = 1.0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"kktimecoastmoney"
                                                           timeInterval:timeInterval
                                                                  queue:dispatch_get_main_queue()
                                                                repeats:YES
                                                          fireInstantly:NO
                                                                 action:^{
                                                                     [weakSelf GCDTimerChange];
                                                                 }];
}

- (void)GCDTimerChange
{
    [self timecoastmoney];
}

//执行扣费
-(void)timecoastmoney{
    self.coasttime -= 1;
    if (self.coasttime == 0) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"kktimecoastmoney"];
        self.coasttime = 60;
        [self doCoast];
    }
}

//执行扣费
-(void)doCoast
{
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"":[self.kkLiveInfo valueForKey:@"uid"],
                             @"":[self.kkLiveInfo valueForKey:@""]
                             };
    WeakSelf;
    [YBToolClass postNetworkWithUrl:@"" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
//            返回了个字典，只有一个字段 用户余额值为0
            [weakSelf.kkVideoView kkPlay];
            //计时扣费
           weakSelf.coasttime = 60;

            [self GCDTimer];
            [weakSelf.kkLiveInfoModel.socketDelegate addvotes:weakSelf.kkType_val isfirst:@"0"];
            [weakSelf addCoin:weakSelf.kkType_val];
            
            LiveUser *user = [Config myProfile];
            user.coin = minstr([info valueForKey:@"coin"]);
            [Config updateProfile:user];
            
        }else{
            //code 1008 余额不足
            [MBProgressHUD kkshowMessage:info[@"msg"]];
            [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"kktimecoastmoney"];

            [weakSelf.kkVideoView kkPause];
        }
        
    } fail:^{
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"kktimecoastmoney"];

    }];
}


#pragma mark ==== 以下是房间结束相关

- (void)kkstopPreviousInfo
{
    if (self.kkIsTRTC) {
        [self.kkTRTCVoiceV kkExitRoom];
        [self.kkTRTCVideoView kkPause];
    }else{
        self.kkVideoView.kkIsCanPlay = NO;
    }
    self.kkLiveEndV.hidden = YES;
    self.kkMoreFunctionView.hidden = YES;
    //移除房间标题
//    [self.kkShowRoomTitleView removeFromSuperview];
//    [self.kkBottomRightView removeAllSubViews];
//    [self.kkBottomView removeAllSubViews];

//    [userView removeFromSuperview];
//    userView = nil;
//    self.tableView.hidden = YES;
    [self releaseall];

    
}

-(void)releaseall{
//    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    [self removetimer];
    if (self.haslianmai == YES) {
        [self.kkLiveInfoModel.socketDelegate closeConnect];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.haohualiwuV.expensiveGiftCount = nil;
    if (self.continueGifts) {
        [self.continueGifts stopTimerAndArray];
        self.continueGifts = nil;
    }
    self.kkVideoView.kkIsCanPlay = NO;
//    [self releaseObservers];

    [self.kkLiveInfoModel.socketDelegate socketStop];
}
//注销计时器
-(void)removetimer{

    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"startLinkTimeDaoJiShi"];
}

static void extracted(KKLiveViewerView *object) {
    [object requestLiveAllTimeandVotes];
}

//直播结束跳到此页面
-(void)kklastView{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPlaying"];


    //    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    
//    [userView removeFromSuperview];
//    self.userView = nil;
    [self releaseall];

    self.kkVideoView.kkIsCanPlay = NO;

    [self.haohualiwuV stopHaoHUaLiwu];
    [self.haohualiwuV removeFromSuperview];
    self.haohualiwuV.expensiveGiftCount = nil;
    [self.continueGifts stopTimerAndArray];
    self.continueGifts = nil;
    //关闭连麦
    [self kkUserAndAnchorCloseconnect];

    extracted(self);

}

- (void)requestLiveAllTimeandVotes{
    NSString *url = [NSString stringWithFormat:@"=%@",minstr([self.kkLiveInfo valueForKey:@""])];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [self lastview:subdic];
        }else{
            [self lastview:nil];
        }
    } fail:^{
        [self lastview:nil];
    }];
    
}

-(void)lastview:(NSDictionary *)dic
{
    if (self.kkLiveEndV) {
        [self.kkLiveEndV removeFromSuperview];
    }
    [self.kkContentView addSubview:self.kkLiveEndV];
    self.kkLiveEndV.hidden = NO;
    NSMutableDictionary *kkdic = [NSMutableDictionary dictionaryWithDictionary:self.kkLiveInfo];
    kkdic[@"length"] = dic[@"length"];
    kkdic[@"votes"] = dic[@"votes"];
    kkdic[@"nums"] = dic[@"nums"];

    self.kkLiveEndV.kkUserInfoDic = kkdic;
    [self.kkLiveEndV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
    }];

}
//直播结束时退出房间
-(void)dissmissVC{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPlaying"];

//    [userView removeFromSuperview];
//    userView = nil;
//    self.tableView.hidden = YES;
    [self releaseall];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    [[MXBADelegate sharedAppDelegate] popViewController:YES];

}

#pragma mark ==== 以上 是房间结束相关


#pragma mark ===== 以下是主播端相关
//暂定，有可能需要做两套UI，
//主播关闭某人的连麦
-(void)closeuserconnect:(NSString *)uid{
//    if (isAnchorLink) {
//        [socketL anchor_DuankaiLink];
//    }else{
//        [socketL closeconnectuser:uid];
//    }
//    [self changeLivebroadcastLinkState:NO];
}
#pragma mark ===== 以上是主播端相关


#pragma mark ====懒加载

- (KKLiveViewerInfoModel *)kkLiveInfoModel
{
    if (!_kkLiveInfoModel) {
        _kkLiveInfoModel = [[KKLiveViewerInfoModel alloc] init];
        _kkLiveInfoModel.kkSocketDelegate = self;
    }
    return _kkLiveInfoModel;
}



- (NSDictionary *)kkLiveAllInfoDic
{
    if (!_kkLiveAllInfoDic) {
        _kkLiveAllInfoDic = [NSDictionary dictionary];
    }
    return _kkLiveAllInfoDic;
}

- (KKLiveEndView *)kkLiveEndV
{
    if (!_kkLiveEndV) {
        _kkLiveEndV = [[KKLiveEndView alloc]init];
        WeakSelf;
        _kkLiveEndV.kkGoBackBlock = ^(NSString * _Nonnull string) {
            [[MXBADelegate sharedAppDelegate] popViewController:weakSelf];
        };

    }
    return _kkLiveEndV;
}

@end


