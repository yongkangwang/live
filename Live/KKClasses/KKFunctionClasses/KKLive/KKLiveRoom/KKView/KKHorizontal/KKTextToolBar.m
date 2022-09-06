//
//  KKTextToolBar.m
//  yunbaolive
//
//  Created by Peter on 2020/10/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKTextToolBar.h"

#import "catSwitch.h"

@interface KKTextToolBar ()<UITextFieldDelegate,catSwitchDelegate>

@property(weak,nonatomic)UIView *kkTooBgv;

@property(weak,nonatomic)UIView *kkLineOne;
@property(weak,nonatomic)UIView *kkLineTwo;



@property(weak,nonatomic)UIImageView *kkUserOneBtn;
@property(weak,nonatomic)UIImageView *kkUserTwoBtn;
@property(weak,nonatomic)UIImageView *kkUserThreeBtn;
@property(weak,nonatomic)UIImageView *kkUserFourBtn;
@property(weak,nonatomic)UIImageView *kkUserSelectImgV;
@property(strong,nonatomic)NSDictionary *kkSelectUserDic;


@end

@implementation KKTextToolBar

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.kkIsHorizontal = NO;
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
    UIView *tooBgv = [[UIView alloc]init];
    tooBgv.backgroundColor = [UIColor whiteColor];
    tooBgv.alpha = 0.7;
    [self addSubview:tooBgv];
    self.kkTooBgv = tooBgv;
    
    catSwitch * kkCatSwitch = [[catSwitch alloc] init];
    kkCatSwitch.delegate = self;
    [self addSubview:kkCatSwitch];
    self.kkCatSwitch = kkCatSwitch;
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = RGB(176, 176, 176);
    line1.alpha = 0.5;
    [self addSubview:line1];
    self.kkLineOne = line1;
    
        //发送按钮
    UIButton *pushBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkMessagePushBTN = pushBTN;
    [self addSubview:pushBTN];

    [pushBTN setImage:[UIImage imageNamed:@"chat_send_gray"] forState:UIControlStateNormal];
    [pushBTN setImage:[UIImage imageNamed:@"chat_send_yellow"] forState:UIControlStateSelected];
    pushBTN.imageView.contentMode = UIViewContentModeScaleAspectFit;

    pushBTN.selected = NO;
    [pushBTN addTarget:self action:@selector(kkPushMessage) forControlEvents:UIControlEventTouchUpInside];

    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = line1.backgroundColor;
    line2.alpha = line1.alpha;
    [self addSubview:line2];
    self.kkLineTwo = line2;
    
    //输入框
   UITextField *keyField = [[UITextField alloc]init];
    self.kkTextField = keyField;
    [self addSubview:keyField];

    keyField.returnKeyType = UIReturnKeySend;
    keyField.delegate = self;
    keyField.textColor = [UIColor blackColor];
    keyField.borderStyle = UITextBorderStyleNone;
    keyField.leftViewMode = UITextFieldViewModeAlways;
    keyField.font = [UIFont systemFontOfSize:15];
    keyField.backgroundColor = [UIColor whiteColor];

    
    UIView *fieldLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    fieldLeft.backgroundColor = [UIColor whiteColor];
    keyField.leftView = fieldLeft;
    
    for (int i=0; i<4; i++) {

        UIImageView *kkimgV = [[UIImageView alloc]init];
        [self addSubview:kkimgV];
        kkimgV.image = [UIImage imageNamed:kkPlaceholderHeadIconImageStr];
        kkimgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPlayer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkUsetImgViewClick:)];
        [kkimgV addGestureRecognizer:tapPlayer];

        kkimgV.hidden = YES;
        kkimgV.tag = KKBaseTag + i;

        if (i==0) {
            self.kkUserOneBtn = kkimgV;
        }else if (i==1){
            self.kkUserTwoBtn = kkimgV;
        }else if (i==2){
            self.kkUserThreeBtn = kkimgV;
        }else if (i==3){
            self.kkUserFourBtn = kkimgV;
        }
    }

    UIImageView *kkUserSelectImgV = [[UIImageView alloc]init];
    [self addSubview:kkUserSelectImgV];
    self.kkUserSelectImgV = kkUserSelectImgV;
    kkUserSelectImgV.image = [UIImage imageNamed:@"KKGiftTopUserSelect_icon"];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.kkToolBarType ==1) {
        self.kkCatSwitch.hidden = YES;
        self.kkLineOne.hidden = YES;
        self.kkLineTwo.hidden = YES;
        self.kkMessagePushBTN.hidden = YES;
    }
    
    [self.kkTooBgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    if (self.kkIsHorizontal) {
        [self.kkCatSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6+kkStatusbarH);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(22);
        }];

    }else{
    [self.kkCatSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
    }];
    }
    if (self.kkIsHorizontal) {
        [self.kkMessagePushBTN mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10 - ShowDiff);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];

    }else{
    [self.kkMessagePushBTN mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    }
    [self.kkLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkCatSwitch);
        make.left.mas_equalTo(self.kkCatSwitch.mas_right).mas_offset(7);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];

    [self.kkLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkMessagePushBTN.mas_left).mas_offset(-7);
        make.centerY.mas_equalTo(self.kkMessagePushBTN);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];

    [self.kkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkLineTwo.mas_left).mas_offset(-7);
        make.centerY.mas_equalTo(self.kkMessagePushBTN);
        make.left.mas_equalTo(self.kkLineOne.mas_right).mas_offset(7);
        make.height.mas_equalTo(30);
    }];
    
    [self kkLayoutUserBtn];
    
}

