//
//  KKChatConfig.m
//  yunbaolive
//
//  Created by Peter on 2020/3/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKChatConfig.h"


NSString * const KKuser_nickname = @"kkuser_nickname";
NSString * const KKconsumption = @"kkconsumption";
NSString * const KKisauth = @"kkisauth";
NSString * const KKisreg = @"kkisreg";
NSString * const KKusersig = @"kkusersig";


NSString * const KKAvatar = @"kkavatar";
NSString * const KKBirthday = @"kkbirthday";
NSString * const KKCoin = @"kkcoin";
NSString * const KKID = @"kkID";
NSString * const KKSex = @"kksex";
NSString * const KKToken = @"kktoken";
NSString * const KKUser_nicename = @"kkuser_nicename";
NSString * const KKSignature = @"kksignature";
NSString * const KKcity = @"kkcity";
NSString * const KKlevel = @"kklevel";
NSString * const kKavatar_thumb = @"kkavatar_thumb";
NSString * const KKlogin_type = @"kklogin_type";
NSString * const KKlevel_anchor = @"kklevel_anchor";


NSString * const KKvip_type = @"kkvip_type";
NSString * const KKliang = @"kkliang";


NSString *const  im_tips = @"im_tips";
//_textView.placeholdLabel.text = [KKChatConfig im_tips];
NSString * const KKMianZhuan = @"kkmianzhuan";


@implementation KKChatConfig

#pragma mark - user profile

//保存靓号和vip
+(void)saveVipandliang:(NSDictionary *)subdic{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:minstr([subdic valueForKey:@"vip_type"]) forKey:KKvip_type];
     [userDefaults setObject:minstr([subdic valueForKey:@"liang"]) forKey:KKliang];
     [userDefaults synchronize];
}
+(NSString *)getVip_type{
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *viptype = minstr([userDefults objectForKey:KKvip_type]);
    return viptype;
    
}
+(NSString *)getliang{
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *liangnum = minstr( [userDefults objectForKey:KKliang]);
    return liangnum;
    
}



+ (void)saveProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user.user_nickname forKey:KKuser_nickname];
    [userDefaults setObject:user.user_nickname forKey:KKUser_nicename];

    [userDefaults setObject:user.consumption forKey:KKconsumption];
    [userDefaults setObject:user.isauth forKey:KKisauth];
    [userDefaults setObject:user.isreg forKey:KKisreg];
    [userDefaults setObject:user.usersig forKey:KKusersig];

    
    [userDefaults setObject:user.avatar forKey:KKAvatar];
    [userDefaults setObject:user.level_anchor forKey:KKlevel_anchor];
    [userDefaults setObject:user.avatar_thumb forKey:kKavatar_thumb];
    [userDefaults setObject:user.coin forKey:KKCoin];
    [userDefaults setObject:user.sex forKey:KKSex];
    [userDefaults setObject:user.ID forKey:KKID];
    [userDefaults setObject:user.token forKey:KKToken];
    [userDefaults setObject:user.signature forKey:KKSignature];
    [userDefaults setObject:user.login_type forKey:KKlogin_type];
    
    [userDefaults setObject:user.birthday forKey:KKBirthday];
    [userDefaults setObject:user.city forKey:KKcity];
    [userDefaults setObject:user.level forKey:KKlevel];
    [userDefaults synchronize];
    
}
+ (void)updateProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(user.mianzhuan != nil) [userDefaults setObject:user.mianzhuan forKey:KKMianZhuan];

    if(user.ID != nil) [userDefaults setObject:user.ID forKey:KKID];
    if(user.token != nil) [userDefaults setObject:user.token forKey:KKToken];

    if(user.user_nicename != nil) [userDefaults setObject:user.user_nicename forKey:KKUser_nicename];
    if(user.level_anchor != nil) [userDefaults setObject:user.level_anchor forKey:KKlevel_anchor];
    if(user.signature!=nil) [userDefaults setObject:user.signature forKey:KKSignature];
    if(user.avatar!=nil) [userDefaults setObject:user.avatar forKey:KKAvatar];
    if(user.avatar_thumb!=nil) [userDefaults setObject:user.avatar_thumb forKey:kKavatar_thumb];
    if(user.coin!=nil) [userDefaults setObject:user.coin forKey:KKCoin];
    if(user.birthday!=nil) [userDefaults setObject:user.birthday forKey:KKBirthday];
    if(user.login_type!=nil) [userDefaults setObject:user.login_type forKey:KKlogin_type];
    if(user.city!=nil) [userDefaults setObject:user.city forKey:KKcity];
    if(user.sex!=nil) [userDefaults setObject:user.sex forKey:KKSex];
    if(user.level!=nil) [userDefaults setObject:user.level forKey:KKlevel];

    
    if(user.user_nickname!=nil) [userDefaults setObject:user.user_nickname forKey:KKuser_nickname];
    if(user.consumption!=nil) [userDefaults setObject:user.consumption forKey:KKconsumption];
    if(user.isauth!=nil) [userDefaults setObject:user.isauth forKey:KKisauth];
    if(user.isreg!=nil) [userDefaults setObject:user.isreg forKey:KKisreg];
    if(user.usersig!=nil) [userDefaults setObject:user.usersig forKey:KKusersig];

    
    [userDefaults synchronize];
}

