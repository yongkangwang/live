//
//  KKTRTCVoiceView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCVoiceView.h"

#import "CGXPageCollectionWaterView.h"
#import "CGXPageCollectionHeaderModel.h"
//
#import "MJExtension.h"
//trtc
#import "TRTCVoiceRoom.h"
#import <TXLiteAVSDK_Professional/TRTCCloud.h>
#import "GenerateTestUserSig.h"


#import "KKTRTCRoomCellModel.h"
#import "KKTRTCRoomModel.h"

#import "KKTRTCVoiceCollectionViewCell.h"
#import "KKTRTCLiveInvitationView.h"



@interface KKTRTCVoiceView  ()<CGXPageCollectionUpdateViewDelegate,TRTCVoiceRoomDelegate>

@property(weak,nonatomic)UIImageView *kkBgImgV;
@property (nonatomic , weak) CGXPageCollectionWaterView *generalView;

@property(strong,nonatomic)NSMutableArray *kkCellModelArr;


/// 上麦信息记录(主播端),键是用户id ，值是信令ID
@property(strong,nonatomic)NSMutableDictionary *kkTakeSeatInvitationDic;
/// 主播抱麦信息记录
@property(strong,nonatomic)NSMutableDictionary *kkPickSeatInvitationDic;


/// 上麦信息记录(观众端),键是用户id，值麦位
@property(strong,nonatomic)NSMutableDictionary *kkInvitationSeatDic;
//只用于用户端
@property(strong,nonatomic)VoiceRoomInfo *kkRoomInfo;




@end

@implementation KKTRTCVoiceView

