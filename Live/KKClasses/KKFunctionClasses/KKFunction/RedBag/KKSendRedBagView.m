//
//  KKSendRedBagView.m
//  LiveTV
//
//  Created by Peter on 2021/11/16.
//

#import "KKSendRedBagView.h"


@interface KKSendRedBagView ()

@property(weak,nonatomic)UIView *kkContentView;

@property(weak,nonatomic)UIButton *kkGoBackBtn;
@property(weak,nonatomic)UILabel *kkTitleLab;
@property(weak,nonatomic)UIButton *kkRedBagTypeBtn;

@property (nonatomic,assign) int kkBagType;//1平均红包,2拼手气，3单聊红包


@property(weak,nonatomic)UIView *kkRedBadNumV;
@property(weak,nonatomic)UILabel *kkBadNumLeftLab;
@property(weak,nonatomic)UILabel *kkBadNumRLab;
@property(weak,nonatomic)UITextField *kkBadNumTextF;


@property(weak,nonatomic)UIView *kkRedBadMoneyNumV;
@property(weak,nonatomic)UIImageView *kkBadNumMoneyLeftImgV;
@property(weak,nonatomic)UILabel *kkBadNumMoneyLeftLab;
@property(weak,nonatomic)UILabel *kkBadNumMoneyRLab;
@property(weak,nonatomic)UITextField *kkBadNumMoneyTextF;

@property(weak,nonatomic)UILabel *kkBadNumMoneyAverageLeftLab;


@property(weak,nonatomic)UIView *kkRedBadDescribeV;
@property(weak,nonatomic)UITextField *kkDescribeTextF;


@property(weak,nonatomic)UILabel *kkTotalMoneyLab;
@property(weak,nonatomic)UIButton *kkSendRedBagBtn;
@property(weak,nonatomic)UILabel *kkPromptLab;



@end

@implementation KKSendRedBagView

- (void)setKkIsGroup:(BOOL)kkIsGroup
{
    _kkIsGroup = kkIsGroup;
    if (kkIsGroup) {
        
    }else{
        self.kkBagType = 3;
        self.kkRedBagTypeBtn.hidden = YES;
        self.kkRedBadNumV.hidden = YES;
        self.kkBadNumTextF.text = @"1";
    }
}

-(void)kkShow
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(KKScreenHeight);
    }];
    WeakSelf;
    [UIView animateWithDuration:1 animations:^{
        [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
    }];
    
}

