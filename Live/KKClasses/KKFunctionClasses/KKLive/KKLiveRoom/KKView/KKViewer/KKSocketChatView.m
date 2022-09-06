//
//  KKSocketChatView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKSocketChatView.h"

#import "chatMsgCell.h"
#import "upmessageInfo.h"

#import "KKTRTCRoomCellModel.h"

#import "KKGameListPresentView.h"
#import "KKTRTCChatTableViewCell.h"

#import "KKGameRoomViewController.h"

@interface KKSocketChatView ()<UITableViewDelegate,UITableViewDataSource>


@property(weak,nonatomic)UIButton *kkCoverBtn;

@property(weak,nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *chatModels;//模型数组


//TRTC
@property(weak,nonatomic)UITableView *kkTRTCtableView;
@property(nonatomic,strong)NSMutableArray *kkTRTCCellArr;

@end

@implementation KKSocketChatView


- (void)setKkIsLive:(BOOL)kkIsLive
{
    _kkIsLive = kkIsLive;
    if (kkIsLive) {
        self.kkTRTCtableView.hidden = NO;
    }else{
        self.kkTRTCtableView.hidden = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        //添加子控件
        [self kkInitView];
    }
    return self;
}

- (void)kkInitView
{
    
    
    UIButton *kkCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkCoverBtn = kkCoverBtn;
    [self addSubview:kkCoverBtn];
    [kkCoverBtn addTarget:self action:@selector(kkCoverClick) forControlEvents:UIControlEventTouchUpInside];

    //直播间聊天室
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    [self addSubview:tableView];
    self.tableView.tag = KKBaseTag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.clipsToBounds = YES;
    
    
    //直播间聊天室
    UITableView *kkTRTCtableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.kkTRTCtableView = kkTRTCtableView;
    [self addSubview:kkTRTCtableView];
    self.kkTRTCtableView.tag = KKBaseTag +10;
    self.kkTRTCtableView.delegate = self;
    self.kkTRTCtableView.dataSource = self;
    self.kkTRTCtableView.backgroundColor = [UIColor clearColor];
    self.kkTRTCtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.kkTRTCtableView.showsVerticalScrollIndicator = NO;
    self.kkTRTCtableView.estimatedRowHeight = 25;
    self.kkTRTCtableView.clipsToBounds = YES;
    kkTRTCtableView.hidden = YES;
    
    [kkTRTCtableView registerClass:[KKTRTCChatTableViewCell class] forCellReuseIdentifier:@"KKTRTCChatTableViewCell"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    [self.kkCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(15);
//        make.width.mas_equalTo(KKScreenWidth/2);
        make.width.mas_equalTo(KKScreenWidth/1.5);
    }];
    
    [self.kkTRTCtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.tableView.mas_right).mas_offset(10);
//        make.height.mas_equalTo(self.tableView.height/1.5);
        make.bottom.mas_equalTo(-50);
    }];
}

