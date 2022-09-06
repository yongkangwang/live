//
//  KKLiveRoomActivityView.m
//  yunbaolive
//
//  Created by Peter on 2021/6/11.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveRoomActivityView.h"

#import "LMJHorizontalScrollText.h"
#import "KKAlertH5WebView.h"
#import "KKLiveRoomRankAlertView.h"

#import "KKWebH5ViewController.h"

@interface KKLiveRoomActivityView ()

//公告
@property(weak,nonatomic)UIButton *kkAfficheBtn;

//任务
@property(weak,nonatomic)UIView *kkTaskView;
@property(weak,nonatomic)UIImageView *kkTaskImgV;
@property(weak,nonatomic)UILabel *kkTaskTitleLab;
@property(weak,nonatomic)LMJHorizontalScrollText *kkTaskContentLab;
//@property(weak,nonatomic)UIImageView *kkTaskFillImgV;

//奖池
@property(weak,nonatomic)UIView *kkPrizeView;
@property(weak,nonatomic)UIImageView *kkPrizeImgV;
@property(weak,nonatomic)UILabel *kkPrizeTitleLab;
@property(weak,nonatomic)UILabel *kkPrizeGoldLab;

//票
@property(weak,nonatomic)UIView *kkGoldView;
@property(weak,nonatomic)UIImageView *kkGradeImgV;
@property(weak,nonatomic)UILabel *kkGoldTitleLab;
@property(weak,nonatomic)UILabel *kkGoldLab;


@end

