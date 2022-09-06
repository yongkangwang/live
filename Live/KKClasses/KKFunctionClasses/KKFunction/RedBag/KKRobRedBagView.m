//
//  KKRobRedBagView.m
//  yunbaolive
//
//  Created by Peter on 2021/11/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKRobRedBagView.h"

#import "KKRobRedBagTopCell.h"
#import "KKRobRedBagCell.h"

@interface KKRobRedBagView ()<UITableViewDataSource,UITableViewDelegate>

//开红包
@property (nonatomic,weak) UIButton *kkCloseBtn;

@property (nonatomic,weak) UIView *kkContentView;
@property (nonatomic,weak) UIImageView *kkAnimatBgUPImgV;
@property (nonatomic,weak) UIImageView *kkAnimatBgDownImgV;

@property (nonatomic,weak) UIImageView *kkBgPacketUpImgV;
@property (nonatomic,weak) UIImageView *kkBgPacketDownImgV;

@property (nonatomic,weak) UIButton *kkLookDetailsBtn;
@property (nonatomic,weak) UIImageView *kkRobBtnImgV;


@property (nonatomic,weak) UILabel *kkDescribeLab;
@property (nonatomic,weak) UIImageView *kkSenderImgV;
@property (nonatomic,weak) UILabel *kkSenderNameLab;


//红包详情
@property (nonatomic,weak) UIView *kkPacketContentView;
@property (nonatomic,weak) UITableView *kkTableView;
@property (nonatomic,weak) UIImageView *kkTopBGImgV;
@property (nonatomic,weak) UIButton *kkGoBackBtn;

@property (nonatomic,strong) NSMutableDictionary *kkPacketDetailDic;
@property (nonatomic,strong) NSArray *kkRobListArr;

@property (nonatomic,assign) NSInteger kkTopCellHeight;


@end

@implementation KKRobRedBagView


-(void)kkShow
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    WeakSelf;
    [UIView animateWithDuration:1 animations:^{
        [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
    }];
    [self kkRedBagLayout];

}

- (void)kkDismiss
{
    [self removeFromSuperview];
}
-(void)setKkDic:(NSMutableDictionary *)kkDic
{
    _kkDic = kkDic;
    //    kkdic[@"packetId"] = kkdata.packetId;
    //    kkdic[@"sendUserName"] = kkdata.sendUserName;
    //    kkdic[@"sendavatar"] = kkdata.sendavatar;
    //    kkdic[@"message"] = kkdata.message;
    self.kkDescribeLab.text = kkDic[@"message"];
    self.kkSenderNameLab.text = [NSString stringWithFormat:@"%@发出的红包",kkDic[@"sendUserName"]];
    [self.kkSenderImgV sd_setImageWithURL:[NSURL URLWithString:kkDic[@"sendavatar"]]];
    
    [self kkLoadData];

}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];

        [self kkSetupRedPacketUI];
        //添加子控件
        [self kksetupRedBagUI];
    }
    return self;
}

- (void)kkSetupRedPacketUI
{
    self.kkTopCellHeight = 310;
    
    UIView *kkContentView = [[UIView alloc]init];
    [self addSubview:kkContentView];
    self.kkPacketContentView = kkContentView;
    kkContentView.hidden = YES;
    self.kkPacketContentView.alpha = 0;

    UITableView *kkTableView = [[UITableView alloc]init];
    self.kkTableView = kkTableView;
    [self.kkPacketContentView addSubview:self.kkTableView];
    kkTableView.delegate = self;
    kkTableView.dataSource = self;

    [self.kkTableView registerClass:[KKRobRedBagCell class] forCellReuseIdentifier:@"KKRobRedBagCell"];
    [self.kkTableView registerClass:[KKRobRedBagTopCell class] forCellReuseIdentifier:@"KKRobRedBagTopCell"];
    self.kkTableView.separatorStyle = UITableViewCellAccessoryNone;
    self.kkTableView.backgroundColor = [UIColor whiteColor];
    self.kkTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.kkTableView.estimatedRowHeight = 0;
    self.kkTableView.estimatedSectionHeaderHeight = 0;
    self.kkTableView.estimatedSectionFooterHeight = 0;
    self.kkTableView.showsVerticalScrollIndicator = NO;
    
    UIImageView *kkTopBGImgV = [[UIImageView alloc]init];
    self.kkTopBGImgV = kkTopBGImgV;
    [self.kkPacketContentView addSubview:kkTopBGImgV];
    kkTopBGImgV.image = [UIImage imageNamed:@"KKRedPacket_twoUp_bgicon"];

    UIButton *kkGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkGoBackBtn = kkGoBackBtn;
    [self.kkPacketContentView addSubview:kkGoBackBtn];
    [kkGoBackBtn addTarget:self action:@selector(kkGoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkGoBackBtn setImage:[UIImage imageNamed:@"KKRank_backBtn_icon"] forState:UIControlStateNormal];
    kkGoBackBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);

}

