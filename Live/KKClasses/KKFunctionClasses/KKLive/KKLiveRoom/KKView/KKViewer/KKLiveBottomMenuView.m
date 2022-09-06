//
//  KKLiveBottomMenuView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveBottomMenuView.h"

#import "TUnReadView.h"

#import "KKConversationListView.h"
#import "KKAlertH5WebView.h"
#import "KKViewerAnchorMoreFunctionView.h"

@interface KKLiveBottomMenuView ()

@property(weak,nonatomic)UIButton *kkChatBtn;
@property(weak,nonatomic)UIButton *kkConversationListBtn;
@property(weak,nonatomic)UIButton *kkAfficheBtn;
@property(weak,nonatomic)UIButton *kkTRTCMenuBtn;
@property(weak,nonatomic)UIButton *kkGiftBtn;

@property(weak,nonatomic)TUnReadView *kkUnReadV;//

@end

@implementation KKLiveBottomMenuView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        //添加子控件
        [self kkInitView];
        [kkNotifCenter addObserver:self selector:@selector(kkMessageUnReadV:) name:kkChatListUnreadNumNotifi object:nil];
    }
    return self;
}

- (void)kkInitView
{
    UIButton *kkChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkChatBtn = kkChatBtn;
    [self addSubview:kkChatBtn];
    [kkChatBtn setBackgroundImage:[UIImage imageNamed:@"KKLiveBottomMenuView_chat_icon"] forState:UIControlStateNormal];
    [kkChatBtn setTitle:@"撩一下..." forState:UIControlStateNormal];
    kkChatBtn.titleLabel.font = KKPhoenFont13;
    [kkChatBtn addTarget:self action:@selector(kkChatBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkConversationListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkConversationListBtn = kkConversationListBtn;
    [self addSubview:kkConversationListBtn];
    [kkConversationListBtn setBackgroundImage:[UIImage imageNamed:@"KKLiveBottomMenuView_ConversationList_icon"] forState:UIControlStateNormal];
    [kkConversationListBtn addTarget:self action:@selector(kkConversationListBtnClick) forControlEvents:UIControlEventTouchUpInside];

    TUnReadView *kkUnReadV = [[TUnReadView alloc] init];
    self.kkUnReadV = kkUnReadV;
    [self addSubview:kkUnReadV];
    kkUnReadV.backgroundColor = [UIColor redColor];
    
    UIButton *kkAfficheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkAfficheBtn = kkAfficheBtn;
    [self addSubview:kkAfficheBtn];
    [kkAfficheBtn setBackgroundImage:[UIImage imageNamed:@"KKLiveBottomMenuView_kkAffiche_icon"] forState:UIControlStateNormal];
    [kkAfficheBtn addTarget:self action:@selector(kkAfficheBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkTRTCMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkTRTCMenuBtn = kkTRTCMenuBtn;
    [self addSubview:kkTRTCMenuBtn];
    [kkTRTCMenuBtn setBackgroundImage:[UIImage imageNamed:@"KKLiveBottomMenuView_TRTCMenu_"] forState:UIControlStateNormal];
    [kkTRTCMenuBtn addTarget:self action:@selector(kkTRTCMenuBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkMoreBtn = kkMoreBtn;
    [self addSubview:kkMoreBtn];
    [kkMoreBtn setBackgroundImage:[UIImage imageNamed:@"KKLiveBottomMenuView_more_icon"] forState:UIControlStateNormal];
    [kkMoreBtn addTarget:self action:@selector(kkMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkGiftBtn = kkGiftBtn;
    [self addSubview:kkGiftBtn];
    [kkGiftBtn setBackgroundImage:[UIImage imageNamed:@"KKLive_SecondPage_gift_icon"] forState:UIControlStateNormal];
    [kkGiftBtn addTarget:self action:@selector(kkGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    [self.kkChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(70);

    }];

    [self.kkConversationListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkChatBtn);
        make.left.mas_equalTo(self.kkChatBtn.mas_right).mas_offset(14);
        make.height.mas_equalTo(self.kkChatBtn);
        make.width.mas_equalTo(32);
    }];

    self.kkUnReadV.frame = CGRectMake(CGRectGetMaxX(self.kkConversationListBtn.frame)-5, self.kkConversationListBtn.y - 10, self.kkUnReadV.width, self.kkUnReadV.height);
    
    [self.kkAfficheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkChatBtn);
        make.left.mas_equalTo(self.kkConversationListBtn.mas_right).mas_offset(14);
        make.height.width.mas_equalTo(self.kkConversationListBtn);
    }];
    
    [self.kkGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkChatBtn);
        make.right.mas_equalTo(-15);
        make.height.width.mas_equalTo(self.kkConversationListBtn);
    }];

    [self.kkMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkChatBtn);
        make.right.mas_equalTo(self.kkGiftBtn.mas_left).mas_offset(-14);
        make.height.width.mas_equalTo(self.kkConversationListBtn);
    }];
    [self.kkTRTCMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkChatBtn);
        make.right.mas_equalTo(self.kkMoreBtn.mas_left).mas_offset(-14);
        make.height.width.mas_equalTo(self.kkConversationListBtn);
    }];

    
}


- (void)kkMessageUnReadV:(NSNotification *)notif
{
    NSString *numstr = notif.object;
    NSInteger num = [numstr integerValue];
    [self.kkUnReadV setNum:num];
    [self layoutIfNeeded];
}

#pragma mark === 按钮点击事件
- (void)kkChatBtnClick
{
    if ([self.kkBottomMenuViewDelegate respondsToSelector:@selector(kkChatBtnClick)]) {
        [self.kkBottomMenuViewDelegate kkChatBtnClick];
    }
}
- (void)kkConversationListBtnClick
{
    KKConversationListView *view = [[KKConversationListView alloc]init];
    [view kkShowFromView:self];
}
- (void)kkAfficheBtnClick
{

    KKAlertH5WebView *kkBarrageWebView = [[KKAlertH5WebView alloc]init];
    [[self superview] addSubview:kkBarrageWebView];
    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=zsrenwu"];
    kkurl = [NSString kk_AppendH5URL:kkurl];
    kkBarrageWebView.kkUrls = kkurl;
    [kkBarrageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([self superview]);
    }];
    
}
- (void)kkTRTCMenuBtnClick
{
    if ([self.kkBottomMenuViewDelegate respondsToSelector:@selector(kkTRTCAudioEffectSettingClick)]) {
        [self.kkBottomMenuViewDelegate kkTRTCAudioEffectSettingClick];
    }
}
- (void)kkMoreBtnClick
{
    if ([self.kkBottomMenuViewDelegate respondsToSelector:@selector(kkMoreBtnClick)]) {
        [self.kkBottomMenuViewDelegate kkMoreBtnClick];
    }

//    KKViewerAnchorMoreFunctionView *kkview = [[KKViewerAnchorMoreFunctionView alloc]init];
//    kkview.kkRoomType = 1;
//    [[self superview] addSubview:kkview];
//    [kkview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo([self superview]);
//    }];
}

- (void)kkGiftBtnClick
{
    if ([self.kkBottomMenuViewDelegate respondsToSelector:@selector(kkGiftBtnClick)]) {
        [self.kkBottomMenuViewDelegate kkGiftBtnClick];
    }
}

- (void)setKkIsTRTC:(BOOL)kkIsTRTC
{
    _kkIsTRTC = kkIsTRTC;
    if (kkIsTRTC) {
        self.kkTRTCMenuBtn.hidden = NO;
    }else{
        self.kkTRTCMenuBtn.hidden = YES;
    }
}

@end