- (void)kkDismiss
{
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:237 green:237 blue:237 alpha:1];
        self.kkBagType = 2;
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
    UIView *kkContentView = [[UIView alloc]init];
    [self addSubview:kkContentView];
    self.kkContentView = kkContentView;
    kkContentView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];

    UIButton *kkGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkGoBackBtn = kkGoBackBtn;
    [self.kkContentView addSubview:kkGoBackBtn];
    [kkGoBackBtn addTarget:self action:@selector(kkGoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkGoBackBtn setImage:[UIImage imageNamed:@"KKMyPrivateChat_CloseBtn_icon"] forState:UIControlStateNormal];
    kkGoBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 15);
    
    UILabel *kkTitleLab = [[UILabel alloc]init];
    self.kkTitleLab = kkTitleLab;
    [self.kkContentView addSubview:kkTitleLab];
    kkTitleLab.text = @"发红包";
    kkTitleLab.textColor = KKBlackLabColor;
        
    UIButton *kkRedBagTypeBtn = [UIButton kkButtonImageRightWithTitle:@"拼手气红包" image:@"KKSendRedBagView_bagType_icon" font:12 color:[UIColor colorWithHexString:@"#C89545"]];
    self.kkRedBagTypeBtn = kkRedBagTypeBtn;
    [self.kkContentView addSubview:kkRedBagTypeBtn];
    [kkRedBagTypeBtn addTarget:self action:@selector(kkRedBagTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *kkRedBadNumV = [[UIView alloc]init];
    [self.kkContentView addSubview:kkRedBadNumV];
    self.kkRedBadNumV = kkRedBadNumV;
    kkRedBadNumV.backgroundColor = [UIColor whiteColor];

    
    
    UILabel *kkBadNumLeftLab = [[UILabel alloc]init];
    self.kkBadNumLeftLab = kkBadNumLeftLab;
    [self.kkRedBadNumV addSubview:kkBadNumLeftLab];
    kkBadNumLeftLab.text = @"红包个数";
    kkBadNumLeftLab.textColor = KKBlackLabColor;
    kkBadNumLeftLab.font = KKTitleFont14;
    
    UILabel *kkBadNumRLab = [[UILabel alloc]init];
    self.kkBadNumRLab = kkBadNumRLab;
    [self.kkRedBadNumV addSubview:kkBadNumRLab];
    kkBadNumRLab.text = @"个";
    kkBadNumRLab.textColor = [UIColor blackColor];
    kkBadNumRLab.font = KKTitleFont14;

    UITextField *kkBadNumTextF = [[UITextField alloc]init];
    self.kkBadNumTextF = kkBadNumTextF;
    [self.kkRedBadNumV addSubview:kkBadNumTextF];
//    kkBadNumTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;//文字居下
    kkBadNumTextF.textAlignment = NSTextAlignmentRight;

    kkBadNumTextF.tag = 120;
    kkBadNumTextF.keyboardType = UIKeyboardTypeNumberPad;
    kkBadNumTextF.font = KKTitleFont14;
    kkBadNumTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    kkBadNumTextF.textColor = KKWhiteColor;
//    kkBadNumTextF.tintColor = KKWhiteColor;
    kkBadNumTextF.placeholder = @"填写个数";
    [kkBadNumTextF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    //
    UIView *kkRedBadMoneyNumV = [[UIView alloc]init];
    [self.kkContentView addSubview:kkRedBadMoneyNumV];
    self.kkRedBadMoneyNumV = kkRedBadMoneyNumV;
    kkRedBadMoneyNumV.backgroundColor = [UIColor whiteColor];

    
    UIImageView *kkBadNumMoneyLeftImgV = [[UIImageView alloc]init];
    self.kkBadNumMoneyLeftImgV = kkBadNumMoneyLeftImgV;
    [self.kkRedBadMoneyNumV addSubview:kkBadNumMoneyLeftImgV];
    kkBadNumMoneyLeftImgV.image = [UIImage imageNamed:@"KKSendRedBagView_lock"];

    UILabel *kkBadNumMoneyLeftLab = [[UILabel alloc]init];
    self.kkBadNumMoneyLeftLab = kkBadNumMoneyLeftLab;
    [self.kkRedBadMoneyNumV addSubview:kkBadNumMoneyLeftLab];
    kkBadNumMoneyLeftLab.text = @"总金额";
    kkBadNumMoneyLeftLab.textColor = [UIColor blackColor];
    kkBadNumMoneyLeftLab.font = KKTitleFont14;

    UILabel *kkBadNumMoneyAverageLeftLab = [[UILabel alloc]init];
    self.kkBadNumMoneyAverageLeftLab = kkBadNumMoneyAverageLeftLab;
    [self.kkRedBadMoneyNumV addSubview:kkBadNumMoneyAverageLeftLab];
    kkBadNumMoneyAverageLeftLab.text = @"单个金额";
    kkBadNumMoneyAverageLeftLab.textColor = [UIColor blackColor];
    kkBadNumMoneyAverageLeftLab.hidden = YES;
    kkBadNumMoneyAverageLeftLab.font = KKTitleFont14;

    UILabel *kkBadNumMoneyRLab = [[UILabel alloc]init];
    self.kkBadNumMoneyRLab = kkBadNumMoneyRLab;
    [self.kkRedBadMoneyNumV addSubview:kkBadNumMoneyRLab];
    kkBadNumMoneyRLab.text = @"币";
    kkBadNumMoneyRLab.textColor = [UIColor blackColor];
    kkBadNumMoneyRLab.font = KKTitleFont14;

    
    UITextField *kkBadNumMoneyTextF = [[UITextField alloc]init];
    self.kkBadNumMoneyTextF = kkBadNumMoneyTextF;
    [self.kkRedBadMoneyNumV addSubview:kkBadNumMoneyTextF];
//    kkBadNumTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;//文字居下
    kkBadNumMoneyTextF.textAlignment = NSTextAlignmentRight;

    kkBadNumMoneyTextF.tag = 130;
    kkBadNumMoneyTextF.keyboardType = UIKeyboardTypeNumberPad;
    kkBadNumTextF.font = KKTitleFont14;
    kkBadNumMoneyTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    kkBadNumTextF.textColor = KKWhiteColor;
//    kkBadNumTextF.tintColor = KKWhiteColor;
    kkBadNumMoneyTextF.placeholder = @"0";
    [kkBadNumMoneyTextF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    
    UIView *kkRedBadDescribeV = [[UIView alloc]init];
    [self.kkContentView addSubview:kkRedBadDescribeV];
    self.kkRedBadDescribeV = kkRedBadDescribeV;
    kkRedBadDescribeV.backgroundColor = [UIColor whiteColor];

    
    UITextField *kkDescribeTextF = [[UITextField alloc]init];
    self.kkDescribeTextF = kkDescribeTextF;
    [self.kkRedBadDescribeV addSubview:kkDescribeTextF];
    kkDescribeTextF.font = KKTitleFont14;
    kkDescribeTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    kkDescribeTextF.placeholder = @"恭喜发财,大吉大利";
    
    UILabel *kkTotalMoneyLab = [[UILabel alloc]init];
    self.kkTotalMoneyLab = kkTotalMoneyLab;
    [self.kkContentView addSubview:kkTotalMoneyLab];
    kkTotalMoneyLab.text = @"0";
    kkTotalMoneyLab.textColor = [UIColor blackColor];
    kkTotalMoneyLab.font = [UIFont systemFontOfSize:45];

    UIButton *kkSendRedBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkSendRedBagBtn = kkSendRedBagBtn;
    [self.kkContentView addSubview:kkSendRedBagBtn];
    [kkSendRedBagBtn addTarget:self action:@selector(kkSendRedBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkSendRedBagBtn setTitle:@"塞币进红包" forState:UIControlStateNormal];

    kkSendRedBagBtn.backgroundColor = [UIColor colorWithHexString:@"#E3BEB5"];
    
    UILabel *kkPromptLab = [[UILabel alloc]init];
    self.kkPromptLab = kkPromptLab;
    [self.kkContentView addSubview:kkPromptLab];
    kkPromptLab.text = @"未领取的红包，将于24小时后发起退款";
    kkPromptLab.textColor = [UIColor colorWithHexString:@"#666666"];
    kkPromptLab.font = [UIFont systemFontOfSize:12];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.kkGoBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kkStatusbarH);
        make.width.height.mas_equalTo(40);
    }];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(kkStatusbarH);
    }];
    [self.kkRedBagTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        if (self.kkBagType == 3) {
            make.top.mas_equalTo(self.kkGoBackBtn.mas_bottom).mas_offset(-(10+50+20));
        }else{
            make.top.mas_equalTo(self.kkGoBackBtn.mas_bottom).mas_offset(-10);
        }
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];

    [self.kkRedBadNumV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkRedBagTypeBtn.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(21);
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(50);
    }];

    [self.kkBadNumLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRedBadNumV);
        make.left.mas_equalTo(10);
    }];
    
    [self.kkBadNumRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRedBadNumV);
        make.right.mas_equalTo(-10);
    }];
    
    [self.kkBadNumTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkBadNumLeftLab);
        make.right.mas_equalTo(self.kkBadNumRLab.mas_left).mas_offset(-5);
        make.top.bottom.mas_equalTo(self.kkRedBadNumV);
    }];
    
    [self.kkRedBadMoneyNumV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkRedBadNumV.mas_bottom).mas_offset(18);
        make.left.mas_equalTo(21);
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(50);
    }];
    
    [self.kkBadNumMoneyLeftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.kkRedBadMoneyNumV);
        make.width.height.mas_equalTo(15);
    }];
    [self.kkBadNumMoneyLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkBadNumMoneyLeftImgV.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.kkBadNumMoneyLeftImgV);
    }];
    
    [self.kkBadNumMoneyAverageLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRedBadMoneyNumV);
        make.left.mas_equalTo(10);
    }];
    
    [self.kkBadNumMoneyRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRedBadMoneyNumV);
        make.right.mas_equalTo(-10);
    }];
    
    [self.kkBadNumMoneyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkBadNumMoneyLeftLab);
        make.right.mas_equalTo(self.kkBadNumMoneyRLab.mas_left).mas_offset(-5);
        make.top.bottom.mas_equalTo(self.kkRedBadMoneyNumV);
    }];

    
    [self.kkRedBadDescribeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkRedBadMoneyNumV.mas_bottom).mas_offset(18);
        make.left.mas_equalTo(21);
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(50);
    }];

    [self.kkDescribeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.kkRedBadDescribeV);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];

    [self.kkTotalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkRedBadDescribeV.mas_bottom).mas_offset(70);
        make.centerX.mas_equalTo(self.kkContentView);
    }];
    [self.kkSendRedBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTotalMoneyLab.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.kkTotalMoneyLab);
        make.width.mas_equalTo(161);
        make.height.mas_equalTo(41);
    }];
    [self.kkPromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(self.kkContentView);
    }];
    
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    if (textField.tag == self.kkBadNumTextF.tag ) {
        
        if (textField.text.length>5) {
           self.kkBadNumTextF.text = [textField.text substringToIndex:5];
        }
    }else if (textField.tag == self.kkBadNumMoneyTextF.tag){
        if (self.kkBagType ==2) {
            if (textField.text.length>8) {
               self.kkBadNumMoneyTextF.text = [textField.text substringToIndex:8];
            }
        }else{
            if (textField.text.length>5) {
               self.kkBadNumMoneyTextF.text = [textField.text substringToIndex:5];
            }
        }
    }

    if (textField.tag == self.kkBadNumTextF.tag || textField.tag == self.kkBadNumMoneyTextF.tag) {
        
        CGFloat oneNum = [self.kkBadNumTextF.text floatValue];
        CGFloat twoNum = [self.kkBadNumMoneyTextF.text floatValue];
        CGFloat totalNum = oneNum *twoNum;
        if (totalNum>0) {
            self.kkSendRedBagBtn.backgroundColor = [UIColor colorWithHexString:@"#E4643D"];
            self.kkSendRedBagBtn.userInteractionEnabled=YES;//交互
        }else{
            self.kkSendRedBagBtn.userInteractionEnabled=NO;//交互
            self.kkSendRedBagBtn.backgroundColor = [UIColor colorWithHexString:@"#E3BEB5"];
        }
        if (self.kkBagType ==2) {
            self.kkTotalMoneyLab.text = self.kkBadNumMoneyTextF.text;
        }else{
            self.kkTotalMoneyLab.text = [NSString stringWithFormat:@"%.f",totalNum];
        }
    }else{
        
    }
}