- (void)kksetupRedBagUI
{
    UIView *kkContentView = [[UIView alloc]init];
    [self addSubview:kkContentView];
    self.kkContentView = kkContentView;

    UIButton *kkGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkCloseBtn = kkGoBackBtn;
    [self addSubview:kkGoBackBtn];
    [kkGoBackBtn addTarget:self action:@selector(kkGoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkGoBackBtn setImage:[UIImage imageNamed:@"KKRobRedBagView_close"] forState:UIControlStateNormal];
    
    UIImageView *kkAnimatBgUPImgV = [[UIImageView alloc]init];
    self.kkAnimatBgUPImgV = kkAnimatBgUPImgV;
    [self.kkContentView addSubview:kkAnimatBgUPImgV];
    kkAnimatBgUPImgV.image = [UIImage imageNamed:@"KKRedPacketUp_bgicon"];
    
    UIImageView *kkAnimatBgDownImgV = [[UIImageView alloc]init];
    self.kkAnimatBgDownImgV = kkAnimatBgDownImgV;
    [self.kkContentView addSubview:kkAnimatBgDownImgV];
    kkAnimatBgDownImgV.image = [UIImage imageNamed:@"KKRedPacketDown_bgicon"];
    
    UIImageView *kkBgPacketUpImgV = [[UIImageView alloc]init];
    self.kkBgPacketUpImgV = kkBgPacketUpImgV;
    [self.kkContentView addSubview:kkBgPacketUpImgV];
    kkBgPacketUpImgV.image = [UIImage imageNamed:@"KKRobRedBagView_BG_up_Icon"];
    
    UIImageView *kkBgPacketDownImgV = [[UIImageView alloc]init];
    self.kkBgPacketDownImgV = kkBgPacketDownImgV;
    [self.kkContentView addSubview:kkBgPacketDownImgV];
    kkBgPacketDownImgV.image = [UIImage imageNamed:@"KKRobRedBagView_BG_down_Icon"];
    
    UIButton *kkLookDetailsBtn = [UIButton kkButtonImageRightWithTitle:@"查看领取详情" image:@"KKHorizontalScrollTextView_goImg" font:13 color:[UIColor colorWithHexString:@"#F5DFAB"]];
    self.kkLookDetailsBtn = kkLookDetailsBtn;
    [self.kkContentView addSubview:kkLookDetailsBtn];
    [kkLookDetailsBtn addTarget:self action:@selector(kkLookDetailsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *kkRobBtnImgV = [[UIImageView alloc]init];
    self.kkRobBtnImgV = kkRobBtnImgV;
    [self.kkContentView addSubview:kkRobBtnImgV];
    kkRobBtnImgV.image = [UIImage imageNamed:@"redPacket1"];
    kkRobBtnImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkRobBtnClick)];
    [kkRobBtnImgV addGestureRecognizer:tapges];

    UILabel *kkDescribeLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#F5DFAB"] textFont:[UIFont systemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    self.kkDescribeLab = kkDescribeLab;
    [self.kkContentView addSubview:kkDescribeLab];

    UIImageView *kkSenderImgV = [[UIImageView alloc]init];
    self.kkSenderImgV = kkSenderImgV;
    [self.kkContentView addSubview:kkSenderImgV];

    
    UILabel *kkSenderNameLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#F5DFAB"] textFont:[UIFont systemFontOfSize:16] andTextAlignment:NSTextAlignmentCenter];
    self.kkSenderNameLab = kkSenderNameLab;
    [self.kkContentView addSubview:kkSenderNameLab];

    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self kkRedPacketLayout];
//    [self kkRedBagLayout];
    
}
- (void)kkRedPacketLayout
{
    [self.kkPacketContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkPacketContentView);
    }];
    [self.kkTopBGImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.kkPacketContentView);
        make.height.mas_equalTo(80+kkStatusbarH);
    }];
    [self.kkGoBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(kkStatusbarH);
        make.width.height.mas_equalTo(40);
    }];

    

}
- (void)kkRedBagLayout
{
    [self.kkCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-(ShowDiff+50));
        make.width.height.mas_equalTo(40);
    }];

    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KKNavH+50);
        make.bottom.mas_equalTo(self.kkCloseBtn.mas_top).mas_offset(-20);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    
    [self.kkAnimatBgDownImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    [self.kkAnimatBgUPImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(self.kkAnimatBgDownImgV.mas_top).mas_offset(50);
    }];
    
    [self.kkBgPacketDownImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.kkContentView);
        make.height.mas_equalTo(100);
    }];
    [self.kkBgPacketUpImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(self.kkBgPacketDownImgV.mas_top).mas_offset(1);
    }];
    
    [self.kkLookDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(-20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    [self.kkRobBtnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(self.kkBgPacketDownImgV.mas_top).mas_offset(-40);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
    
    [self.kkDescribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(140);
    }];
    [self.kkSenderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
        make.bottom.mas_equalTo(self.kkDescribeLab.mas_top).mas_offset(-15);
    }];
    [self.kkSenderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkSenderNameLab.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.kkSenderNameLab);
        make.width.height.mas_equalTo(21);
    }];

}


