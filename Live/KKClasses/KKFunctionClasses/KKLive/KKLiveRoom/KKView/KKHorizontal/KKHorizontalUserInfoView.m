//
//  KKHorizontalUserInfoView.m
//  yunbaolive
//
//  Created by Peter on 2020/10/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKHorizontalUserInfoView.h"


#define kkleftViewH 38.66
#define kkOnLinePersonBtnW 35

@interface KKHorizontalUserInfoView ()
@property(weak,nonatomic)UIView *kkContentV;
@property(weak,nonatomic)UIButton *kkNewattention;
@property(weak,nonatomic)UIButton *kkIconBTN;
@property(weak,nonatomic)UIImageView *kkIconBtnFrameImgV;

@property(weak,nonatomic)UILabel *kkUserNameLab;
@property(weak,nonatomic)UILabel *kkUidLabel;

@property(strong,nonatomic)UIView *kkTicketView;
@property(weak,nonatomic)UIImageView *kkLeftTicketIconImgV;
@property(weak,nonatomic)UIImageView *kkMiddleTicketIconImgV;

@property(weak,nonatomic)UIImageView *kkOnLinePersonImgV;
@property(weak,nonatomic)UILabel *kkOnLinePersonLab;

@property(weak,nonatomic)UILabel *kkyingpiaoLabel;

@end

@implementation KKHorizontalUserInfoView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
    
    UIView *kkContentV = [[UIView alloc]init];
    self.kkContentV = kkContentV;
    [self addSubview:kkContentV];
    kkContentV.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];


    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [kkContentV addGestureRecognizer:tapleft];

    //主播头像button
    UIButton *kkIconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkIconBTN = kkIconBTN;
    [self.kkContentV addSubview:kkIconBTN];
    [kkIconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *kk_IconBtnFrameImgV  = [[UIImageView alloc]init];
    self.kkIconBtnFrameImgV = kk_IconBtnFrameImgV;
    [self addSubview:kk_IconBtnFrameImgV];
    kk_IconBtnFrameImgV.image = [UIImage imageNamed:@"KKSecondPage_userIconBorderViewIcon"];
    kk_IconBtnFrameImgV.contentMode = UIViewContentModeScaleAspectFill;
    
        //直播live
    UILabel *kkUserNameLab = [[UILabel alloc]init];
    self.kkUserNameLab = kkUserNameLab;
    [self.kkContentV addSubview:kkUserNameLab];
    kkUserNameLab.textAlignment = NSTextAlignmentLeft;
    kkUserNameLab.text = minstr([self.zhuboDic valueForKey:@"user_nicename"]);
    kkUserNameLab.textColor = KKWhiteColor;
    kkUserNameLab.font = kkFontBoldMT(11.33);

    UILabel *kkUidLabel = [[UILabel alloc]init];
    self.kkUidLabel = kkUidLabel;
    [self.kkContentV addSubview:kkUidLabel];
    kkUidLabel.textAlignment = NSTextAlignmentLeft;
    kkUidLabel.textColor = KKWhiteColor;
    kkUidLabel.font = [UIFont systemFontOfSize:10];
    kkUidLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([_zhuboDic valueForKey:@"uid"])];

        //关注主播
    UIButton *kkNewattention = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkNewattention = kkNewattention;
    [self.kkContentV addSubview:kkNewattention];

    [kkNewattention setTitleColor:[UIColor colorWithHexString:@"#ff2e67"] forState:UIControlStateNormal];
    kkNewattention.titleLabel.font = kkFontBoldMT(12);
    [kkNewattention setBackgroundColor:KKWhiteColor];
    kkNewattention.contentMode = UIViewContentModeScaleAspectFit;
    [kkNewattention addTarget:self action:@selector(kkguanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *kkTicketView = [[UIView alloc]init];
    [self addSubview:kkTicketView];
    self.kkTicketView = kkTicketView;
    kkTicketView.backgroundColor = [KKBlackTitleLabColor colorWithAlphaComponent:0.2];

    UIImageView *kkLeftTicketIconImgV  = [[UIImageView alloc]init];
    [self.kkTicketView addSubview:kkLeftTicketIconImgV];
    self.kkLeftTicketIconImgV = kkLeftTicketIconImgV;
    kkLeftTicketIconImgV.image = [UIImage imageNamed:@"kkLive_twoPage_LeftTicket_Icon"];
    kkLeftTicketIconImgV.contentMode = UIViewContentModeScaleAspectFill;
        
    UIImageView *kkMiddleTicketIcon  = [[UIImageView alloc]init];
    [self.kkTicketView addSubview:kkMiddleTicketIcon];
    self.kkMiddleTicketIconImgV = kkMiddleTicketIcon;
    kkMiddleTicketIcon.image = [UIImage imageNamed:@"kkLive_twoPage_MiddleTicket_Icon"];
    kkMiddleTicketIcon.contentMode = UIViewContentModeScaleToFill;
        
        //魅力值//魅力值
        //修改 魅力值 适应字体 欣
    UILabel *kkyingpiaoLabel  = [[UILabel alloc]init];
    self.kkyingpiaoLabel = kkyingpiaoLabel;
    [self.kkTicketView addSubview:kkyingpiaoLabel];
    kkyingpiaoLabel.font = kkFontBoldMT(10.66);
    kkyingpiaoLabel.textAlignment = NSTextAlignmentLeft;
    kkyingpiaoLabel.textColor = KKWhiteColor;
    UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkyingpiaoClick)];
    [self.kkTicketView addGestureRecognizer:yingpiaoTap];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    WeakSelf;
    [self.kkContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(25+statusbarHeight);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(leftW);
    }];
    [self.kkIconBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.4);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(kkleftViewH-5);
        make.height.mas_equalTo(kkleftViewH-5);
    }];
    
    [self.kkIconBtnFrameImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkContentV);
        make.top.mas_equalTo(self.kkContentV.mas_top).mas_equalTo(-0.5);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38.6);
    }];
    
    [self.kkUserNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkIconBtnFrameImgV.mas_right).mas_offset(4);
        make.top.mas_equalTo(5.5);//6
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(12);
    }];
    [self.kkUidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserNameLab);
        make.bottom.mas_equalTo(-5.5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(8);
    }];
    [self.kkNewattention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        if ([weakSelf.kkNewattention.titleLabel.text isEqualToString:@"关注"]) {
            make.width.mas_equalTo(35);
        }else{
            make.width.mas_equalTo(50);
        }
    }];
    
    NSString *kkyingPiao = @"";
    CGFloat  kkTicketNum = [[self.zhuboDic objectForKey:@"votestotal"] integerValue]/10000;
     if (kkTicketNum >= 1) {
         kkyingPiao = [NSString stringWithFormat:@"%.1f万",kkTicketNum];
     }else{
         kkyingPiao = [NSString stringWithFormat:@"%@",[self.zhuboDic objectForKey:@"votestotal"]];
     }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",[common name_votes],kkyingPiao];
    CGFloat width = [[YBToolClass sharedInstance] widthOfString:str andFont:kkFontBoldMT(12) andHeight:12];

    [self.kkTicketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.kkContentV.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(width + 45);//45
    }];

    
    [self.kkLeftTicketIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(self.kkTicketView);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(12);
    }];

    [self.kkyingpiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.kkLeftTicketIconImgV.mas_right).mas_equalTo(6);
        make.centerY.mas_equalTo(self.kkTicketView);
        make.height.mas_equalTo(12.5);
    }];
    [self.kkMiddleTicketIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkyingpiaoLabel.mas_right).mas_equalTo(5.3);
        make.centerY.mas_equalTo(self.kkTicketView);
        make.height.mas_equalTo(9);
        make.width.mas_equalTo(5);
    }];

}


