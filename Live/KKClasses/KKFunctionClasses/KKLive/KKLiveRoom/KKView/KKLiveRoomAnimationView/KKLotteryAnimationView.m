//
//  KKLotteryAnimationView.m
//  yunbaolive
//
//  Created by Peter on 2020/6/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKLotteryAnimationView.h"

@interface KKLotteryAnimationView ()

@property(nonatomic,strong)UIView *kkmsgView;//显示用户信息
@property(nonatomic,assign)int  kkisUserMove;// 限制用户进入动画
@property(nonatomic,strong)NSMutableArray *kkuserLoginArr;//用户进入数组，存放动画

@end

@implementation KKLotteryAnimationView

-(instancetype)init{
    self = [super init];
    if (self) {
        _kkisUserMove = 0;
        _kkuserLoginArr = [NSMutableArray array];
    }
    return self;
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
    NSDictionary *ct = [dic valueForKey:@"ct"];
  
   NSString *kkuserNameStr = [NSString stringWithFormat:@"%@%@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入了直播间")];

    CGSize kklabSize  = [kkuserNameStr
    boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
    options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
    context:nil].size;

    _kkmsgView = [[UIView alloc]initWithFrame:CGRectMake(KKScreenHeight + 20, 0,(kklabSize.width + 45), 25)];//40

    _kkmsgView.backgroundColor = RGB_COLOR(@"#000000", 0.3);


    [self addSubview:_kkmsgView];

    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(5 + 3,5,(kklabSize.width +30),14)];//25

    NSDictionary *levelDic = [common getUserLevelMessage:ct[@"level"]];//level
    nameL.textColor = KKWhiteColor;//设置默认颜色
    nameL.font = kkFontBoldMT(14);

  NSRange redRange = NSMakeRange(0, minstr([ct valueForKey:@"user_nicename"]).length);
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入了直播间")]];

    //设置聊天用户名字颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(minstr([levelDic valueForKey:@"colour"]), 1) range:redRange];
    NSTextAttachment *levelAttchment = [[NSTextAttachment alloc]init];
    levelAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
    
    NSAttributedString *levelString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(levelAttchment)];
    [noteStr insertAttributedString:levelString atIndex:0];//插入到第几个下标
    
    [nameL setAttributedText:noteStr];
    [_kkmsgView addSubview:nameL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1.5
        [UIView animateWithDuration:0.5 animations:^{
            _kkmsgView.x = 0;

        }] ;
    });
    //动画时间 3.5
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //0.5
        [UIView animateWithDuration:0.5 animations:^{

        } completion:^(BOOL finished) {

            [_kkmsgView removeFromSuperview];
            _kkmsgView = nil;
            _kkisUserMove = 0;

        }];

    });
}

@end