- (void)kkLayoutUserBtn
{
    [self.kkUserOneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkTextField.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.kkTextField);
        make.height.width.mas_equalTo(30);
    }];
    [self.kkUserTwoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserOneBtn.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.kkUserOneBtn);
        make.height.width.mas_equalTo(30);
    }];

    [self.kkUserThreeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserTwoBtn.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.kkUserOneBtn);
        make.height.width.mas_equalTo(30);
    }];

    [self.kkUserFourBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkUserThreeBtn.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.kkUserOneBtn);
        make.height.width.mas_equalTo(30);
    }];

}

- (void)kkPushMessage
{
    if (self.kkMessagePushBtnClickBlock) {
        self.kkMessagePushBtnClickBlock(self.kkTextField);
    }
    if (self.kkPushMessageBtnClickBlock) {
        self.kkPushMessageBtnClickBlock(self.kkTextField, self.kkSelectUserDic);
    }
}

- (void)setKkIsHorizontal:(BOOL)kkIsHorizontal
{
    _kkIsHorizontal = kkIsHorizontal;
    [self layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self kkPushMessage];
    return YES;
}

//切换聊天和弹幕
-(void)switchState:(BOOL)state
{
    if(!state)
    {
        self.kkTextField.placeholder = @"说点什么";
    }
    else
    {
        self.kkTextField.placeholder = [NSString stringWithFormat:@"%@，%@%@/%@",YZMsg(@"开启大喇叭"),self.kkBarrageMoney,[common name_coin],YZMsg(@"条")];
    }
}


- (void)setKkUserInfoArr:(NSMutableArray *)kkUserInfoArr
{
    _kkUserInfoArr = kkUserInfoArr;
    
    for (int i=0; i<kkUserInfoArr.count; i++) {
        NSDictionary *kkdic = kkUserInfoArr[i];
        if (i==0) {
            self.kkUserOneBtn.hidden = NO;
            [self.kkUserOneBtn sd_setImageWithURL:[NSURL URLWithString:kkdic[@"avatar"]] placeholderImage:[UIImage imageNamed:kkPlaceholderChatHeadIconImageStr]];
        }else if (i==1){
            self.kkUserTwoBtn.hidden = NO;
            [self.kkUserTwoBtn sd_setImageWithURL:[NSURL URLWithString:kkdic[@"avatar"]] placeholderImage:[UIImage imageNamed:kkPlaceholderChatHeadIconImageStr]];
        }else if (i==2){
            self.kkUserThreeBtn.hidden = NO;
            [self.kkUserThreeBtn sd_setImageWithURL:[NSURL URLWithString:kkdic[@"avatar"]] placeholderImage:[UIImage imageNamed:kkPlaceholderChatHeadIconImageStr]];
        }else if (i==3){
            self.kkUserFourBtn.hidden = NO;
            [self.kkUserFourBtn sd_setImageWithURL:[NSURL URLWithString:kkdic[@"avatar"]] placeholderImage:[UIImage imageNamed:kkPlaceholderChatHeadIconImageStr]];
        }
    }
    
    [self.kkTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkLineTwo.mas_left).mas_offset(-110);
        make.centerY.mas_equalTo(self.kkMessagePushBTN);
        make.left.mas_equalTo(self.kkLineOne.mas_right).mas_offset(-30);
        make.height.mas_equalTo(30);
    }];

    [self kkLayoutUserBtn];
}

- (void)kkUsetImgViewClick:(UIPanGestureRecognizer *)pan
{
   UIView *videoV = pan.view;
    NSInteger index = videoV.tag - KKBaseTag;

    if (index<self.kkUserInfoArr.count) {
        self.kkSelectUserDic = self.kkUserInfoArr[index];
        [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"已选择了%@",self.kkSelectUserDic[@"user_nickname"]]];
    }
    self.kkUserSelectImgV.frame = CGRectMake(videoV.x-2, videoV.y-2, 34, 34);

}


@end