//MARK:-tableviewDateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//102
    {
        KKRobRedBagTopCell *cell = [KKRobRedBagTopCell cellWithTabelView:tableView];
        cell.kkDic = self.kkDic;
        cell.kkDetailDic = self.kkPacketDetailDic;
        return cell;
    }
    else  {
        KKRobRedBagCell *cell = [KKRobRedBagCell cellWithTabelView:tableView];
        //右边箭头，不管用，iOS13适配问题
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.kkDic = self.kkRobListArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //kk分割线颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = KKRGB(245, 245, 245);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        return 280;
        return self.kkTopCellHeight;
    }
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark =======  开红包事件

- (void)kkGoBackBtnClick
{
    [self kkDismiss];
}

- (void)kkRobBtnClick
{
    
    NSMutableArray *array3=[NSMutableArray array];
    for (int j=0; j<8; j++) {
        NSString *imageName=[NSString stringWithFormat:@"redPacket%d.png",j+1];
        UIImage *image=[UIImage imageNamed:imageName];

        [array3 addObject:image];
    }
    //要展示的动画
    self.kkRobBtnImgV.animationImages=array3;
    //一次动画的时间
    self.kkRobBtnImgV.animationDuration= 1 ;//[array3 count]*0.008;
    //只执行一次动画
    self.kkRobBtnImgV.animationRepeatCount = 1;
    //开始动画
    [self.kkRobBtnImgV startAnimating];
    
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf kkLookDetailsBtnClick];
    });

    
}


- (void)kkTemp
{
    //开红包动画
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
     transformAnima.fromValue = @(0);
    transformAnima.toValue = [NSNumber numberWithFloat: M_PI];
    transformAnima.duration = 0.5;
    transformAnima.cumulative = YES;
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = HUGE_VALF;
    transformAnima.fillMode = kCAFillModeForwards;
    transformAnima.removedOnCompletion = NO;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.kkRobBtnImgV.layer.zPosition = 5;
    self.kkRobBtnImgV.layer.zPosition = self.kkRobBtnImgV.layer.frame.size.width/2.f;
    [self.kkRobBtnImgV.layer addAnimation:transformAnima forKey:@"rotationAnimationY"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.kkRobBtnImgV.layer removeAllAnimations];
    });

}

