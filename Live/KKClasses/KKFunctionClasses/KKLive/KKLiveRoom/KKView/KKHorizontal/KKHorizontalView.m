//
//  KKHorizontalView.m
//  yunbaolive
//
//  Created by Peter on 2020/9/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKHorizontalView.h"

#import "KKLiveRoomBottomFunctionModel.h"

#import "KKBarrageWebView.h"
#import "KKBottomRightView.h"
#import "KKHorizontalUserInfoView.h"
#import "KKLiveRoomRankAlertView.h"
#import "KKBottomH5View.h"

#import "SDCycleScrollView.h"

#import "KKWebH5ViewController.h"

@interface KKHorizontalView ()<UITextFieldDelegate,KKUserInfoDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,assign) BOOL kkIsShowTool;

@property(weak,nonatomic)UIView *kkContentView;
@property(weak,nonatomic) KKBarrageWebView *kkBarrageWebView;

@property(weak,nonatomic)UIView *kkTopToolV;
@property(weak,nonatomic)UIView *kkBottomToolV;

@property(weak,nonatomic)UIButton *kkPortraitBtn;//竖屏切换
@property(weak,nonatomic)UIButton *kkBarrageBtn;//弹幕
@property(weak,nonatomic)UIButton *kkDefinitionBtn;//清晰度
@property(weak,nonatomic)KKHorizontalUserInfoView *kkUserInfoV;

//轮播图
@property(strong,nonatomic)SDCycleScrollView *kkcycleScrollView;


@property(weak,nonatomic)UIButton *kkGiftBtn;//
@property(weak,nonatomic)KKBottomRightView *kkToolView;
@property(weak,nonatomic)UIButton *kkTextBtn;


@end

