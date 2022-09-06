//
//  KKLiveSocketInfoModel.m
//  yunbaolive
//
//  Created by Peter on 2021/4/1.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveSocketInfoModel.h"

#import "LMJHorizontalScrollText.h"

@interface KKLiveSocketInfoModel ()<socketLiveDelegate>

//用户类型
@property (nonatomic,copy) NSString * usertype;
@property(nonatomic,copy)NSString *danmuprice;//弹幕价格

@property (nonatomic,assign) long long userCount;//用户数量
@property (nonatomic,copy) NSString * votesTatal;//魅力值
//@property (nonatomic,assign) int userlist_time;//定时刷新用户列表时间


@property(strong,nonatomic)NSDictionary *guardInfo;
@property(nonatomic,strong)NSMutableArray *listArray;


@property(weak,nonatomic) UIView *liansongliwubottomview;

@property(strong,nonatomic)NSMutableArray *kkLotteryInfoArr;

//点亮星星
@property(weak,nonatomic)UIImageView *starImage;
@property(strong,nonatomic)NSNumber *heartNum;
@property (nonatomic,assign) int starisok;



@end

@implementation KKLiveSocketInfoModel


- (void)kkStarMove
{
    [self staredMove];
}


- (void)kkLoadLiveViewerInfo:(NSDictionary *)liveInfo
{
    self.kkLiveInfo = liveInfo;

    [self kkInitBuild];
}

- (void)kkInitBuild
{
    self.starisok = 0;
    self.userCount = 0;
    self.heartNum = @1;
    self.listArray = [NSMutableArray array];

    [self getNodeJSInfo];
}
#pragma mark ====== 以下socket

//获取进入直播间所需要的所有信息全都在这个enterroom这个接口返回
//初始化nodejs信息,用户信息都在这里面
-(void)getNodeJSInfo
{
    NSString *socketUrl = [self.kkLiveInfo valueForKey:@"chatserver"];
//    _danmuPrice = [_roomDic valueForKey:@"barrage_fee"];
//    [self onStream:nil];

    self.kkSocketLive = [[socketLive alloc]init];
    self.kkSocketLive.delegate = self;
    self.kkSocketLive.zhuboDic = self.kkLiveInfo;
    NSString *shut_time = [NSString stringWithFormat:@"%@",[self.kkLiveInfo valueForKey:@"shut_time"]];//禁言时间

    [self.kkSocketLive getshut_time:shut_time];//获取禁言时间
    [self.kkSocketLive addNodeListen:socketUrl andTimeString:[self.kkLiveInfo valueForKey:@"stream"]];
}


#pragma mark ==== socket delegate

- (void)loginOnOtherDevice{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"当前账号已在其他设备登录") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self roomCloseByAdmin];
    }]];
//    [self presentViewController:alert animated:YES completion:nil];
    [[MXBADelegate sharedAppDelegate] presentViewController:alert animated:YES completion:nil];

}

////超管禁用直播
-(void)superStopRoom:(NSString *)state{
    [self roomCloseByAdmin];
}
//房间被管理员关闭
-(void)roomCloseByAdmin
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkRoomCloseByAdmin)]) {
        [self.kkSocketDelegate kkRoomCloseByAdmin];
    }
}


#pragma mark ================ 发红包 ===============
- (void)showRedbag:(NSDictionary *)dic
{
//    redBagBtn.hidden = NO;

    NSString *uname;
    if ([minstr([dic valueForKey:@"uid"]) isEqual:minstr([self.kkLiveInfo valueForKey:@"uid"])]) {
        uname = YZMsg(@"主播");
    }else{
        uname = minstr([dic valueForKey:@"uname"]);
    }
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",minstr([dic valueForKey:@"ct"]),@"contentChat",levell,@"levelI",ID,@"id",@"redbag",@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    
    [self kkSocketMessage:chat];
    
}

//本直播间轮盘中奖，不显示到其他直播间
-(void)kkCurrentLotteryInfo:(NSDictionary *)msg
{
    NSString *  titleColor = @"SendMsgzjzb";

    NSString *ct = [msg valueForKey:@"ctTxt"];
    NSString *uname = @"";
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];

    [self kkSocketMessage:chat];
}

