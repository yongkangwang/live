//
//  KKLiveRoomInfoModel.m
//  yunbaolive
//
//  Created by Peter on 2021/3/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveViewerInfoModel.h"

#import "LMJHorizontalScrollText.h"

@interface KKLiveViewerInfoModel ()<socketDelegate>

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

@implementation KKLiveViewerInfoModel


- (void)kkStarMove
{
    [self staredMove];
}


- (void)kkLoadLiveViewerInfo:(NSDictionary *)liveInfo
{
    self.kkLiveInfo = liveInfo;
    [self buildUpdate];
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
    WeakSelf;
    self.socketDelegate = [[socketMovieplay alloc]init];
    self.socketDelegate.socketDelegate = self;
    [self.socketDelegate setnodejszhuboDic:self.kkLiveInfo Handler:^(id arrays) {
//        arrays 过来的其实是个字典，不知道他为什么定义为array。
        NSMutableDictionary *info = [[arrays valueForKey:@"info"] firstObject];//kk六道修改
       weakSelf.guardInfo = [info valueForKey:@"guard"];
        [common saveagorakitid:minstr([info valueForKey:@"agorakitid"])];//保存声网ID

        weakSelf.usertype = minstr([info valueForKey:@"usertype"]);
        //保存靓号和vip信息
        NSDictionary *liang = [info valueForKey:@"liang"];
        NSString *liangnum = minstr([liang valueForKey:@"name"]);
        NSDictionary *vip = [info valueForKey:@"vip"];
        NSString *type = minstr([vip valueForKey:@"type"]);
        
        NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
        [Config saveVipandliang:subdic];
        [KKChatConfig saveVipandliang:subdic];


        weakSelf.danmuprice = [info valueForKey:@"barrage_fee"];
        weakSelf.listArray = [info valueForKey:@"userlists"];
        LiveUser *users = [Config myProfile];
        users.coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"coin"]];
        [Config updateProfile:users];
        
        //房间人数
        weakSelf.userCount = [[info valueForKey:@"nums"] intValue];

        if ([weakSelf.kkSocketDelegate respondsToSelector:@selector(kkSocketSuccess:)]) {
            [weakSelf.kkSocketDelegate kkSocketSuccess:info];
        }
        weakSelf.votesTatal = minstr([info valueForKey:@"votestotal"]);
        if ([weakSelf.kkSocketDelegate respondsToSelector:@selector(kkVotesTatal:)]) {
            [weakSelf.kkSocketDelegate kkVotesTatal:weakSelf.votesTatal];
        }

//        [weakSelf kkloadBottomData];
      
        
    }andlivetype:_livetype];
}


#pragma mark ==== socket delegate

//关注等系统消息
-(void)setSystemNot:(NSDictionary *)msg
{
  NSString *  titleColor = @"firstlogin";
    NSString *ct = [msg valueForKey:@"ct"];
    NSString *uname = YZMsg(@"直播间消息");
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];
    
    [self kkSocketMessage:chat];
}
//设置管理员
-(void)setAdmin:(NSDictionary *)msg
{
    NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
    NSString *usertype;
    if ([touid isEqual:[Config getOwnID]]) {
        if ([minstr([msg valueForKey:@"action"]) isEqual:@"0"]) {
            usertype = @"0";
        }else{
            usertype = @"40";
        }
    }
    NSString *  titleColor = @"firstlogin";
    NSString *ct = [msg valueForKey:@"ct"];
    NSString *uname = YZMsg(@"直播间消息");
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];

    [self kkSocketMessage:chat];
}

//踢人
-(void)KickUser:(NSDictionary *)chats
{
    [self kkSocketMessage:chats];
}
#pragma mark ================ 发红包 ===============
- (void)showRedbag:(NSDictionary *)dic
{
//    if (!redBagBtn) {
//        //PK按钮
//        redBagBtn = [UIButton buttonWithType:0];
//        [redBagBtn setBackgroundImage:[UIImage imageNamed:@"红包-右上角"] forState:UIControlStateNormal];
//        [redBagBtn addTarget:self action:@selector(redBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        redBagBtn.frame = CGRectMake(_window_width*2-50, 130+statusbarHeight, 40, 50);
//        [backScrollView addSubview:redBagBtn];
//    }
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
-(void)messageListen:(NSDictionary *)chats
{
    [self kkSocketMessage:chats];
}
//点亮消息
-(void)light:(NSDictionary *)chats
{
    [self kkSocketMessage:chats];
}

- (void)kkSocketMessage:(NSDictionary *)chat
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkSocketMessageSuccess:)]) {
        [self.kkSocketDelegate kkSocketMessageSuccess:chat];
    }
}

-(void)UserLeave:(NSDictionary *)msg{
    self.userCount -= 1;
    [self ChangeLookLivePersion:msg andPersionCount:self.userCount];
}
//********************************用户进入房间动画***********
-(void)UserAccess:(NSDictionary *)msg{
    //用户进入
    self.userCount += 1;
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkUserComeIn:)]) {
        [self.kkSocketDelegate kkUserComeIn:msg];
    }

    NSString *car_id = minstr([[msg valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
//        viplogin *vipanimation;//坐骑进场动画 去掉了，2.1六道
    }
    [self ChangeLookLivePersion:msg andPersionCount:self.userCount];
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

    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkUpdateLiveRoomInfo)];
    [kkScrollText addGestureRecognizer:tapges];

}
- (void)kkUpdateLiveRoomInfo
{
    

}
//房间被管理员关闭
-(void)roomCloseByAdmin
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkRoomCloseByAdmin)]) {
        [self.kkSocketDelegate kkRoomCloseByAdmin];
    }
}
//僵尸粉
-(void)addZombieByArray:(NSArray *)array{
    //六道Peter
//    setFrontV.kkRoomPersonArr = array.mutableCopy;

    self.userCount += array.count;
    //kk六道更新直播间人数
//    [setFrontV kkChangeLookVideoPersionNum:userCount];
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkAddZombieByArray:)]) {
        [self.kkSocketDelegate kkAddZombieByArray:array];
    }
    [self ChangeLookLivePersion:nil andPersionCount:self.userCount];

}