//退出TRTC
- (void)kkExitRoom
{
    [[TRTCVoiceRoom sharedInstance] exitRoom:^(int code, NSString * _Nonnull message) {
        if (code == -1) {
            //退出失败
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
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
    
    [self setupLayoutAndCollectionView];
    
}

/**
 * 创建布局和collectionView
 */
- (void)setupLayoutAndCollectionView
{
    CGXPageCollectionWaterView *generalView = [[CGXPageCollectionWaterView alloc]  init];
    self.generalView = generalView;
    [self addSubview:self.generalView];

   self.generalView.frame = CGRectMake(0, 0, KKScreenWidth, 100);
   self.generalView.viewDelegate = self;
   self.generalView.isShowDifferentColor = NO;
   self.generalView.isRoundEnabled = YES;
    self.generalView.collectionView.scrollEnabled = NO;
//   self.generalView.collectionView.contentInset = UIEdgeInsetsMake(KKNavH, 0, 15, 0);

    [self.generalView registerCell:[KKTRTCVoiceCollectionViewCell class] IsXib:NO];

    
    NSMutableArray *kkPrettyArr = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        KKTRTCRoomCellModel *model = [KKTRTCRoomCellModel baseModelWithDic:[NSDictionary dictionary]];
        [kkPrettyArr addObject:model];
    }
    
    self.kkCellModelArr = [self loadDealWithList:kkPrettyArr];
    [self.generalView updateDataArray:self.kkCellModelArr IsDownRefresh:YES Page:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    [self.kkBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.generalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    
}

- (void)setKkIsLive:(BOOL)kkIsLive
{
    _kkIsLive = kkIsLive;
    if (kkIsLive) {
        [self kkCreateLiveRoomTRTC];
    }else{
        [self kkCreateViewerTRTC];
    }
}


#pragma mark -- ==============以下是kk六道聊天室


- (void)kkCreateLiveRoomTRTC
{
    
    VoiceRoomParam *kkParam = [[VoiceRoomParam alloc] init];

//    kkParam.roomName = self.kkTRTCModel.kkRoomName;
    kkParam.roomName = @"六道";
    kkParam.coverUrl = [KKChatConfig getavatar];
    kkParam.needRequest = self.kkTRTCModel.kkNeedRequest;
    kkParam.seatCount = 8;
    int roomid = [[KKChatConfig getOwnID] intValue];
//    kkParam.needRequest = YES;
//     roomid = 27027;

    [[TRTCVoiceRoom sharedInstance] createRoom:roomid roomParam:kkParam callback:^(int code, NSString * _Nonnull message) {
//主动上麦
        if (code == 0) {
            [[TRTCVoiceRoom sharedInstance] enterSeat:0 callback:^(int code, NSString * _Nonnull message) {

            }];
        }else{
            [MBProgressHUD kkshowMessage:message];
        }
    }];
    [[TRTCVoiceRoom sharedInstance] setDelegate:self];
    
}

- (void)kkCreateViewerTRTC
{
    
    [[TRTCVoiceRoom sharedInstance] setDelegate:self];
    NSInteger roomID = [self.kkLiveInfo[@"uid"] integerValue];
//     roomID = 27027;

    [[TRTCVoiceRoom sharedInstance] enterRoom:roomID callback:^(int code, NSString * _Nonnull message) {
        if (code == 0) {
        }
    }];
 
}

- (void)setKkRoomSDKDic:(NSDictionary *)kkRoomSDKDic
{
    _kkRoomSDKDic = kkRoomSDKDic;

    [[TRTCVoiceRoom sharedInstance] login:[kkRoomSDKDic[@"shishivideoid"] intValue] userId:[KKChatConfig getOwnID] userSig:kkRoomSDKDic[@"spkeysing"] callback:^(int code, NSString * _Nonnull message) {
        
    }];

}


- (void)onError:(int)code message:(NSString *)message
{
    KKLog(@"trtcmessage:  %d   %@",code,message);
}

/// 房间信息变更回调
/// @param roomInfo 房间信息
- (void)onRoomInfoChange:(VoiceRoomInfo *)roomInfo
{
    self.kkRoomInfo = roomInfo;
    self.kkTRTCModel.kkNeedRequest = roomInfo.needRequest;
//    self.kkTRTCModel.kkRoomName = roomInfo.roomName;
    self.kkTRTCModel.kkRoomID = [NSString stringWithFormat:@"%zd",roomInfo.roomID];
    
}
/// 房间作为变更回调
/// @param seatInfolist 座位列表信息
- (void)onSeatInfoChange:(NSArray<VoiceRoomSeatInfo *> *)seatInfolist
{
    //用户和主播进房都会调用，在这里更新麦位视图

    for (int i=0; i<seatInfolist.count; i++) {
        VoiceRoomSeatInfo *info = seatInfolist[i];
        
        CGXPageCollectionBaseSectionModel *model = self.generalView.dataArray.lastObject;
        CGXPageCollectionBaseRowModel *rowModel =  model.rowArray[i];
        KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;
        cellModel.kkIsMute = info.mute;
        cellModel.status = info.status;
        if (info.status == 2) {
            cellModel.kkIsLock = YES;
        }else{
            cellModel.kkIsLock = NO;
        }
        if (!info.userId) {
            return;
        }
        WeakSelf;
        [[TRTCVoiceRoom sharedInstance] getUserInfoList:@[info.userId] callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomUserInfo *> * _Nonnull userInfos) {
            VoiceRoomUserInfo *kkinfo = userInfos.firstObject;
            KKLog(@"%zd",kkinfo.gender);
            cellModel.name = kkinfo.userName;
            cellModel.pictureUrl = kkinfo.userAvatar;
            cellModel.gender = kkinfo.gender;
            cellModel.level = kkinfo.level;
            
            [weakSelf.generalView.collectionView reloadData];
        }];

    }

}

/// 主播上麦回调
- (void)onAnchorEnterSeat:(NSInteger)index
                              user:(VoiceRoomUserInfo *)user
{
    [self kkOnSeatInfoChange:index infoType:4 status:NO andInfo:user];
    
    [self kkNewMessageType:1 index:index isClose:NO andInfo:user];
}
/// 主播下麦回调
- (void)onAnchorLeaveSeat:(NSInteger)index
                     user:(VoiceRoomUserInfo *)user
{
    [self kkOnSeatInfoChange:index infoType:3 status:NO andInfo:nil];
    [self kkNewMessageType:2 index:index isClose:NO andInfo:user];
}
/// 观众进房回调
- (void)onAudienceEnter:(VoiceRoomUserInfo *)userInfo
{
    if (self.kkIsLive) {
        //在这里主动给用户发送房间内视频信息，
        if ([userInfo.userId isEqualToString:self.kkLiveInfo[@"uid"]]) {
            return;
        }
        if (self.kkSendVideoInfoBlock) {
            self.kkSendVideoInfoBlock(userInfo.userId);
        }

    }
    
    [self kkNewMessageType:3 index:KKBaseTag isClose:NO andInfo:userInfo];
}
/// 观众退房回调
/// @param userInfo 观众信息
- (void)onAudienceExit:(VoiceRoomUserInfo *)userInfo
{
    [self kkNewMessageType:4 index:KKBaseTag isClose:NO andInfo:userInfo];
}
///// 文本消息接收回调
- (void)onRecvRoomTextMsg:(NSString *)message
                 userInfo:(VoiceRoomUserInfo *)userInfo
{
    
}
//自定义消息接收
- (void)onRecvRoomCustomMsg:(NSString *)cmd message:(NSString *)message userInfo:(VoiceRoomUserInfo *)userInfo
{
    //
    if (self.kkIsLive) {
        if ([cmd intValue] == KKIMCMD_USER_VIDEO_PLAY) {
            NSDictionary* dic = [message mj_JSONObject];
            NSDictionary *kkdic = [dic[@"message"] mj_JSONObject];

            KKTRTCRoomCellModel *model = [[KKTRTCRoomCellModel alloc] init];
            model.kkType = 9;
            model.uid = userInfo.userId;
            model.name = userInfo.userName;
            model.kkVideoName = kkdic[@"title"];
            model.kkVideoInfoDic = kkdic;
            if (self.kkNewTRTCMessageBlock) {
                self.kkNewTRTCMessageBlock(model);
            }
            
        }
        
    }else{
        //主播发给用户的自定义消息
        if ([cmd isEqualToString: [KKChatConfig getOwnID]]
            || [cmd intValue] == KKIMCMD_VIDEO_PLAY) {
            //播放的视频内容
            NSDictionary* dic = [message mj_JSONObject];
            NSDictionary *kkdic = [dic[@"message"] mj_JSONObject];
            if (self.kkVideoInfoBlock) {
                self.kkVideoInfoBlock(kkdic);
            }
        }else if([cmd intValue] == KKIMCMD_VIDEO_SYNCHRONOUS){//同步视频进度
            NSDictionary* dic = [message mj_JSONObject];
            NSString *progress = dic[@"message"];
            if (self.kkVideoProgressChangeBlock) {
                self.kkVideoProgressChangeBlock(progress);
            }
        }else if([cmd intValue] == KKIMCMD_ANCHOR_VIDEO_PLAY_PAUSE){
            
        }
        
    }

}
/// 邀请信息接收回调
/// @param identifier 目标用户ID
/// @param inviter 邀请者ID
/// @param cmd 信令
/// @param content 内容
- (void)onReceiveNewInvitation:(NSString *)identifier
                       inviter:(NSString *)inviter
                           cmd:(NSString *)cmd
                       content:(NSString *)content
{
    KKLog(@"%@-%@-%@-%@",identifier,inviter,cmd,content);
    
    WeakSelf;
    if (self.kkIsLive) {
        if ([cmd isEqualToString:@"1"]) {
            VoiceRoomUserInfo *info = [[VoiceRoomUserInfo alloc] init];
            [[TRTCVoiceRoom sharedInstance] getUserInfoList:@[inviter] callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomUserInfo *> * _Nonnull userInfos) {
                VoiceRoomUserInfo *kkinfo = userInfos.firstObject;
                KKLog(@"%zd",kkinfo.gender);
                info.userId = kkinfo.userId;
                info.userName = kkinfo.userName;
                [weakSelf kkNewMessageType:7 index:[content integerValue] isClose:NO andInfo:info];
            }];
            self.kkTakeSeatInvitationDic[inviter] = identifier;
        }else{
            
        }
    }else{
        if ([cmd isEqualToString:@"2"]) {
            //主播邀请用户回调，弹框提示是否接受
            NSString *message = [NSString stringWithFormat:@"主播邀请您上%zd号麦",[content integerValue]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
            //添加一个按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                [self kkOpenJurisdiction];
                
                [[TRTCVoiceRoom sharedInstance] rejectInvitation:identifier callback:^(int code, NSString * _Nonnull message) {
                    if (code == 0) {
                        
                    }else{
                        [MBProgressHUD kkshowMessage:message];
                    }

                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [[TRTCVoiceRoom sharedInstance] acceptInvitation:identifier callback:^(int code, NSString * _Nonnull message) {
                    if (code == 0) {
                    }else{
                        [MBProgressHUD kkshowMessage:message];
                    }
                }];

            }]];

            
            if (self.kkShowAlertMicrophoneBlock) {
                self.kkShowAlertMicrophoneBlock(alert);
            }
        }
        
    }
    
}


/// 邀请被接受回调
/// @param identifier 目标用户ID
/// @param invitee 邀请者ID
- (void)onInviteeAccepted:(NSString *)identifier
                  invitee:(NSString *)invitee
{
//
    
    if (self.kkIsLive) {

        KKTRTCRoomCellModel *model =  self.kkPickSeatInvitationDic[identifier];
        
        CGXPageCollectionBaseSectionModel *viewModel = self.generalView.dataArray.lastObject;
        CGXPageCollectionBaseRowModel *rowModel =  viewModel.rowArray[model.index];
        KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;
        if ([invitee isEqualToString:cellModel.uid]) {
            return;
        }
        if (cellModel.status == 1 || cellModel.status == 2 ) {
//            [MBProgressHUD kkshowMessage:@"该麦位已有人或锁麦"];
            return;
        }
        
        [[TRTCVoiceRoom sharedInstance] pickSeat:model.index userId:model.uid callback:^(int code, NSString * _Nonnull message) {
            if (code == 0) {//抱麦成功
                
            }else{
                [MBProgressHUD kkshowMessage:message];
            }
        }];
        
        [self.kkPickSeatInvitationDic removeObjectForKey:identifier];
        
    }else{
        //判断该麦位是否有人，没人就调用主动上麦

        CGXPageCollectionBaseSectionModel *model = self.generalView.dataArray.lastObject;
        CGXPageCollectionBaseRowModel *rowModel =  model.rowArray[[self.kkInvitationSeatDic[identifier] integerValue]];
        KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;
        if (cellModel.status == 0) {
            [[TRTCVoiceRoom sharedInstance] enterSeat:[self.kkInvitationSeatDic[identifier] integerValue] callback:^(int code, NSString * _Nonnull message) {
                if (code == 0) {
                    [MBProgressHUD kkshowMessage:@"上麦成功"];
                }else{
                    [MBProgressHUD kkshowMessage:message];
                }
            }];//主动上麦
        }else if (cellModel.status == 1){
            [MBProgressHUD kkshowMessage:@"当前麦位已经有人"];
        }else if(cellModel.status == 2){
            [MBProgressHUD kkshowMessage:@"当前麦位已被锁麦"];

        }
        [self.kkInvitationSeatDic removeObjectForKey:identifier];
        
    }

}

/// 邀请被拒绝回调
/// @param identifier 目标用户ID
/// @param invitee 邀请者ID
- (void)onInviteeRejected:(NSString *)identifier
                  invitee:(NSString *)invitee
{

    if (self.kkIsLive) {
        KKTRTCRoomCellModel *model =  self.kkPickSeatInvitationDic[identifier];
        VoiceRoomUserInfo *user = [[VoiceRoomUserInfo alloc] init];
        user.userId = model.uid;
        user.userName = model.name;
        [self kkNewMessageType:8 index:model.index isClose:NO andInfo:user];
    }
    
}

/// 邀请被取消回调
/// @param identifier 目标用户ID
/// @param invitee 邀请者ID
- (void)onInvitationCancelled:(NSString *)identifier
                      invitee:(NSString *)invitee
{
    
}

/// 座位静音状态回调
/// @param index 座位号
/// @param isMute 静音状态
- (void)onSeatMute:(NSInteger)index isMute:(BOOL)isMute
{
    [self kkOnSeatInfoChange:index infoType:2 status:isMute andInfo:nil];
    [self kkNewMessageType:5 index:index isClose:isMute andInfo:nil];
}

/// 座位关闭回调
/// @param index 座位号
/// @param isClose 是否关闭
- (void)onSeatClose:(NSInteger)index isClose:(BOOL)isClose
{
    [self kkOnSeatInfoChange:index infoType:1 status:isClose andInfo:nil];
    [self kkNewMessageType:6 index:index isClose:isClose andInfo:nil];

}


#pragma mark -- ==============以上是kk六道聊天室

//发送自定义消息
-(void)kkSendRoomCustomMsg:(NSMutableDictionary *)dic
{
   NSString *kkstr = [dic mj_JSONString];
    [[TRTCVoiceRoom sharedInstance] sendRoomCustomMsg:[NSString stringWithFormat:@"%d",KKIMCMD_USER_VIDEO_PLAY] message:kkstr callback:^(int code, NSString * _Nonnull message) {
        if (code == 0) {
            [MBProgressHUD kkshowMessage:@"消息已发送给主播"];
        }else{
            [MBProgressHUD kkshowMessage:message];
        }
    }];
}
#pragma mark === 发送自定义消息
//主播同步用户视频
-(void)kkSendVideoCustomMsg:(NSMutableDictionary *)dic andMsgUID:(NSString *)uid
{
    if (!dic[@"url"]) {
        return;
    }
    NSString *kkstr = [dic mj_JSONString];
    
    if ([uid intValue] == KKIMCMD_VIDEO_SYNCHRONOUS) {
        kkstr = dic[@"progress"];
    }
    
     [[TRTCVoiceRoom sharedInstance] sendRoomCustomMsg:uid message:kkstr callback:^(int code, NSString * _Nonnull message) {
         if (code == 0) {
//             [MBProgressHUD kkshowMessage:@"消息已发送给主播"];
         }else{
             [MBProgressHUD kkshowMessage:message];
         }
     }];

}


- (void)kkTRTCChatMessageClick:(KKTRTCRoomCellModel *)model
{
    model.kkChangeCellType = 1;
    if (model.kkType == 7) {
//        CGXPageCollectionBaseSectionModel *viewModel = self.generalView.dataArray.lastObject;
//        CGXPageCollectionBaseRowModel *rowModel =  viewModel.rowArray[model.index];
//        KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;
//        if (cellModel.status == 1 || cellModel.status == 2 ) {
//            [MBProgressHUD kkshowMessage:@"该麦位已有人或锁麦"];
//            if (self.kkTakeSeatInvitationDic[model.uid]) {
//                [self.kkInvitationSeatDic removeObjectForKey:model.uid];
//            }
//        }
        if (self.kkTakeSeatInvitationDic[model.uid] == nil) {
            [MBProgressHUD kkshowMessage:@"该请求已过期"];
            return;
        }
        //接收邀请
        [[TRTCVoiceRoom sharedInstance] acceptInvitation:self.kkTakeSeatInvitationDic[model.uid] callback:^(int code, NSString * _Nonnull message) {
            if (code == 0) {
            //改变聊天消息内容，
                if (self.kkNewTRTCMessageBlock) {
                    self.kkNewTRTCMessageBlock(model);
                }
            }else{
                [MBProgressHUD kkshowMessage:message];
            }
        }];
    }
}

- (void)kkNewMessageType:(int)type index:(NSInteger)index isClose:(BOOL)close andInfo:(VoiceRoomUserInfo *)user
{
    KKTRTCRoomCellModel *model = [[KKTRTCRoomCellModel alloc] init];
    model.kkType = type;
    model.index = index;
    if (type != 5 || type != 6) {
        model.uid = user.userId;
        model.name = user.userName;
    }
    if (type == 5) {
        model.kkIsMute = close;
    }else if (type == 6){
        model.kkIsLock = close;
    }
    if (self.kkNewTRTCMessageBlock) {
        self.kkNewTRTCMessageBlock(model);
    }
}

//type 1 座位锁定，2座位静音，3下麦,4上麦
- (void)kkOnSeatInfoChange:(NSInteger)index infoType:(int)type status:(BOOL)status andInfo:(VoiceRoomUserInfo *)user
{
    CGXPageCollectionBaseSectionModel *model = self.generalView.dataArray.lastObject;
    CGXPageCollectionBaseRowModel *rowModel =  model.rowArray[index];
    KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;
    WeakSelf;
    if (type == 1) {
        cellModel.kkIsLock = status;
    }else if (type == 2){
        cellModel.kkIsMute = status;
    }else if (type == 3){
        cellModel.uid = @"";
        cellModel.name = @"";
        cellModel.pictureUrl = @"";
    }else if (type == 4){
        [[TRTCVoiceRoom sharedInstance] getUserInfoList:@[user.userId] callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomUserInfo *> * _Nonnull userInfos) {
                VoiceRoomUserInfo *kkinfo = userInfos.firstObject;
                KKLog(@"%zd",kkinfo.gender);
                cellModel.uid = kkinfo.userId;
                cellModel.name = kkinfo.userName;
                cellModel.pictureUrl = kkinfo.userAvatar;
                cellModel.gender = kkinfo.gender;
                cellModel.level = kkinfo.level;
                [weakSelf.generalView.collectionView reloadData];
            }];
    }
    [self.generalView.collectionView reloadData];

}

- (void)gx_PageCollectionBaseView:(CGXPageCollectionBaseView *)baseView DidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"点击了分组%zd,行%zd",indexPath.section,indexPath.row);
    CGXPageCollectionBaseSectionModel *model = self.generalView.dataArray.lastObject;
    CGXPageCollectionBaseRowModel *rowModel =  model.rowArray[indexPath.row];
    KKTRTCRoomCellModel *cellModel =  rowModel.dataModel;


    if (self.kkIsLive) {
        //主播
        if (indexPath.row == 0) {
            return;
        }else{
            //主播点击其他麦序
            if (cellModel.status == 1) {
                //麦上有人提示禁言或下麦
                if (cellModel.kkIsMute) {
                    [self kkShowAlertIndex:indexPath.row andType:6];
                }else{
                    [self kkShowAlertIndex:indexPath.row andType:1];
                }
            }else if(cellModel.status == 2){
                [self kkShowAlertIndex:indexPath.row andType:5];
            }else if (cellModel.status == 0){
            //拉人上麦
                [self kkShowAlertIndex:indexPath.row andType:2];
            }
        }
    }else{
        //用户
        if (cellModel.status == 1) {
            if ([cellModel.uid isEqualToString:[KKChatConfig getOwnID]]) {
                //用户点击麦上的自己，弹出下麦选择
                [self kkShowAlertIndex:indexPath.row andType:3];
            }
        }else if(cellModel.status == 2){
            [MBProgressHUD kkshowMessage:@"麦位已锁定，无法申请上麦"];
        }else if (cellModel.status == 0){
            //用户上麦选择
                [self kkShowAlertIndex:indexPath.row andType:4];
        }
    }

}

