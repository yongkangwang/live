//
//  KKTextToolBar.h
//  yunbaolive
//
//  Created by Peter on 2020/10/13.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class catSwitch;
@interface KKTextToolBar : UIView

@property(weak,nonatomic)UITextField *kkTextField;

@property (nonatomic,copy) NSString * kkBarrageMoney;
@property(weak,nonatomic)catSwitch *kkCatSwitch;
@property(weak,nonatomic)UIButton *kkMessagePushBTN;
//
@property (nonatomic,copy) void(^kkMessagePushBtnClickBlock)(UITextField  *kkTextField);



@property (nonatomic,assign) BOOL kkIsHorizontal;
//1隐藏左右两边的按钮
@property (nonatomic,assign) int kkToolBarType;

//用于多人通话发送消息
@property (nonatomic,copy) void(^kkPushMessageBtnClickBlock)(UITextField  *kkTextField ,NSDictionary *userDic);
@property(strong,nonatomic)NSMutableArray *kkUserInfoArr;

@end

NS_ASSUME_NONNULL_END