- (void)kkAddSocketMessage:(NSDictionary *)dic
{
    chatModel *model = [chatModel modelWithDic:dic];
    [model setChatFrame:[_chatModels lastObject]];
    [self.chatModels addObject:model];

    if(self.chatModels.count>30)
    {
        [self.chatModels removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];

}

- (void)kkAddTRTCMessage:(KKTRTCRoomCellModel *)model
{
    KKTRTCRoomCellModel *mod = model;
    if (model.kkChangeCellType == 1) {
        for (KKTRTCRoomCellModel *kkModel in self.kkTRTCCellArr) {
            if ([kkModel.uid isEqualToString:model.uid]&&kkModel.kkType == model.kkType) {
                mod =kkModel;
            }
        }
        [self.kkTRTCCellArr removeObject:mod];
    }else{
        [self.kkTRTCCellArr addObject:model];
        [self.kkTRTCtableView reloadData];
        [self jumpLast:self.kkTRTCtableView];
    }
}

//聊天自动上滚
-(void)jumpLast:(UITableView *)tableView
{

    NSUInteger sectionCount = [tableView numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [tableView numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {sectionCount-1, 0};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

// 以下是 tableview的方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == KKBaseTag) {
        return UITableViewAutomaticDimension;
    }else{
        return 25;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == KKBaseTag) {
        return self.chatModels.count;
    }else{
        return self.kkTRTCCellArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == KKBaseTag) {

        chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCELL"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"chatMsgCell" owner:nil options:nil] lastObject];
        }
        cell.model = self.chatModels[indexPath.section];
        return cell;
    }else{
        KKTRTCChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKTRTCChatTableViewCell"];
        if (!cell) {
            cell = [[KKTRTCChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KKTRTCChatTableViewCell"];
        }
        //选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.kkTRTCCellArr[indexPath.section];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (tableView.tag == KKBaseTag) {
        chatModel *model = self.chatModels[indexPath.section];
        [self kkCoverClick];

        if ([model.msgtype isEqualToString:@"13"]) {//六道添加
            if ([model.jumptype isEqualToString:@"1"]) {
                KKGameRoomViewController *kkVC = [[KKGameRoomViewController alloc]init];
                kkVC.kkGameID = model.gameID;
                [[MXBADelegate sharedAppDelegate] pushViewController:kkVC animated:YES];
            }else{
                //弹窗
                WeakSelf;
                KKGameListPresentView *kkView = [[KKGameListPresentView alloc]init];
                kkView.kkShowType = 2;
                kkView.kkGameID = model.gameID;
                kkView.kkGameViewHeight = model.viewHeight;
                [kkView kkShow];
                kkView.kkGameRoomCloseBlock = ^(NSString * _Nonnull kkstr) {
    //                weakSelf.kkGameTransformV.hidden = YES;//六道2.0
                };
            }
            return;
        }
        NSString *IsUser = [NSString stringWithFormat:@"%@",model.userID];
        if (IsUser.length > 1) {
        NSDictionary *subdic = @{@"id":model.userID};
            [self GetInformessage:subdic];
        }
        
        if ([model.titleColor isEqual:@"SendMsgzjzb"]) {
    //        [self.kkBottomView kkChangeRowSelectBtn:@"3"];
        }
    
    }else{
        
//        [self.kkTRTCtableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.kkChatViewDelegate respondsToSelector:@selector(kkTRTCChatMessageClick:)]) {
            [self.kkChatViewDelegate kkTRTCChatMessageClick:self.kkTRTCCellArr[indexPath.section]];
            KKTRTCRoomCellModel *model =  self.kkTRTCCellArr[indexPath.section];
            model.kkChangeCellType = 2;
            [tableView reloadData];
        }
        
        
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _canScrollToBottom = NO;
        
}

#pragma mark =============  普通用户列表 头像 点击弹窗
-(void)GetInformessage:(NSDictionary *)subdic{
    if ([self.kkChatViewDelegate respondsToSelector:@selector(kkChatMessageClick:)]) {
        [self.kkChatViewDelegate kkChatMessageClick:subdic];
    }
}
- (void)kkCoverClick
{
    if ([self.kkChatViewDelegate respondsToSelector:@selector(kkChatCoverClick)]) {
        [self.kkChatViewDelegate kkChatCoverClick];
    }
}

- (void)kkResetData
{
    [self.chatModels removeAllObjects];
    [self.kkTRTCCellArr removeAllObjects];
    [self.tableView reloadData];
    [self.kkTRTCtableView reloadData];

}

- (NSMutableArray *)chatModels
{
    if (!_chatModels) {
        _chatModels = [NSMutableArray array];
    }
    return _chatModels;
}


- (NSMutableArray *)kkTRTCCellArr
{
    if (!_kkTRTCCellArr) {
        _kkTRTCCellArr = [NSMutableArray array];
    }
    return _kkTRTCCellArr;
}

@end