- (void)kkShowAlertIndex:(NSInteger)index andType:(int)type
{

    NSString *oneTitle = @"";
    NSString *twoTitle = @"";
//    type 1主播闭麦下麦 ，2主播封麦邀麦， 3下麦 4上麦 5解禁麦位  6，声音解麦
    int oneActionType = 0;
    int twoActionType = 0;

    switch (type) {
        case 1:
            oneTitle = @"对Ta禁言";
            twoTitle = @"请Ta下麦";
            oneActionType = 1;
            twoActionType = 1;
            break;
        case 2:
            oneTitle = @"邀人上麦";
            twoTitle = @"封禁麦位";
            oneActionType = 2;
            twoActionType = 2;

            break;
        case 3:
            oneTitle = @"下麦";
            oneActionType = 3;

            break;
        case 4:
            oneTitle = @"申请上麦";
            oneActionType = 4;

            break;
        case 5:
            oneTitle = @"解禁麦位";
            oneActionType = 5;

            break;
        case 6:
            oneTitle = @"对Ta解言";
            twoTitle = @"请Ta下麦";
            oneActionType = 6;
            twoActionType = 1;
            break;

        default:
            break;
    }
    
    //创建UIAlertController 设置标题，信息，样式
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

    //创建UIAlertAction对象，设置标题并添加到UIAlertController上
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *oneAction = [UIAlertAction actionWithTitle:oneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kkAlertOneAction:index andType:oneActionType];
    }];
    UIAlertAction *twoAction = [UIAlertAction actionWithTitle:twoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kkAlertTwoAction:index andType:twoActionType];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:oneAction];
    if (type == 1 || type == 2) {
        [alertController addAction:twoAction];
    }

    //展现UIAlertController
    if (self.kkShowAlertMicrophoneBlock) {
        self.kkShowAlertMicrophoneBlock(alertController);
    }

}