@implementation KKHorizontalView
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.kkIsShowTool = YES;
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
    //kk六道弹幕,
    KKBarrageWebView *kkBarrageWebView = [[KKBarrageWebView alloc]init];
    [self addSubview:kkBarrageWebView];
    self.kkBarrageWebView = kkBarrageWebView;

    UIView *kkContentView = [[UIView alloc]init];
    [self addSubview:kkContentView];
    self.kkContentView = kkContentView;
    kkContentView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkContentViewClick)];
    [kkContentView addGestureRecognizer:tapges];

    [self kkInitTopView];
    
    [self kkInitBottomView];
    
}
- (void)kkInitBottomView
{
        UIView *kkBottomToolV = [[UIView alloc]init];
        [self.kkContentView addSubview:kkBottomToolV];
        self.kkBottomToolV = kkBottomToolV;
        
        UIButton *kkTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.kkBottomToolV addSubview:kkTextBtn];
        self.kkTextBtn = kkTextBtn;
        [kkTextBtn setTitleColor:[UIColor colorWithHexString:@"#9A9A9A"] forState:UIControlStateNormal];
        [kkTextBtn setTitle:@"说点什么..." forState:UIControlStateNormal];

        kkTextBtn.titleLabel.font = KKPhoenFont13;
        kkTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);//6 35
        [kkTextBtn addTarget:self action:@selector(kkTextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [kkTextBtn setBackgroundImage:[UIImage imageNamed:@"KKHorizontalView_kkTextBtn_icon"] forState:UIControlStateNormal];
        
        UIButton *kkGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.kkContentView addSubview:kkGiftBtn];
        self.kkGiftBtn = kkGiftBtn;
//        [kkGiftBtn setImage:[UIImage imageNamed:@"KKLive_SecondPage_gift_icon"] forState:UIControlStateNormal];
    [kkGiftBtn setBackgroundImage:[UIImage imageNamed:@"KKLive_SecondPage_gift_icon"] forState:UIControlStateNormal];
        [kkGiftBtn addTarget:self action:@selector(kkGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    kkGiftBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);

        KKBottomRightView *kkToolView =  [[KKBottomRightView alloc]init];
        self.kkToolView = kkToolView;
        [self.kkContentView addSubview:kkToolView];
        kkToolView.backgroundColor = [UIColor clearColor];
    WeakSelf;
    kkToolView.kkBottomFunctionClickBlock = ^(KKLiveRoomBottomFunctionModel * _Nonnull kkModel) {
//        if ([weakSelf.kkHorizontalViewDelegate respondsToSelector:@selector(kkBottomBtnClick:)]) {
//            [weakSelf.kkHorizontalViewDelegate kkBottomBtnClick:kkModel];
//        }
        [weakSelf kkBottomBtnClick:kkModel];
    };
}

- (void)kkInitTopView
{
    UIView *kkTopToolV = [[UIView alloc]init];
    [self.kkContentView addSubview:kkTopToolV];
    self.kkTopToolV = kkTopToolV;

    UIButton *kkPortraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkTopToolV addSubview:kkPortraitBtn];
    self.kkPortraitBtn = kkPortraitBtn;
    [kkPortraitBtn setImage:[UIImage imageNamed:@"KKHorizontalView_icon"] forState:UIControlStateNormal];
    [kkPortraitBtn addTarget:self action:@selector(kkPortraitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    kkPortraitBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIButton *kkBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkTopToolV addSubview:kkBarrageBtn];
    self.kkBarrageBtn = kkBarrageBtn;
    [kkBarrageBtn setImage:[UIImage imageNamed:@"KKHorizontal_barrage_Normal"] forState:UIControlStateNormal];
    [kkBarrageBtn addTarget:self action:@selector(kkBarrageBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkDefinitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkTopToolV addSubview:kkDefinitionBtn];
    self.kkDefinitionBtn = kkDefinitionBtn;
    [kkDefinitionBtn addTarget:self action:@selector(kkDefinitionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkDefinitionBtn setTitle:@"高清" forState:UIControlStateNormal];
    [kkDefinitionBtn setTitleColor:KKWhiteColor forState:UIControlStateNormal];
    kkDefinitionBtn.titleLabel.font = KKPhoenFont13;
//    kkDefinitionBtn.backgroundColor = KKBlackTitleLabColor;
    kkDefinitionBtn.backgroundColor = [KKBlackTitleLabColor colorWithAlphaComponent:0.15];
//    kkDefinitionBtn.alpha = 0.15;

    
    KKHorizontalUserInfoView * kkUserInfoV = [[KKHorizontalUserInfoView alloc] init];
    [self.kkTopToolV addSubview:kkUserInfoV];
    self.kkUserInfoV = kkUserInfoV;
    kkUserInfoV.kkUserInfoDelegate = self;

    self.kkcycleScrollView.showPageControl = NO;
    self.kkcycleScrollView.delegate = self;
    [self.kkTopToolV addSubview:self.kkcycleScrollView];
    self.kkcycleScrollView.hidden = YES;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self kkSetupFrame];
}
- (void)kkSetupFrame
{
    WeakSelf;
    [self.kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self kkInitTopViewFrame];
    
    [self.kkBottomToolV mas_makeConstraints:^(MASConstraintMaker *make) {

        if (weakSelf.kkIsShowTool) {
            make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(-100);
        }else{
            make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(0);
        }
        make.left.mas_equalTo(kkStatusbarH);
        make.right.mas_equalTo(-ShowDiff);
        make.height.mas_equalTo(100);

    }];
    [self.kkGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-(11 + ShowDiff));
        make.bottom.mas_equalTo(-5);
        make.width.height.mas_equalTo(40);
    }];

//    [self.kkToolView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.kkGiftBtn.mas_left).mas_offset(-15);
//        make.centerY.mas_equalTo(self.kkGiftBtn);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(self.kkGiftBtn);
//    }];
    [self.kkTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(177);
        make.height.mas_equalTo(40);
    }];
}

- (void)kkInitTopViewFrame
{
    WeakSelf;
        [self.kkTopToolV mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.kkIsShowTool) {
                make.top.mas_equalTo(0);
            }else{
                make.top.mas_equalTo(-150);
            }
            make.left.mas_equalTo(kkStatusbarH);
            make.right.mas_equalTo(-ShowDiff);
            make.height.mas_equalTo(150);
        }];
        [self.kkPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-11);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.kkBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.kkPortraitBtn.mas_left).mas_offset(-20);
            make.centerY.mas_equalTo(self.kkPortraitBtn);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(37);
        }];
        [self.kkDefinitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.kkBarrageBtn.mas_left).mas_offset(-20);
            make.centerY.mas_equalTo(self.kkPortraitBtn);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(45);
        }];

    [self.kkUserInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(80);
    }];
    [self.kkcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkUserInfoV.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];

}
- (void)setKkLiveDic:(NSDictionary *)kkLiveDic
{
    _kkLiveDic = kkLiveDic;
    
    NSString * kkstr = [NSString stringWithFormat:@"%@%@&stream=%@&zuid=%@",h5url,@"/index.php?g=Appapi&m=wmai&a=barrager",[kkLiveDic valueForKey:@"stream"],[kkLiveDic valueForKey:@"uid"]];
    kkstr = [NSString kk_AppendH5URL:kkstr];
    self.kkBarrageWebView.kkUrls = kkstr;

    self.kkUserInfoV.zhuboDic = kkLiveDic;
}

