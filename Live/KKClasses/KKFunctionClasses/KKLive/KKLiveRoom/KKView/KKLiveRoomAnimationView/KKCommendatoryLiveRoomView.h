//
//  KKCommendatoryLiveRoomView.h
//  yunbaolive
//
//  Created by Peter on 2021/11/9.
//  Copyright © 2021 cat. All rights reserved.
//推荐的直播间

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCommendatoryLiveRoomView : UIView

@property (nonatomic,copy) void(^kkDidSelectItemBlock)(NSDictionary  *liveDic);


-(void)kkShow;
-(void)kkDismiss;

@end

NS_ASSUME_NONNULL_END