//index麦位
- (void)kkAlertOneAction:(NSInteger)index andType:(int)type
{
    //type 1对Ta禁言,2邀人上麦,3主动下麦,4申请上麦，5解禁麦位，6解言
    if (type == 1) {
        [[TRTCVoiceRoom sharedInstance] muteSeat:index isMute:YES callback:nil];
    }else if (type == 2){
                
        KKTRTCLiveInvitationView *kkvc = [[KKTRTCLiveInvitationView alloc]init];
        kkvc.kkRoomID = self.kkLiveInfo[@"uid"];

        kkvc.kkCellDidSelectClickBlock = ^(KKTRTCRoomCellModel * _Nonnull model) {
//            @"632397"
         NSString *InvitationID =  [[TRTCVoiceRoom sharedInstance] sendInvitation:@"2" userId:model.uid content:[NSString stringWithFormat:@"%zd",index] callback:^(int code, NSString * _Nonnull message) {
                if (code == 0) {
                    [MBProgressHUD kkshowMessage:@"邀请已发出，等待用户处理"];
                }else{
                    [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"邀请失败%@",message]];
                }

            }];
            model.index = index;
            //在这里回调被邀请者的id和麦位
            self.kkPickSeatInvitationDic[InvitationID] = model;
        };
        [kkvc kkShow];
        
    }else if (type == 3){
        [[TRTCVoiceRoom sharedInstance] leaveSeat:nil];
    }else if (type == 4){
        if (self.kkTRTCModel.kkNeedRequest) {
            
            NSString * userid = [NSString stringWithFormat:@"%zd",self.kkRoomInfo.roomID];
            //申请上麦
           NSString *invite = [[TRTCVoiceRoom sharedInstance] sendInvitation:@"1" userId:userid content:[NSString stringWithFormat:@"%zd",index] callback:^(int code, NSString * _Nonnull message) {
                if (code == 0) {
                    [MBProgressHUD kkshowMessage:@"申请已发出，等待主播处理"];
                }else{
                    [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"申请失败%@",message]];
                }
            }];
            self.kkInvitationSeatDic[invite] = [NSString stringWithFormat:@"%zd",index];
            
        }else{
            [[TRTCVoiceRoom sharedInstance] enterSeat:index callback:nil];//主动上麦
        }
    }else if (type == 5){
        [[TRTCVoiceRoom sharedInstance] closeSeat:index isClose:NO callback:nil];
    }else if (type == 6){
        [[TRTCVoiceRoom sharedInstance] muteSeat:index isMute:NO callback:nil];
    }
}
- (void)kkAlertTwoAction:(NSInteger)index andType:(int)type
{
    //type 1请Ta下麦,2封禁麦位
    if (type == 1) {
        [[TRTCVoiceRoom sharedInstance] kickSeat:index callback:nil];
    }else if (type == 2){
        [[TRTCVoiceRoom sharedInstance] closeSeat:index isClose:YES callback:nil];
    }
}