- (void)setZhuboDic:(NSDictionary *)zhuboDic
{
    _zhuboDic = zhuboDic;
        
    NSString *path = [zhuboDic valueForKey:@"avatar"];
        NSURL *url = [NSURL URLWithString:path];
    [self.kkIconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:kkPlaceholderHeadIconImageStr]];

    //kk感觉好像有问题
    self.kkUserNameLab.text = minstr([self.zhuboDic valueForKey:@"user_nicename"]);

    self.kkUidLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([_zhuboDic valueForKey:@"uid"])];

    [self changeState:[self.zhuboDic objectForKey:@"votestotal"] andID:nil];

    [self isAttentionLive:zhuboDic[@"kkIsAttention"]];
}

//改变左上角 映票数量
-(void)changeState:(NSString *)texts andID:(NSString *)ID{

    [self.zhuboDic setValue:texts forKey:@"votestotal"];
    
    NSString *kkyingPiao = @"";
    CGFloat  kkTicketNum = [texts integerValue]/10000;
     if (kkTicketNum >= 1) {
         kkyingPiao = [NSString stringWithFormat:@"%.1f万",kkTicketNum];
     }else{
         kkyingPiao = [NSString stringWithFormat:@"%@",texts];
     }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",[common name_votes],kkyingPiao];
//    CGFloat width = [[YBToolClass sharedInstance] widthOfString:str andFont:kkFontBoldMT(12) andHeight:12];
    self.kkyingpiaoLabel.text = str;
}

-(void)isAttentionLive:(NSString *)isattention{
    if ([isattention isEqual:@"0"]) {
        //未关注
        self.kkNewattention.hidden = NO;
        [self.kkNewattention setTitle:@"关注" forState:UIControlStateNormal];
        [self.kkNewattention mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(35);
        }];
    }
    else{
        //关注
        [self.kkNewattention setTitle:@"已关注" forState:UIControlStateNormal];
        [self.kkNewattention mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
        }];
         self.kkNewattention.hidden = NO;
    }
}

#pragma mark ===== 代理事件

-(void)zhuboMessage{
    if ([self.kkUserInfoDelegate respondsToSelector:@selector(zhubomessage)]) {
        [self.kkUserInfoDelegate zhubomessage];
    }
}

- (void)kkguanzhuzhubo
{
  
    
}
//跳魅力值页面
-(void)kkyingpiaoClick{
    if ([self.kkUserInfoDelegate respondsToSelector:@selector(gongxianbang)]) {
        [self.kkUserInfoDelegate gongxianbang];
    }
}


@end