- (void)kkGoBackBtnClick
{
    [self removeFromSuperview];
}

- (void)kkRedBagTypeBtnClick
{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:@"拼手气红包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kkLockBagClick];
    }];
    [alertContro addAction:picAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"平均红包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kkAverageBagClick];
    }];
    [alertContro addAction:photoAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    if (self.kkPresentViewControllerBlock) {
        self.kkPresentViewControllerBlock(alertContro);
    }

}

- (void)kkSendRedBagBtnClick
{
    NSString *kkDescribe = @"";
    if (self.kkDescribeTextF.text.length) {
        kkDescribe = self.kkDescribeTextF.text;
    }else{
        kkDescribe = @"恭喜发财,大吉大利";
    }

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"hongbao_money"] = self.kkTotalMoneyLab.text;
    param[@"hongbao_nums"] = self.kkBadNumTextF.text;
    param[@"type"] =@(self.kkBagType);//1是普通红包,2是随机红包
    WeakSelf;
    [KKFunctionAPI kk_PostAddRedBagInfoWithparameters:param successBlock:^(id  _Nullable response) {
        if ([response[@"status"] intValue] == 1) {
            
            NSString *redBagID = response[@"hongbaoever_hongbaoid"];
            if (weakSelf.kkSendRedBagBlock) {
                weakSelf.kkSendRedBagBlock(redBagID, kkDescribe, self.kkTotalMoneyLab.text);
                [weakSelf kkDismiss];
            }
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];
}

- (void)kkSendMessage
{
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:data];
//    [[V2TIMManager sharedInstance] sendMessage:msg receiver:nil groupID:self.conversation.convId priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
//
//    } succ:^{
//        [weakSelf showWaitView:infoDic andType:type];
//    } fail:^(int code, NSString *desc) {
//        [MBProgressHUD showError:@"消息发送失败"];
//        [weakSelf sendMessageFaild:infoDic andType:type];
//    }];

}