/*显示头分区*/
/*点击头分区*/
- (void)gx_PageCollectionBaseView:(
                                   
                                   CGXPageCollectionBaseView *)baseView TapHeaderViewAtIndex:(NSInteger)section
{

}
/* 展示cell 处理数据 */
- (void)gx_PageCollectionBaseView:(CGXPageCollectionBaseView *)baseView Cell:(UICollectionViewCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

}




//处理数据源
- (NSMutableArray<CGXPageCollectionWaterSectionModel *> *)loadDealWithList:(NSMutableArray *)kkRowArr
{
    NSMutableArray *dateAry = [NSMutableArray array];
    int x = 1;//分多少组
    for (int i = 0; i<x; i++) {
        CGXPageCollectionWaterSectionModel *sectionModel = [[CGXPageCollectionWaterSectionModel alloc] init];
        
        sectionModel.insets = UIEdgeInsetsMake(2,2,2,2);
        sectionModel.minimumLineSpacing = 8;//排
        sectionModel.minimumInteritemSpacing = 40;//列
                //collectionview 边距
        sectionModel.borderEdgeInserts = UIEdgeInsetsMake(15, 15, 7, 15);

        NSMutableArray *itemArr = [NSMutableArray array];
        
        UIColor*randColor = [UIColor clearColor];

        sectionModel.row = 4;
        for (int j = 0; j<kkRowArr.count; j++) {
            CGXPageCollectionWaterRowModel *item = [[CGXPageCollectionWaterRowModel alloc] initWithCelllass:[KKTRTCVoiceCollectionViewCell class] IsXib:NO];
            item.dataModel= kkRowArr[j];
            item.cellHeight = 70;
            item.cellColor =  randColor;
            [itemArr addObject:item];
        }
            
        sectionModel.rowArray = [NSMutableArray arrayWithArray:itemArr];
        [dateAry addObject:sectionModel];
    }
    return dateAry;
}