@implementation KKLiveRoomActivityView

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
 
    UIButton *kkAfficheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkAfficheBtn = kkAfficheBtn;
    [self addSubview:kkAfficheBtn];
    [kkAfficheBtn setTitle:@"公告" forState:UIControlStateNormal];
    kkAfficheBtn.titleLabel.font = KKLab11Font;
    kkAfficheBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#FDFDFD"];
    kkAfficheBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [kkAfficheBtn setEnLargeEdge:10];
    kkAfficheBtn.backgroundColor = [KKBlackLabColor colorWithAlphaComponent:0.5];
    [kkAfficheBtn addTarget:self action:@selector(kkAfficheBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIView *kkTaskView = [[UIView alloc]init];
    self.kkTaskView = kkTaskView;
    [self addSubview:kkTaskView];
    kkTaskView.backgroundColor = [KKBlackLabColor colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkTaskViewClick)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [kkTaskView addGestureRecognizer:tapleft];

    
//    UIImageView *kkTaskFillImgV = [[UIImageView alloc]init];
//    self.kkTaskFillImgV = kkTaskFillImgV;
//    [self.kkTaskView addSubview:kkTaskFillImgV];
    
    UIImageView *kkTaskImgV = [[UIImageView alloc]init];
    self.kkTaskImgV = kkTaskImgV;
    [self.kkTaskView addSubview:kkTaskImgV];
    kkTaskImgV.image = [UIImage imageNamed:@"KKLiveRoom_kkTaskNameBtnIcon"];
    
    UILabel *kkTaskTitleLab = [UILabel kkLabelWithText:@"预言" textColor:[UIColor colorWithHexString:@"#2BDBF2"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkTaskTitleLab = kkTaskTitleLab;
    [self.kkTaskView addSubview:kkTaskTitleLab];

//    UILabel *kkTaskContentLab = [UILabel kkLabelWithText:@"任务" textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
//    self.kkTaskContentLab = kkTaskContentLab;
//    [self.kkTaskView addSubview:kkTaskContentLab];
//
    LMJHorizontalScrollText * kkScrollText = [[LMJHorizontalScrollText alloc] init];
    self.kkTaskContentLab = kkScrollText;
    [self.kkTaskView addSubview:kkScrollText];
    kkScrollText.backgroundColor = [UIColor clearColor];
    kkScrollText.layer.cornerRadius = 0;
    kkScrollText.textColor          = [UIColor colorWithHexString:@"#FDFDFD"];
    kkScrollText.textFont           = KKLab11Font;
    kkScrollText.speed              = 0.04;//数值越小，速度越快
    kkScrollText.moveMode           = LMJTextScrollContinuous;
    kkScrollText.moveDirection = LMJTextScrollMoveLeft;
    kkScrollText.isStopScroll = NO;
    kkScrollText.isHiddenLeftImageV = YES;

    //================
    UIView *kkPrizeView = [[UIView alloc]init];
    self.kkPrizeView = kkPrizeView;
    [self addSubview:kkPrizeView];
    kkPrizeView.backgroundColor = [KKBlackLabColor colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkPrizeViewClick)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [kkPrizeView addGestureRecognizer:tap2];

    UIImageView *kkPrizeImgV = [[UIImageView alloc]init];
    self.kkPrizeImgV = kkPrizeImgV;
    [self.kkPrizeView addSubview:kkPrizeImgV];
    kkPrizeImgV.image = [UIImage imageNamed:@"KKLiveRoom_kkPrizeNameBtnIcon"];
    
    UILabel *kkPrizeTitleLab = [UILabel kkLabelWithText:@"奖池" textColor:[UIColor colorWithHexString:@"#F59D10"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkPrizeTitleLab = kkPrizeTitleLab;
    [self.kkPrizeView addSubview:kkPrizeTitleLab];

    UILabel *kkPrizeGoldLab = [UILabel kkLabelWithText:@"0000" textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkPrizeGoldLab = kkPrizeGoldLab;
    [self.kkPrizeView addSubview:kkPrizeGoldLab];

    //================
    UIView *kkGoldView = [[UIView alloc]init];
    self.kkGoldView = kkGoldView;
    [self addSubview:kkGoldView];
    kkGoldView.backgroundColor = [KKBlackLabColor colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkGoldViewClick)];
    tap3.numberOfTapsRequired = 1;
    tap3.numberOfTouchesRequired = 1;
    [kkGoldView addGestureRecognizer:tap3];

    UIImageView *kkGradeImgV = [[UIImageView alloc]init];
    self.kkGradeImgV = kkGradeImgV;
    [self.kkGoldView addSubview:kkGradeImgV];
//    kkGradeImgV.image = [UIImage imageNamed:@"KKLiveRoom_kkPrizeNameBtnIcon"];
//    kkGradeImgV.contentMode = UIViewContentModeScaleAspectFill;
//    kkGradeImgV.clipsToBounds = YES;//要配合这个使用

    UILabel *kkGoldTitleLab = [UILabel kkLabelWithText:@"票" textColor:[UIColor colorWithHexString:@"#EA357A"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkGoldTitleLab = kkGoldTitleLab;
    [self.kkGoldView addSubview:kkGoldTitleLab];

    UILabel *kkGoldLab = [UILabel kkLabelWithText:@"0000" textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkGoldLab = kkGoldLab;
    [self.kkGoldView addSubview:kkGoldLab];

    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkAfficheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(18);
    }];
    self.kkAfficheBtn.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:9 fromView:self.kkAfficheBtn];
    
    //=========================
        [self.kkGoldView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkAfficheBtn);
//            make.right.mas_equalTo(self.kkPrizeView.mas_left).mas_offset(-7);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(self.kkAfficheBtn);
//            make.width.mas_equalTo(86);
//            make.right.mas_equalTo(self.kkGoldLab.mas_right);
        }];
        self.kkGoldView.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:9 fromView:self.kkGoldView];
       
        [self.kkGradeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkGoldView);
            make.left.mas_equalTo(3);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(15);
        }];

        [self.kkGoldTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkGoldView);
            make.left.mas_equalTo(self.kkGradeImgV.mas_right).mas_offset(3);
            make.width.mas_equalTo(23);
        }];

        [self.kkGoldLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkGoldView);
            make.left.mas_equalTo(self.kkGoldTitleLab.mas_right).mas_offset(3);
            make.right.mas_equalTo(self.kkGoldView.mas_right).mas_offset(-3);
        }];

    //=========================
        [self.kkPrizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkAfficheBtn);
            make.right.mas_equalTo(self.kkTaskView.mas_left).mas_offset(-7);
            make.left.mas_equalTo(self.kkGoldView.mas_right).mas_offset(7);
            make.height.mas_equalTo(self.kkAfficheBtn);
//            make.width.mas_equalTo(93);
//            make.right.mas_equalTo(self.kkPrizeGoldLab.mas_right);
        }];
        self.kkPrizeView.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:9 fromView:self.kkPrizeView];
       
        [self.kkPrizeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkPrizeView);
            make.left.mas_equalTo(3);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        [self.kkPrizeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkPrizeView);
            make.left.mas_equalTo(self.kkPrizeImgV.mas_right).mas_offset(3);
        }];

        [self.kkPrizeGoldLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.kkPrizeView);
            make.left.mas_equalTo(self.kkPrizeTitleLab.mas_right).mas_offset(3);
            make.right.mas_equalTo(self.kkPrizeView.mas_right).mas_offset(-3);
        }];
    
