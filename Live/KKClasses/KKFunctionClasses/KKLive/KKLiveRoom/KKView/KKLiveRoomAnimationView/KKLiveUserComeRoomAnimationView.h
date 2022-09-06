//
//  KKLiveUserComeRoomAnimationView.h
//  yunbaolive
//
//  Created by Peter on 2020/1/4.
//  Copyright © 2020 cat. All rights reserved.
//用户进入房间的动画

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveUserComeRoomAnimationView : UIView
//是否是主播端
@property (nonatomic,assign) BOOL kkIsLive;



@property(nonatomic,assign)int  kkisUserMove;// 限制用户进入动画
@property(nonatomic,strong)NSMutableArray *kkuserLoginArr;//用户进入数组，存放动画
-(void)kkAddUserMove:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