#pragma mark === 懒加载


- (NSMutableArray *)kkCellModelArr
{
    if (!_kkCellModelArr) {
        _kkCellModelArr = [NSMutableArray array];
    }
    return _kkCellModelArr;
}
- (VoiceRoomInfo *)kkRoomInfo
{
    if (!_kkRoomInfo) {
        _kkRoomInfo = [[VoiceRoomInfo alloc]init];
    }
    return _kkRoomInfo;
}

- (KKTRTCRoomModel *)kkTRTCModel
{
    if (!_kkTRTCModel) {
        _kkTRTCModel = [[KKTRTCRoomModel alloc]init];
    }
    return _kkTRTCModel;
}

- (NSMutableDictionary *)kkTakeSeatInvitationDic
{
    if (!_kkTakeSeatInvitationDic) {
        _kkTakeSeatInvitationDic = [NSMutableDictionary dictionary];
    }
    return _kkTakeSeatInvitationDic;
}


- (NSMutableDictionary *)kkInvitationSeatDic
{
    if (!_kkInvitationSeatDic) {
        _kkInvitationSeatDic = [NSMutableDictionary dictionary];
    }
    return _kkInvitationSeatDic;
}

- (NSMutableDictionary *)kkPickSeatInvitationDic
{
    if (!_kkPickSeatInvitationDic) {
        _kkPickSeatInvitationDic = [NSMutableDictionary dictionary];
    }
    return _kkPickSeatInvitationDic;
}

- (NSMutableDictionary *)kkVideoInfoDic
{
    if (!_kkVideoInfoDic) {
        _kkVideoInfoDic = [NSMutableDictionary dictionary];
    }
    return _kkVideoInfoDic;

}

@end
