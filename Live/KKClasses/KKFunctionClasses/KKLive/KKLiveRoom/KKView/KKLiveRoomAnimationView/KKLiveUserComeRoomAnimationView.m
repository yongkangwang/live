//
//  KKLiveUserComeRoomAnimationView.m
//  yunbaolive
//
//  Created by Peter on 2020/1/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKLiveUserComeRoomAnimationView.h"

@interface KKLiveUserComeRoomAnimationView ()
//@property(nonatomic,strong)UIImageView *kkuserMoveImageV;//进入动画背景
@property(nonatomic,strong)UIView *kkmsgView;//显示用户信息
@property(weak,nonatomic)UILabel *kkNameL;

@end

@implementation KKLiveUserComeRoomAnimationView

-(instancetype)init{
    self = [super init];
    if (self) {
        _kkisUserMove = 0;
        _kkuserLoginArr = [NSMutableArray array];
        
        [self kkInitView];
    }
    return self;
}


- (void)kkInitView
{
    _kkmsgView = [[UIView alloc]init];//40
    _kkmsgView.backgroundColor = RGB_COLOR(@"#000000", 0.3);

    [self addSubview:_kkmsgView];
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.textColor = KKWhiteColor;//设置默认颜色
    nameL.font = kkFontBoldMT(14);
    self.kkNameL = nameL;
    
    [_kkmsgView addSubview:nameL];

}

-(void)kkAddUserMove:(NSDictionary *)msg{
    
    if (msg == nil) {
        
    }else
    {
        [_kkuserLoginArr addObject:msg];
    }
    if(_kkisUserMove == 0){
        [self userLoginOne];
    }
}
-(void)userLoginOne{
    
    if (_kkuserLoginArr.count == 0 || _kkuserLoginArr == nil) {
        return;
    }
    NSDictionary *Dic = [_kkuserLoginArr firstObject];
    [_kkuserLoginArr removeObjectAtIndex:0];
    [self userPlar:Dic];
}
/*
 vip_type 0表示无VIP，1表示普通VIP，2表示至尊VIP
 
 */
-(void)userPlar:(NSDictionary *)dic{
    _kkisUserMove = 1;
    self.hidden = NO;
    
    NSDictionary *ct = [dic valueForKey:@"ct"];
    NSString *kkuserNameStr = [NSString stringWithFormat:@"%@%@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入了直播间")];

    CGSize kklabSize  = [kkuserNameStr
    boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
    options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
    context:nil].size;

    _kkmsgView.frame =CGRectMake(20, 0,(kklabSize.width + 45), 25);

    self.kkNameL.frame = self.kkmsgView.frame;
    if (self.kkIsLive) {
//        _kkmsgView = [[UIView alloc]initWithFrame:CGRectMake(20, 0,(kklabSize.width + 45), 25)];//40
    }else{
//        _kkmsgView = [[UIView alloc]initWithFrame:CGRectMake(KKScreenWidth + 20, 0,(kklabSize.width + 45), 25)];//40
//        _kkmsgView.frame =CGRectMake(20, 0,(kklabSize.width + 45), 25);

    }

    
//    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(5 + 3,5,(kklabSize.width +30),14)];//25
//RGB_COLOR(@"#c7c9c7", 1)   normalColors  ff008c
//    nameL.textColor = KKWhiteColor;//设置默认颜色
//    nameL.font = kkFontBoldMT(14);

  NSRange redRange = NSMakeRange(0, minstr([ct valueForKey:@"user_nicename"]).length);
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入了直播间")]];

    NSDictionary *levelDic = [common getUserLevelMessage:ct[@"level"]];//level

    //设置聊天用户名字颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(minstr([levelDic valueForKey:@"colour"]), 1) range:redRange];
    
    NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
    
    NSTextAttachment *levelAttchment = [[NSTextAttachment alloc]init];
    levelAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
    
    //2.7.6六道image修改
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            levelAttchment.image = image;
        }

    }];

//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            levelAttchment.image = image;
//        }
//    }];
    
    NSAttributedString *levelString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(levelAttchment)];
    
    //插入靓号图标
    if (![minstr([ct valueForKey:@"liangname"]) isEqual:@"0"] && ![minstr([ct valueForKey:@"liangname"]) isEqual:@"(null)"] && minstr([ct valueForKey:@"liangname"]) !=nil && minstr([ct valueForKey:@"liangname"]) !=NULL) {
//        [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
    }
    //插入守护图标
    if ([minstr([ct valueForKey:@"guard_type"]) isEqual:@"1"]) {
//        [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
    }
    if ([minstr([ct valueForKey:@"guard_type"]) isEqual:@"2"]) {
        //        [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
    }

    //插入VIP图标
    [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
//    [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
    
//    [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
    [noteStr insertAttributedString:levelString atIndex:0];//插入到第几个下标
    
    [self.kkNameL setAttributedText:noteStr];
//    [_kkmsgView addSubview:nameL];

    //    CGMutablePathRef path = CGPathCreateMutable();
    //CGPathAddArc函数是通过圆心和半径定义一个圆，然后通过两个弧度确定一个弧线。注意弧度是以当前坐标环境的X轴开始的。
    //需要注意的是由于ios中的坐标体系是和Quartz坐标体系中Y轴相反的，所以iOS UIView在做Quartz绘图时，Y轴已经做了Scale为-1的转换，因此造成CGPathAddArc函数最后一个是否是顺时针的参数结果正好是相反的，也就是说如果设置最后的参数为1，根据参数定义应该是顺时针的，但实际绘图结果会是逆时针的！
    //严格的说，这个方法只是确定一个中心点后，以某个长度作为半径，以确定的角度和顺逆时针而进行旋转，半径最低设置为1，设置为0则动画不会执行
    
//    CGPathAddArc(path, NULL, iconImgView.centerX, iconImgView.centerY, 16, 0,M_PI * 2, 0);
//
//    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = path;
//    CGPathRelease(path);
//    animation.duration = 3;
//    animation.repeatCount = 1;
//    animation.autoreverses = NO;
//    animation.rotationMode =kCAAnimationRotateAuto;
//    animation.fillMode =kCAFillModeForwards;

    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1.5
        [UIView animateWithDuration:0.5 animations:^{
           weakSelf.kkmsgView.x = 0;

        }] ;
    });
    //动画时间 3.5
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //0.5
        [UIView animateWithDuration:0.5 animations:^{

        } completion:^(BOOL finished) {
//            [weakSelf.kkmsgView removeFromSuperview];
//            weakSelf.kkmsgView = nil;
            weakSelf.kkisUserMove = 0;
            weakSelf.hidden = YES;
            if (weakSelf.kkuserLoginArr.count >0) {
                [weakSelf kkAddUserMove:nil];
            }
        }];

    });
}

@end