+ (void)clearProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:KKuser_nickname];
    [userDefaults setObject:nil forKey:KKconsumption];
    [userDefaults setObject:nil forKey:KKisauth];
    [userDefaults setObject:nil forKey:KKisreg];
    [userDefaults setObject:nil forKey:KKusersig];
    
    [userDefaults setObject:nil forKey:KKlevel_anchor];
    [userDefaults setObject:nil forKey:KKAvatar];
    [userDefaults setObject:nil forKey:KKBirthday];
    [userDefaults setObject:nil forKey:KKCoin];
    [userDefaults setObject:nil forKey:KKID];
    [userDefaults setObject:nil forKey:KKSex];
    [userDefaults setObject:nil forKey:KKToken];
    [userDefaults setObject:nil forKey:KKUser_nicename];
    [userDefaults setObject:nil forKey:KKlogin_type];
    [userDefaults setObject:nil forKey:KKSignature];
    [userDefaults setObject:nil forKey:KKcity];
    [userDefaults setObject:nil forKey:KKlevel];
    [userDefaults setObject:nil forKey:kKavatar_thumb];
    [userDefaults setObject:nil forKey:KKvip_type];
    [userDefaults setObject:nil forKey:KKliang];
    [userDefaults setObject:nil forKey:@"notifacationOldTime"];
    [userDefaults synchronize];
}

+ (LiveUser *)myProfile
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LiveUser *user = [[LiveUser alloc] init];
    
    user.mianzhuan = [userDefaults objectForKey: KKMianZhuan];
    user.user_nickname = [userDefaults objectForKey: KKuser_nickname];
    user.consumption = [userDefaults objectForKey: KKconsumption];
    user.isauth = [userDefaults objectForKey: KKisauth];
    user.isreg = [userDefaults objectForKey: KKisreg];
    user.usersig = [userDefaults objectForKey: KKusersig];

    
    user.avatar = [userDefaults objectForKey: KKAvatar];
    user.birthday = [userDefaults objectForKey: KKBirthday];
    user.coin = [userDefaults objectForKey: KKCoin];
    user.level_anchor = [userDefaults objectForKey: KKlevel_anchor];
    user.ID = [userDefaults objectForKey: KKID];
    user.sex = [userDefaults objectForKey: KKSex];
    user.token = [userDefaults objectForKey: KKToken];
    user.user_nicename = [userDefaults objectForKey: KKUser_nicename];
    user.signature = [userDefaults objectForKey:KKSignature];
    user.level = [userDefaults objectForKey:KKlevel];
    user.city = [userDefaults objectForKey:KKcity];
    user.avatar_thumb = [userDefaults objectForKey:kKavatar_thumb];
    user.login_type = [userDefaults objectForKey:KKlogin_type];

    
    return user;
}

+(NSString *)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: KKID];
    return ID;
}

+(NSString *)getOwnNicename
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* nicename = [userDefaults objectForKey: KKUser_nicename];
    return nicename;
}

+(NSString *)getOwnToken
{

    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefults objectForKey:KKToken];
    return token;
}

+(NSString *)getOwnSignature
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefults objectForKey:KKSignature];
    return signature;
}
+(NSString *)getavatar
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [NSString stringWithFormat:@"%@",[userDefults objectForKey:KKAvatar]];
    return avatar;
}
+(NSString *)getavatarThumb
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefults objectForKey:kKavatar_thumb];
    return signature;
}
+(NSString *)getLevel
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *level = [userDefults objectForKey:KKlevel];
    return level;
}
+(NSString *)getSex
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *sex = [userDefults objectForKey:KKSex];
    return sex;
}
+(NSString *)getcoin
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *coin = [userDefults objectForKey:KKCoin];
    return coin;
}
+(NSString *)level_anchor
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *level_anchors = [userDefults objectForKey:KKlevel_anchor];
    return level_anchors;
}

+(NSString *)canshu{
    return @"zh_cn";

//    if ([lagType isEqual:ZH_CN]) {
//
//    }
}

+(NSString *)getIsRegisterlogin{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *isauth = [userDefults objectForKey:KKisreg];
    return isauth;
}

+(void)saveRegisterlogin:(NSString *)isreg{
    [[NSUserDefaults standardUserDefaults] setObject:isreg forKey:KKisreg];
}

+(NSString *)getIsauth{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *isauth = [userDefults objectForKey:KKisauth];
    return isauth;
}

+(NSString *)lgetUserSign{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *sign = [userDefults objectForKey:KKusersig];
    return sign;

}
@end