//用户离开
-(void)UserDisconnect:(NSDictionary *)msg{
    self.userCount -= 1;
    [self ChangeLookLivePersion:msg andPersionCount:self.userCount];
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkUserDisconnect:)]) {
        [self.kkSocketDelegate kkUserDisconnect:msg];
    }
}
//通知直播关闭
-(void)LiveOff
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkRoomCloseByAdmin)]) {
        [self.kkSocketDelegate kkRoomCloseByAdmin];
    }
}
//点亮
-(void)sendLight
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

//送礼物
-(void)sendGift:(NSDictionary *)chats andLiansong:(NSString *)liansong andTotalCoin:(NSString *)votestotal andGiftInfo:(NSDictionary *)giftInfo
{
    self.votesTatal = votestotal;
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkVotesTatal:)]) {
        [self.kkSocketDelegate kkVotesTatal:votestotal];
    }
    
    NSString *type = minstr([giftInfo valueForKey:@"type"]);
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkSendGift:andGiftType:)]) {
        [self.kkSocketDelegate kkSendGift:giftInfo andGiftType:[type intValue]];
    }

}

-(void)StartEndLive
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkRoomCloseByAdmin)]) {
        [self.kkSocketDelegate kkRoomCloseByAdmin];
    }
}
//被踢出房间
-(void)kickOK{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"你已被踢出房间") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
//    [alert show];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"你已被踢出房间") preferredStyle:UIAlertControllerStyleAlert];
    //添加一个取消按钮
    [alert addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[MXBADelegate sharedAppDelegate] presentViewController:alert animated:YES completion:nil];

    if ([self.kkSocketDelegate respondsToSelector:@selector(kkKickOutRoomClose)]) {
        [self.kkSocketDelegate kkKickOutRoomClose];
    }

}

//刷新钻石数量
-(void)reloadChongzhi:(NSString *)coin{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkReloadChongzhi:)]) {
        [self.kkSocketDelegate kkReloadChongzhi:coin];
    }
}

//得到主播同意开始连麦
-(void)startConnectvideo{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkStartConnectvideo)]) {
        [self.kkSocketDelegate kkStartConnectvideo];
    }    
}
//主播或者用户断开连麦
-(void)hostout
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkNanchorHostout)]) {
        [self.kkSocketDelegate kkNanchorHostout];
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
- (void)playLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkplayLinkUserUrl:andUid:)]) {
        [self.kkSocketDelegate kkplayLinkUserUrl:playurl andUid:userid];
    }
}
- (void)enabledlianmaibtn{

    if ([self.kkSocketDelegate respondsToSelector:@selector(kkEnabledlianmaibtn)]) {
        [self.kkSocketDelegate kkEnabledlianmaibtn];
    }
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
- (void)showPKView:(NSDictionary *)dic
{
    if ([self.kkSocketDelegate respondsToSelector:@selector(kkShowPKView:)]) {
        [self.kkSocketDelegate kkShowPKView:dic];
    }
}
- (void)showPKButton
{
//    if ([self.kkSocketDelegate respondsToSelector:@selector(kkShowPKButton)]) {
//        [self.kkSocketDelegate kkShowPKButton];
//    }
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


#pragma mark ========以上是socket

     
- (void)kkloadBottomData
{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uid"] = [Config getOwnID];
        params[@"token"] = [Config getOwnToken];
        params[@"zuid"] = self.kkLiveInfo[@"uid"];
    WeakSelf;
        [KKLiveAPI kk_PostLiveRoomBottomInfoWithparameters:params successBlock:^(id  _Nullable response) {
            
            if ([weakSelf.kkSocketDelegate respondsToSelector:@selector(kkLoadRoomFunctionDataSuccess:)]) {
                [weakSelf.kkSocketDelegate kkLoadRoomFunctionDataSuccess:response];
            }
            
//            KKLiveRoomBottomFunctionModel *kkModel = [KKLiveRoomBottomFunctionModel baseModelWithDic:response];
//           NSString *kkIsAttention = response[@"shifougz"];
//            [self.playDoc setValue:kkIsAttention forKey:@"kkIsAttention"];
//            [self isAttentionLive:kkIsAttention];
//            self.kkBottomModel = kkModel;
//            [self.kkBottomRightView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(self.kkBottomModel.kkVerticalCont1Arr.count * 53);
//            }];
//            [self.kkBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(kkModel.kkContArr.count * 45);
//            }];
//            self.kkBottomRightView.kkVerticalDataArr = kkModel.kkVerticalCont1Arr;
//            self.kkBottomView.kkRowDataArr = kkModel.kkContArr;
//
////            右上角广告
//            setFrontV.bannerArray = kkModel.kkAdvertArr.mutableCopy;
            
        } failureBlock:^(NSError * _Nullable error) {
            
        } mainView:nil];

}


//更新用户最新配置
-(void)buildUpdate{
    // 在这里加载后台配置文件
    [YBToolClass postNetworkWithUrl:@"" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *subdic = [info firstObject];
            if (![subdic isEqual:[NSNull null]]) {
                liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                [common saveProfile:commons];
            }
        }

    } fail:^{
        
    }];

}
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