//监听文字消息
-(void)sendMessage:(NSDictionary *)chats
{
    [self kkSocketMessage:chats];
}

- (void)kkSocketMessage:(NSDictionary *)chat
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkSocketMessageSuccess:)]) {
        [self.kkSocketDelegate kkSocketMessageSuccess:chat];
    }
}
//直播间第一次进入的广播
-(void)socketSystem:(NSString *)ct
{
    NSString *titleColor = @"firstlogin";
    NSString *uname = YZMsg(@"直播间消息");
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];

    if ([self.kkSocketDelegate respondsToSelector:@selector(kkSocketMessageSuccess:)]) {
        [self.kkSocketDelegate kkSocketMessageSuccess:chat];
    }
}

-(void)socketUserLive:(NSString *)ID and:(NSDictionary *)msg
{//用户离开
    self.userCount -= 1;
    [self ChangeLookLivePersion:msg andPersionCount:self.userCount];
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkUserDisconnect:)]) {
        [self.kkSocketDelegate kkUserDisconnect:msg];
    }
}
//********************************用户进入房间动画***********
-(void)socketUserLogin:(NSString *)ID andDic:(NSDictionary *)dic
//-(void)UserAccess:(NSDictionary *)msg{
{
    //用户进入
    self.userCount += 1;
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkUserComeIn:)]) {
        [self.kkSocketDelegate kkUserComeIn:dic];
    }

    NSString *car_id = minstr([[dic valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
//        viplogin *vipanimation;//坐骑进场动画 去掉了，2.1六道
    }
    [self ChangeLookLivePersion:dic andPersionCount:self.userCount];
}

//kk六道更新右上角直播间人数
- (void)ChangeLookLivePersion:(NSDictionary *)dic andPersionCount:(long long)count
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkChangeLookLivePersion:andPersionCount:)]) {
        [self.kkSocketDelegate kkChangeLookLivePersion:dic andPersionCount:count];
    }
}

//全局的直播间中奖
- (void)kkLotteryInfo:(NSDictionary *)msg
{
    [self.kkLotteryInfoArr addObject:msg];
    if (self.kkLotteryInfoArr.count<=1) {
        [self kkLotteryAnimation];
    }
}
//中奖弹框动画
- (void)kkLotteryAnimation
{
    if (self.kkLotteryInfoArr.count<=0) {
        return;
    }
    NSDictionary *msg = self.kkLotteryInfoArr.firstObject;
        NSDictionary *kkdic =msg[@"ct"];
        
        LMJHorizontalScrollText * kkScrollText = [[LMJHorizontalScrollText alloc] initWithFrame: CGRectMake(0, 100, KKScreenWidth, 42)];
         kkScrollText.layer.cornerRadius = 3;
        //这个文字宽度要大于屏幕
    //    NSString *kkMsg = [NSString stringWithFormat:@"   %@在轮盘游戏中,获得[%@],前往直播间     ",kkdic[@"name"],kkdic[@"giftname"]];
      NSString *kkMsg = [NSString stringWithFormat:@"    %@在轮盘游戏中, 获得【%@】, 前往直播间  ",kkdic[@"name"],kkdic[@"giftname"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:kkMsg];
        
        NSRange range2 = [[str string] rangeOfString:kkdic[@"name"]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EEEB12"] range:range2];

        NSString *kkgiftName = [NSString stringWithFormat:@"【%@】",kkdic[@"giftname"]];
        NSRange range3 = [[str string] rangeOfString:kkgiftName];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2C12EE"] range:range3];
        
        NSRange range4 = [[str string] rangeOfString:@"前往直播间"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00F0FF"] range:range4];
        
        kkScrollText.textColor          = KKWhiteColor;
         kkScrollText.text               = kkMsg;
         kkScrollText.kkAttributedStr = str;
         kkScrollText.textFont           = kkFontWithName(@"PingFang-SC-Medium", 15);
         kkScrollText.speed              = 0.015;//数值越小，速度越快
         kkScrollText.moveMode           = KKTextScrollOutsideWandering;
         kkScrollText.moveDirection = LMJTextScrollMoveLeft;
         kkScrollText.isStopScroll = NO;
//         [self.view addSubview:kkScrollText];
    //六道2.0修改
    [[UIApplication sharedApplication].keyWindow addSubview:kkScrollText];
         [UIView animateWithDuration:2.0 animations:^{
             kkScrollText.kkBgImgV.alpha = 0.7;
         } completion:^(BOOL finished) {
             [kkScrollText move];
         }];
    
    WeakSelf;
    kkScrollText.KKScrollTextBlock = ^(LMJHorizontalScrollText * _Nonnull view) {
        [view removeFromSuperview];
        [weakSelf.kkLotteryInfoArr removeObjectAtIndex:0];
        [weakSelf kkLotteryAnimation];
    };

    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkGoToLiveRoom)];
    [kkScrollText addGestureRecognizer:tapges];

}
- (void)kkGoToLiveRoom
{

}
//僵尸粉
-(void)getZombieList:(NSArray *)array{
    //六道Peter
    self.userCount += array.count;
    //kk六道更新直播间人数
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAddZombieByArray:)]) {
        [self.kkSocketDelegate kkAddZombieByArray:array];
    }
    [self ChangeLookLivePersion:nil andPersionCount:self.userCount];

}