- (void)kkLockBagClick
{
    self.kkBagType = 2;
    self.kkBadNumMoneyAverageLeftLab.hidden = YES;
    self.kkBadNumMoneyLeftImgV.hidden = NO;
    self.kkBadNumMoneyLeftLab.hidden = NO;
    
    self.kkBadNumTextF.text = @"";
    self.kkBadNumMoneyTextF.text = @"";
    self.kkBadNumTextF.placeholder = @"填写个数";
    self.kkBadNumMoneyTextF.placeholder = @"0";
    self.kkTotalMoneyLab.text = @"0";

}
 
- (void)kkAverageBagClick
{
    self.kkBagType = 1;
    self.kkBadNumMoneyLeftImgV.hidden = YES;
    self.kkBadNumMoneyLeftLab.hidden = YES;
    self.kkBadNumMoneyAverageLeftLab.hidden = NO;
    
    self.kkBadNumTextF.text = @"";
    self.kkBadNumMoneyTextF.text = @"";
    self.kkBadNumTextF.placeholder = @"填写个数";
    self.kkBadNumMoneyTextF.placeholder = @"0";
    self.kkTotalMoneyLab.text = @"0";

}
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.kkDescribeTextF resignFirstResponder];
    [self.kkBadNumTextF resignFirstResponder];
    [self.kkBadNumMoneyTextF resignFirstResponder];

}
@end
