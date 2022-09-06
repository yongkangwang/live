//
//  KKRobRedBagView.h
//  yunbaolive
//
//  Created by Peter on 2021/11/18.
//  Copyright © 2021 cat. All rights reserved.
//抢红包

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface KKRobRedBagView : UIView

@property (nonatomic,strong) NSMutableDictionary *kkDic;



-(void)kkShow;
-(void)kkDismiss;

@end

NS_ASSUME_NONNULL_END