#pragma mark ====弹幕
//弹幕
-(void)sendBarrage:(NSDictionary *)msg
{
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
//    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];

//    if ([self.kkSocketDelegate respondsToSelector:@selector(kksendBarrage:)]) {
//        [self.kkSocketDelegate kksendBarrage:userinfo];
//    }
}
- (void)sendDanMu:(NSDictionary *)dic
{
    NSString *text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [dic valueForKey:@"uname"];
    NSString *icon = [dic valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    if ([self.kkSocketDelegate respondsToSelector:@selector(kksendBarrage:)]) {
        [self.kkSocketDelegate kksendBarrage:userinfo];
    }
}

//点亮,飘心动画
-(void)socketLight
{
    [self staredMove];
}

#pragma mark -- ===============点亮星星心心动画
-(void)staredMove{
    
    CGFloat starX;
    CGFloat starY;
    starX = KKScreenWidth -30;
    starY = KKScreenHeight -40;
    NSInteger random = arc4random()%5;
    UIImageView *starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX+random,starY-random,30,30)];
    self.starImage = starImage;
    
    [[UIApplication sharedApplication].keyWindow addSubview:starImage];
    starImage.alpha = 0;
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png",@"plane_heart_heart.png", nil];
    
    srand((unsigned)time(0));
    
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    
    self.heartNum = [NSNumber numberWithInteger:random];
    
    [UIView animateWithDuration:0.2 animations:^{
            starImage.alpha = 1.0;
            starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
            CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
            starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
        }];

    
//    CGFloat finishX = _window_width*2 - round(arc4random() % 200);
    //2.1六道修改  需要的是父视图的宽度
    CGFloat finishX = KKScreenWidth - round(arc4random() % 200);

    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(arc4random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(starImage)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    //  设置imageView的结束frame
    starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        starImage.alpha = 0;
    }];
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if (self.starisok == 0) {
        self.starisok = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.starisok = 0;
        });
    }
}
/// 动画完后销毁iamgeView
//kk六道bug 崩溃
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if (context) {
            UIImageView *imageViewsss = (__bridge UIImageView *)(context);
        if (imageViewsss) {
            [imageViewsss removeFromSuperview];
            imageViewsss = nil;

        }
    }
}

//用户送来的礼物
-(void)sendGift:(NSDictionary *)msg
{
    NSDictionary *ct = [msg valueForKey:@"ct"];
    NSString *votestotal = minstr([ct valueForKey:@"votestotal"]);

    self.votesTatal = votestotal;
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkVotesTatal:)]) {
        [self.kkSocketDelegate kkVotesTatal:votestotal];
    }
    
    NSDictionary *giftInfo = @{@"uid":[msg valueForKey:@"uid"],
                               @"nicename":[msg valueForKey:@"uname"],
                               @"giftname":[ct valueForKey:@"giftname"],
                               @"gifticon":[ct valueForKey:@"gifticon"],
                               @"giftcount":[ct valueForKey:@"giftcount"],
                               @"giftid":[ct valueForKey:@"giftid"],
                               @"level":[msg valueForKey:@"level"],
                               @"avatar":[msg valueForKey:@"uhead"],
                               @"type":[ct valueForKey:@"type"],
                               @"swf":minstr([ct valueForKey:@"swf"]),
                               @"swftime":minstr([ct valueForKey:@"swftime"]),
                               @"swftype":minstr([ct valueForKey:@"swftype"]),
                               };

    NSString *type = minstr([ct valueForKey:@"type"]);
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkSendGift:andGiftType:)]) {
        [self.kkSocketDelegate kkSendGift:giftInfo andGiftType:[type intValue]];
    }

}