- (void)kkLookDetailsBtnClick
{
    self.kkBgPacketDownImgV.hidden = YES;
    self.kkBgPacketUpImgV.hidden = YES;
    self.kkLookDetailsBtn.hidden = YES;
    self.kkCloseBtn.hidden = YES;
    
    WeakSelf;
    [weakSelf kkRobRedBagLoadData:1];

    dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"线程 %@",[NSThread currentThread]);
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.kkContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-KKScreenWidth);
                make.bottom.mas_equalTo(weakSelf.kkCloseBtn.mas_top).mas_offset(ShowDiff+90);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
            }];
            [weakSelf.kkAnimatBgDownImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(100);
            }];
            [weakSelf.kkAnimatBgUPImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(weakSelf.kkContentView);
                make.bottom.mas_equalTo(weakSelf.kkAnimatBgDownImgV.mas_top).mas_offset(-(KKScreenHeight*0.9));
            }];

            weakSelf.kkPacketContentView.hidden = NO;
            weakSelf.kkPacketContentView.alpha = 1;
        } completion:^(BOOL finished) {
            weakSelf.kkContentView.hidden = YES;
        }];
    });
    
}


- (void)kkLoadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"hongbaoever_hongbaoid"] = self.kkDic[@"packetId"];
    WeakSelf;
    [KKFunctionAPI kk_PostCheckRedBagInfoWithparameters:param successBlock:^(id  _Nullable response) {
        
        if ([response[@"status"] intValue] == 1) {
//            shifoucanyu 1参与  0没参与    shifouqiangwan  1没有领完  2已领完

            int isjoin = [response[@"shifoucanyu"] intValue];
            int isHaveBag = [response[@"shifouqiangwan"] intValue];
            if (isjoin == 1) {
                //调详情接口
                [weakSelf kkRobRedBagLoadData:2];
//                [weakSelf kkLookDetailsBtnClick];
            }else{
                if (isHaveBag == 1) {
//                    没有领完
                    weakSelf.kkRobBtnImgV.hidden = NO;
                    weakSelf.kkLookDetailsBtn.hidden = YES;
                }else{
                    weakSelf.kkRobBtnImgV.hidden = YES;
                    weakSelf.kkDescribeLab.text = @"手慢了，红包已派完";
                    weakSelf.kkTopCellHeight = 230;
                }
            }

        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];
    
}

//type 1枪红包，2已抢过显示红包金额，
- (void)kkRobRedBagLoadData:(int)type
{
    self.kkRobBtnImgV.hidden = YES;
    if (type == 1) {
        self.kkLookDetailsBtn.hidden = YES;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"hongbaoever_hongbaoid"] = self.kkDic[@"packetId"];
    WeakSelf;
    [KKFunctionAPI kk_PostRobRedBagInfoWithparameters:param successBlock:^(id  _Nullable response) {
        if ([response[@"status"] intValue] == 1) {
            NSMutableDictionary *kkpacket = [NSMutableDictionary dictionaryWithDictionary:response[@"hongbaomingxi"]];
            NSDictionary *mymoney;
            if ([response[@"wodemingxi"] isKindOfClass:[NSDictionary class]]) {
                mymoney = response[@"wodemingxi"];
            }else{
                mymoney = [NSDictionary dictionary];
            }
            kkpacket[@"kkmoney"] = [NSString kk_isNullString:mymoney[@"hongbaoever_money"]];
            weakSelf.kkPacketDetailDic = kkpacket;
            
            if ([response[@"lingqulist"] isKindOfClass:[NSArray class]]) {
                weakSelf.kkRobListArr = response[@"lingqulist"];
            }
            if (type == 2) {
                weakSelf.kkBgPacketDownImgV.hidden = YES;
                weakSelf.kkBgPacketUpImgV.hidden = YES;
                weakSelf.kkLookDetailsBtn.hidden = YES;
                weakSelf.kkCloseBtn.hidden = YES;
                
                weakSelf.kkPacketContentView.hidden = NO;
                weakSelf.kkPacketContentView.alpha = 1;
                weakSelf.kkContentView.hidden = YES;

                weakSelf.kkDescribeLab.text = [NSString stringWithFormat:@"%@币",[NSString kk_isNullString:mymoney[@"hongbaoever_money"]]];
            }
            
            [weakSelf.kkTableView reloadData];
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];

}


- (NSMutableDictionary *)kkPacketDetailDic
{
    if (!_kkPacketDetailDic) {
        _kkPacketDetailDic = [NSMutableDictionary dictionary];
    }
    return _kkPacketDetailDic;
}
- (NSArray *)kkRobListArr
{
    if (!_kkRobListArr) {
        _kkRobListArr = [NSArray array];
    }
    return _kkRobListArr;

}


@end
