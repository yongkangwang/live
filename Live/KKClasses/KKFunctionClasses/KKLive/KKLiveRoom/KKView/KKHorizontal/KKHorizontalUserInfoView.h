//
//  KKHorizontalUserInfoView.h
//  yunbaolive
//
//  Created by Peter on 2020/10/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKUserInfoDelegate <NSObject>


-(void)zhubomessage;//点击主播弹窗
-(void)guanzhuZhuBo;//关注zhubo
-(void)gongxianbang;//跳贡献榜

@end

@interface KKHorizontalUserInfoView : UIView
@property(strong,nonatomic)NSDictionary *zhuboDic;
@property (nonatomic,weak) id<KKUserInfoDelegate> kkUserInfoDelegate;

@end

NS_ASSUME_NONNULL_END