//增加yingpiao
-(void)addvotesdelegate:(NSString *)votes
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAddVotesTatal:)]) {
        [self.kkSocketDelegate kkAddVotesTatal:votes];
    }
}

#pragma mark ================ 连麦 ===============
- (void)kkAnchor_agreeUserLink:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAnchor_agreeUserLink:)]) {
        [self.kkSocketDelegate kkAnchor_agreeUserLink:dic];
    }
}
//以上是用户和主播连麦相关

/**
 连麦成功，拉取连麦用户的流
 
 @param playurl 流地址
 @param userid 用户ID
 */
-(void)getSmallRTMP_URL:(NSString *)playurl andUserID:(NSString *)userid
{
    [self huanCunLianMaiMessage:playurl andUserID:userid];

    if ([self.kkSocketDelegate respondsToSelector:@selector(kkplayLinkUserUrl:andUid:)]) {
        [self.kkSocketDelegate kkplayLinkUserUrl:playurl andUid:userid];
    }

}
//请求接口，服务器缓存连麦者信息
- (void)huanCunLianMaiMessage:(NSString *)playurl andUserID:(NSString *)touid{
    
    NSDictionary *parameterDic = @{
                                   @"":playurl,
                                   @"":touid
                                   };
    [YBToolClass postNetworkWithUrl:@"" andParameter:parameterDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
}

/**
 有人下麦
 
 @param uid UID
 */
-(void)usercloseConnect:(NSString *)uid
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkusercloseConnect:)]) {
        [self.kkSocketDelegate kkusercloseConnect:uid];
    }
}
/**
 更改Livebroadcast中的连麦状态

 @param islianmai 是否在连麦
 */
- (void)changeLivebroadcastLinkState:(BOOL)islianmai
{
//    isLianmai = islianmai;
}

#pragma mark ================ 主播与主播连麦 ===============
- (void)anchor_agreeLink:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAnchor_agreeLink:)]) {
        [self.kkSocketDelegate kkAnchor_agreeLink:dic];
    }
}
- (void)anchor_stopLink:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAnchor_stopLink:)]) {
        [self.kkSocketDelegate kkAnchor_stopLink:dic];
    }
}

#pragma mark ================ PK ===============
- (void)showPKView
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkShowPKView)]) {
        [self.kkSocketDelegate kkShowPKView];
    }
}
- (void)showPKButton
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkShowPKButton)]) {
        [self.kkSocketDelegate kkShowPKButton];
    }
}
- (void)showPKResult:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkShowPKResult:)]) {
        [self.kkSocketDelegate kkShowPKResult:dic];
    }
}
- (void)changePkProgressViewValue:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkChangePkProgressViewValue:)]) {
        [self.kkSocketDelegate kkChangePkProgressViewValue:dic];
    }
}
- (void)duifangjujuePK{
//    if (pkAlertView) {
//        [pkAlertView removeTimer];
//        [pkAlertView removeFromSuperview];
//        pkAlertView = nil;
//    }
////    startPKBtn.hidden = NO;
//    [frontView addSubview:startPKBtn];

}


#pragma mark ========以上是socket

#pragma mark =======懒加载

- (NSDictionary *)guardInfo
{
    if (!_guardInfo) {
        _guardInfo = [NSDictionary dictionary];
    }
    return _guardInfo;
}
- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (NSMutableArray *)kkLotteryInfoArr
{
    if (!_kkLotteryInfoArr) {
        _kkLotteryInfoArr = [NSMutableArray array];
    }
    return _kkLotteryInfoArr;
}


@end
