//
//  KKUserInfoView.h
//  yunbaolive
//
//  Created by Peter on 2021/6/10.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol frontviewDelegate <NSObject>

    
//在线人数点击事件
- (void)kkOnLinePersonBtnClick;
//关闭直播间
- (void)kkRoomCloseBtnClick;
@optional;

//用户头像点击
-(void)GetInformessage:(NSDictionary *_Nullable)subdic;

//
-(void)zhezhaoBTNdelegate;

-(void)guanzhuZhuBo;//关注zhubo
-(void)zhubomessage;//点击主播弹窗

@end


NS_ASSUME_NONNULL_BEGIN

@interface KKUserInfoView : UIView

@property(nonatomic,assign)id<frontviewDelegate>frontviewDelegate;
//用户端
//主播信息
@property(nonatomic,strong)NSDictionary *zhuboDic;
//房间信息
@property(nonatomic,strong)NSDictionary *kkLiveDic;

//主播端
@property(nonatomic,strong)NSDictionary *kkLiveRoomDic;


-(void)changeState:(NSString *)texts;//改变映票适应坐标

-(void)kkChangeLookVideoPersionNum:(long long)persionNums;//改变直播间人数量

@property(strong,nonatomic)NSMutableArray *kkRoomPersonArr;
@property (nonatomic,assign) BOOL kkIsRefreshUserList;//刷新用户

//用户进入和离开房间
-(void)kkUserAccess:(NSDictionary *)dic;
-(void)kkUserLeave:(NSDictionary *)dic;

//
//是否关注主播
-(void)kkIsAttention:(NSString *)isAttention;


//是否是主播端，默认不是，
@property (nonatomic,assign) BOOL kkIsLive;

@end

NS_ASSUME_NONNULL_END