- (void)setKkRowDataArr:(NSArray *)kkRowDataArr
{
    _kkRowDataArr = kkRowDataArr;
    self.kkToolView.kkRowDataArr = kkRowDataArr;
    [self.kkToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kkRowDataArr.count * 45));
        make.right.mas_equalTo(self.kkGiftBtn.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.kkGiftBtn);
        make.height.mas_equalTo(self.kkGiftBtn);
    }];

}

- (void)setBannerArray:(NSMutableArray *)bannerArray
{
    _bannerArray = bannerArray;
    NSMutableArray *muarray = [NSMutableArray array];
    for (KKLiveRoomBottomFunctionModel *model  in bannerArray) {
        [muarray addObject:[NSString stringWithFormat:@"%@",model.idurl]];
    }
    self.kkcycleScrollView.imageURLStringsGroup = muarray.copy;

}

#pragma mark ====代理事件处理
/** 轮播图点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
 //index从小标0开始
    KKLiveRoomBottomFunctionModel *model = self.bannerArray[index];
    if ([model.type intValue] == 1) {
        if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkHorizontalCycleScrollViewDidSelectWithUrl:)]) {
            [self.kkHorizontalViewDelegate kkHorizontalCycleScrollViewDidSelectWithUrl:model.url];
        }
    }else if([model.type intValue] == 2){
        //应用外跳转,可以直接在Safari中打开百度链接，
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url] options:@{} completionHandler:nil];
    }
}

//点击主播弹窗
-(void)zhubomessage
{
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkZhuboInfoClick)]) {
        [self.kkHorizontalViewDelegate kkZhuboInfoClick];
    }
}
//关注zhubo
-(void)guanzhuZhuBo
{
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(guanzhuZhuBo)]) {
        [self.kkHorizontalViewDelegate guanzhuZhuBo];
    }
}
//跳贡献榜
-(void)gongxianbang
{
    KKLiveRoomRankAlertView *kkalertView = [[KKLiveRoomRankAlertView alloc]init];
    kkalertView.kkRankDic = self.kkLiveDic;
    kkalertView.kkIsHorizontal = YES;
    WeakSelf;
    kkalertView.kkTotalRankBtnClickBlock = ^(KKLiveRoomRankAlertView * _Nonnull kkRankAlertView) {
//        [weakSelf kkPortraitBtnClickBlock];
        if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkgongxianbang)]) {
            [self.kkHorizontalViewDelegate kkgongxianbang];
        }

        KKWebH5ViewController *nVC = [[KKWebH5ViewController alloc]init];
        nVC.kkJumpType = 1;
//        [weakSelf.navigationController pushViewController:nVC animated:YES];
        [[MXBADelegate sharedAppDelegate] pushViewController:nVC animated:YES];

    };
    [kkalertView kkShow];

    [kkalertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KKScreenWidth-(KKScreenHeight-30)- ShowDiff -15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(KKScreenHeight-40);
        make.width.mas_equalTo(KKScreenHeight);

    }];
    [UIView animateWithDuration:0.3 animations:^{
        [kkalertView layoutIfNeeded];
    }];

    
}


#pragma mark ====事件处理

- (void)kkBottomBtnClick:(KKLiveRoomBottomFunctionModel *)model
{
    if ([model.kkid isEqualToString:@"12"]) {
        [MBProgressHUD kkshowMessage:@"该功能暂未开放"];
        return;
    }
            //轮盘抽奖
    model.url = [model.url stringByAppendingFormat:@"&zuid=%@&uid=%@&token=%@",self.kkLiveDic[@"uid"],[Config getOwnID],[Config getOwnToken]];

    KKBottomH5View *kkalertView = [[KKBottomH5View alloc]init];
    kkalertView.kkModel = model;
    kkalertView.kkIsHorizontal = YES;
    kkalertView.kkIsScroll = YES;
    kkalertView.kkOpenKnapsackBlock = ^(KKBottomH5View * _Nonnull kkview) {
        [kkview kkDismiss];
    };
    [kkalertView kkShow];
    
    [kkalertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KKScreenWidth-(KKScreenHeight-30)- ShowDiff -15);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(KKScreenHeight-30);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [kkalertView layoutIfNeeded];
    }];

}

- (void)kkTextBtnClick
{
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkTextBtnClick)]) {
        [self.kkHorizontalViewDelegate kkTextBtnClick];
    }

}
- (void)kkGiftBtnClick
{
    [self kkHideToolView];
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkHorizontalGiftBtnClick)]) {
        [self.kkHorizontalViewDelegate kkHorizontalGiftBtnClick];
    }
}

- (void)kkPortraitBtnClick
{
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkPortraitBtnClickBlock)]) {
        [self.kkHorizontalViewDelegate kkPortraitBtnClickBlock];
    }
}
- (void)kkBarrageBtnClick
{
    if (self.kkBarrageBtn.isSelected) {
        //    显示
        self.kkBarrageBtn.selected = NO;
        self.kkBarrageWebView.hidden = NO;
        [self.kkBarrageBtn setImage:[UIImage imageNamed:@"KKHorizontal_barrage_Normal"] forState:UIControlStateNormal];
        [MBProgressHUD kkshowMessage:@"屏蔽已关闭"];
    }else{
        //隐藏弹幕
        self.kkBarrageBtn.selected = YES;
        self.kkBarrageWebView.hidden = YES;
        [self.kkBarrageBtn setImage:[UIImage imageNamed:@"KKHorizontal_barrage_Selected"] forState:UIControlStateNormal];
        [MBProgressHUD kkshowMessage:@"屏蔽已开启"];

    }
}
- (void)kkDefinitionBtnClick
{
    [MBProgressHUD kkshowMessage:@"该功能暂未开放"];
}
//清屏
- (void)kkContentViewClick
{
//    在这里根据frame判断功能视图是否隐藏

    if (self.kkIsShowTool) {
        [self kkHideToolView];

    }else{
        [self kkShowToolView];
    }
    //这个代理事件影响到清屏功能了
    if ([self.kkHorizontalViewDelegate respondsToSelector:@selector(kkContentViewClearClick)]) {
        [self.kkHorizontalViewDelegate kkContentViewClearClick];
    }

}
- (void)kkHideToolView
{
    WeakSelf;
    self.kkIsShowTool = NO;
//    [weakSelf kkSetupFrame];//当前控件的父视图调用

    [self.kkTopToolV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-150);
        make.left.mas_equalTo(kkStatusbarH);
        make.right.mas_equalTo(-ShowDiff);
        make.height.mas_equalTo(150);
    }];
    [self.kkBottomToolV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(0);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf layoutIfNeeded];//当前控件的父视图调用
    }];
}
- (void)kkShowToolView
{
    WeakSelf;
    self.kkIsShowTool = YES;
//    [weakSelf kkSetupFrame];//当前控件的父视图调用

    [weakSelf.kkTopToolV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kkStatusbarH);
        make.right.mas_equalTo(-ShowDiff);
        make.height.mas_equalTo(150);
    }];
    [self.kkBottomToolV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(-100);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf layoutIfNeeded];//当前控件的父视图调用
    }];
    
}

#pragma mark -- 懒加载
-(SDCycleScrollView *)kkcycleScrollView{
    if (_kkcycleScrollView == nil) {
//        CGRect kkRect = CGRectMake(KKScreenWidth -100 -15, self.kkTicketView.y, 100, 35);
        _kkcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _kkcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _kkcycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#e03870"];
        _kkcycleScrollView.pageDotColor = [UIColor lightGrayColor];
        _kkcycleScrollView.placeholderImage = [UIImage imageNamed:@"kkbannerPlaceholder_cover_icon"];

    }
    return _kkcycleScrollView;
}

@end