//    =====================
    [self.kkTaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkAfficheBtn);
        make.right.mas_equalTo(self.kkAfficheBtn.mas_left).mas_offset(-7);
        make.left.mas_equalTo(self.kkPrizeView.mas_right).mas_offset(7);
        make.height.mas_equalTo(self.kkAfficheBtn);
//        make.width.mas_equalTo(135);
//        make.right.mas_equalTo(self.kkTaskContentLab.mas_right);
    }];
    self.kkTaskView.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:9 fromView:self.kkTaskView];
    

    [self.kkTaskImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTaskView);
        make.left.mas_equalTo(3);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [self.kkTaskTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTaskView);
        make.left.mas_equalTo(self.kkTaskImgV.mas_right).mas_offset(3);
    }];

    [self.kkTaskContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTaskView);
        make.left.mas_equalTo(self.kkTaskTitleLab.mas_right).mas_offset(3);
        make.right.mas_equalTo(self.kkTaskView.mas_right).mas_offset(-3);
        make.height.mas_equalTo(12);
    }];

//    [self.kkTaskFillImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.kkTaskView);
//        make.left.mas_equalTo(3);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(15);
//        make.right.mas_equalTo(self.kkTaskTitleLab.mas_left).mas_offset(-2);
//    }];
    

}

- (void)setKkRoomDic:(NSDictionary *)kkRoomDic
{
    _kkRoomDic = kkRoomDic;
    
    self.kkGoldLab.text = kkRoomDic[@"votestotal"];
    [self.kkGradeImgV sd_setImageWithURL:[NSURL URLWithString:kkRoomDic[@"livethumb"]]];
    self.kkPrizeGoldLab.text = kkRoomDic[@"jiangchi_coin"];
    
    NSString *kkTaskStr = kkRoomDic[@"jiangchi_centent"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:kkTaskStr];
    self.kkTaskContentLab.text = kkTaskStr;
    self.kkTaskContentLab.kkAttributedStr = attStr;
    [self.kkTaskContentLab move];

}

//事件处理
- (void)kkAfficheBtnClick
{//公告
    KKAlertH5WebView *kkBarrageWebView = [[KKAlertH5WebView alloc]init];
    [[[self superview] superview] addSubview:kkBarrageWebView];
    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=uzbsx1"];
    kkurl = [NSString kk_AppendH5URL:kkurl];
    kkBarrageWebView.kkUrls = kkurl;
    [kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([[self superview] superview]);
    }];

}
- (void)kkTaskViewClick
{//预言
    KKAlertH5WebView *kkBarrageWebView = [[KKAlertH5WebView alloc]init];
    [[[self superview] superview] addSubview:kkBarrageWebView];
    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=zsyuyan"];
    kkurl = [NSString kk_AppendH5URL:kkurl];
    kkBarrageWebView.kkUrls = kkurl;
    [kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([[self superview] superview]);
    }];

}

- (void)kkPrizeViewClick
{//奖池
    KKAlertH5WebView *kkBarrageWebView = [[KKAlertH5WebView alloc]init];
    [[[self superview] superview] addSubview:kkBarrageWebView];
    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=zsjiangchi"];
    kkurl = [NSString kk_AppendH5URL:kkurl];
    kkBarrageWebView.kkUrls = kkurl;
    [kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([[self superview] superview]);
    }];

}

- (void)kkGoldViewClick
{//花票
    KKLiveRoomRankAlertView *kkalertView = [[KKLiveRoomRankAlertView alloc]init];
    kkalertView.kkRankDic = self.kkAnchorDic;
    kkalertView.kkTotalRankBtnClickBlock = ^(KKLiveRoomRankAlertView * _Nonnull kkRankAlertView) {
        KKWebH5ViewController *nVC = [[KKWebH5ViewController alloc]init];
        nVC.kkJumpType = 1;
        [[MXBADelegate sharedAppDelegate] pushViewController:nVC animated:YES];
    };
    [kkalertView kkShow];

}




@end
