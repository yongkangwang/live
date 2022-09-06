//
//  KKChatConfig.h
//  yunbaolive
//
//  Created by Peter on 2020/3/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiveUser;

NS_ASSUME_NONNULL_BEGIN

@interface KKChatConfig : NSObject

+ (void)saveProfile:(LiveUser *)user;
+ (void)updateProfile:(LiveUser *)user;
+ (void)clearProfile;
+ (LiveUser *)myProfile;
+(NSString *)getOwnID;
+(NSString *)getOwnNicename;
+(NSString *)getOwnToken;
+(NSString *)getOwnSignature;
+(NSString *)getavatar;//头像大图
+(NSString *)getavatarThumb;//头像小图
+(NSString *)getLevel;
+(NSString *)getSex;
+(NSString *)getcoin;
+(NSString *)level_anchor;//主播等级
+(NSString *)lgetUserSign;//IM签名
+(NSString *)getIsauth;//认证状态

+(void)saveVipandliang:(NSDictionary *)subdic;//保存靓号和vip
+(NSString *)getVip_type;
+(NSString *)getliang;

+(NSString *)canshu;

+(void)saveRegisterlogin:(NSString *)isreg;
+(NSString *)getIsRegisterlogin;
+(NSString *)getIsUserauth;


@end

NS_ASSUME_NONNULL_END
