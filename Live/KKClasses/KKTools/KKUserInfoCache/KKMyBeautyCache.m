//
//  KKMyBeautyCache.m
//  yunbaolive
//
//  Created by Peter on 2020/6/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKMyBeautyCache.h"

//#import "FUBeautyParam.h"

NSString *const  kkselectedItem = @"kkselectedItem";//选中的道具名称


NSString *const  kkselectedFilter = @"kkselectedFilter";//选中的滤镜
NSString *const  kkselectedFilterLevel = @"kkselectedFilterLevel";//选中的滤镜Level

NSString *const  kkskinDetectEnable = @"kkskinDetectEnable";
NSString *const  kkblurShape = @"kkblurShape";// 美肤类型 (0、1、) 清晰：0，朦胧：1
NSString *const  kkblurLevel = @"kkblurLevel"; // 磨皮(0.0 - 6.0)
NSString *const  kkwhiteLevel = @"kkwhiteLevel"; // 美白
NSString *const  kkredLevel = @"kkredLevel";// 红润
NSString *const  kkeyelightingLevel = @"kkeyelightingLevel";// 亮眼
NSString *const  kkbeautyToothLevel = @"kkbeautyToothLevel"; // 美牙
NSString *const  kkfaceShape = @"kkfaceShape";// 脸型 (0、1、2) 女神：0，网红：1，自然：2， 自定义：4

NSString *const  kkenlargingLevel = @"kkenlargingLevel"; //大眼 (0~1)
NSString *const  kkthinningLevel = @"kkthinningLevel"; // 瘦脸 (0~1
NSString *const  kkenlargingLevel_new = @"kkenlargingLevel_new"; // 新版大眼 (0~1)
NSString *const  kkthinningLevel_new = @"kkthinningLevel_new"; // 新版瘦脸 (0~1)
NSString *const  kkjewLevel = @"kkjewLevel"; // 下巴 (0~1)
NSString *const  kkforeheadLevel = @"kkforeheadLevel"; // 额头 (0~1)
NSString *const  kknoseLevel = @"kknoseLevel"; // 鼻子 (0~1
NSString *const  kkmouthLevel = @"kkmouthLevel"; // 嘴型 (0~1)


//六道添加2.0

NSString *const  kkstyle_name = @"kkstyle_name";
NSString *const  kkstyle_Title = @"kkstyle_Title";

NSString *const  kkis_beauty_on = @"kkis_beauty_on";
NSString *const  kkuse_landmark = @"kkuse_landmark";

NSString *const  kkfilter_level = @"kkfilter_level";
NSString *const  kkfilter_name = @"kkfilter_name";
NSString *const  kkfilter_Title = @"kkfilter_Title";



NSString *const  kkcolor_level = @"kkcolor_level";
NSString *const  kkred_level = @"kkred_level";
NSString *const  kkblur_level = @"kkblur_level";
NSString *const  kkheavy_blur = @"kkheavy_blur";
NSString *const  kkblur_type = @"kkblur_type";
NSString *const  kkblur_use_mask = @"kkblur_use_mask";
NSString *const  kksharpen = @"kksharpen";
NSString *const  kkeye_bright = @"kkeye_bright";
NSString *const  kktooth_whiten = @"kktooth_whiten";
NSString *const  kkremove_pouch_strength = @"kkremove_pouch_strength";
NSString *const  kkremove_nasolabial_folds_strength = @"kkremove_nasolabial_folds_strength";

NSString *const  kkface_shape_level = @"kkface_shape_level";
NSString *const  kkchange_frames = @"kkchange_frames";
NSString *const  kkface_shape = @"kkface_shape";
NSString *const  kkeye_enlarging = @"kkeye_enlarging";
NSString *const  kkcheek_thinning = @"kkcheek_thinning";
NSString *const  kkcheek_v = @"kkcheek_v";
NSString *const  kkcheek_narrow = @"kkcheek_narrow";
NSString *const  kkcheek_small = @"kkcheek_small";
NSString *const  kkintensity_nose = @"kkintensity_nose";
NSString *const  kkintensity_forehead = @"kkintensity_forehead";
NSString *const  kkintensity_mouth = @"kkintensity_mouth";
NSString *const  kkintensity_chin = @"kkintensity_chin";
NSString *const  kkintensity_philtrum = @"kkintensity_philtrum";
NSString *const  kkintensity_long_nose = @"kkintensity_long_nose";
NSString *const  kkintensity_eye_space = @"kkintensity_eye_space";
NSString *const  kkintensity_eye_rotate = @"kkintensity_eye_rotate";
NSString *const  kkintensity_smile = @"kkintensity_smile";
NSString *const  kkintensity_canthus = @"kkintensity_canthus";
NSString *const  kkintensity_cheekbones = @"kkintensity_cheekbones";
NSString *const  kkintensity_lower_jaw = @"kkintensity_lower_jaw";
NSString *const  kkintensity_eye_circle = @"kkintensity_eye_circle";


@implementation KKMyBeautyCache

+ (void)saveBeauty:(KKMyBeautyCache *)KKMyBeautyCache
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
//    [userDefaults setObject:KKMyBeautyCache.style_name forKey:kkstyle_name];
//    [userDefaults setObject:KKMyBeautyCache.style_Title forKey:kkstyle_Title];

    
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.is_beauty_on] forKey:kkis_beauty_on];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.use_landmark] forKey:kkuse_landmark];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.filter_level] forKey:kkfilter_level];
    [userDefaults setObject:KKMyBeautyCache.filter_name forKey:kkfilter_name];
    [userDefaults setObject:KKMyBeautyCache.filter_Title forKey:kkfilter_Title];

    
    
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.color_level] forKey:kkcolor_level];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.red_level] forKey:kkred_level];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.blur_level] forKey:kkblur_level];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.heavy_blur] forKey:kkheavy_blur];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.blur_type] forKey:kkblur_type];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.blur_use_mask] forKey:kkblur_use_mask];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.sharpen] forKey:kksharpen];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.eye_bright] forKey:kkeye_bright];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.tooth_whiten] forKey:kktooth_whiten];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.remove_pouch_strength] forKey:kkremove_pouch_strength];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.remove_nasolabial_folds_strength] forKey:kkremove_nasolabial_folds_strength];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.face_shape_level] forKey:kkface_shape_level];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.change_frames] forKey:kkchange_frames];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",KKMyBeautyCache.face_shape] forKey:kkface_shape];

    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.eye_enlarging] forKey:kkeye_enlarging];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.cheek_thinning] forKey:kkcheek_thinning];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.cheek_v] forKey:kkcheek_v];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.cheek_narrow] forKey:kkcheek_narrow];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.cheek_small] forKey:kkcheek_small];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_nose] forKey:kkintensity_nose];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_forehead] forKey:kkintensity_forehead];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_mouth] forKey:kkintensity_mouth];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_chin] forKey:kkintensity_chin];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_philtrum] forKey:kkintensity_philtrum];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_long_nose] forKey:kkintensity_long_nose];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_eye_space] forKey:kkintensity_eye_space];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_eye_rotate] forKey:kkintensity_eye_rotate];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_smile] forKey:kkintensity_smile];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_canthus] forKey:kkintensity_canthus];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_cheekbones] forKey:kkintensity_cheekbones];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_lower_jaw] forKey:kkintensity_lower_jaw];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",KKMyBeautyCache.intensity_eye_circle] forKey:kkintensity_eye_circle];
    
    
    [userDefaults synchronize];

}
+ (void)clearBeauty
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 
    [userDefaults setObject:@"无" forKey:kkstyle_name];
    [userDefaults setObject:@"无" forKey:kkstyle_Title];
    
    [userDefaults setObject:@"1" forKey:kkis_beauty_on];
    [userDefaults setObject:@"1" forKey:kkuse_landmark];
    [userDefaults setObject:@"0.4" forKey:kkfilter_level];
    [userDefaults setObject:@"origin" forKey:kkfilter_name];
    [userDefaults setObject:@"原图" forKey:kkfilter_Title];

    
    [userDefaults setObject:@"0.5" forKey:kkcolor_level];//美白
    [userDefaults setObject:@"0.2" forKey:kkred_level];//红润
    [userDefaults setObject:@"0.6" forKey:kkblur_level];//磨皮
    [userDefaults setObject:@"0" forKey:kkheavy_blur];
    [userDefaults setObject:@"2" forKey:kkblur_type];
    [userDefaults setObject:@"0" forKey:kkblur_use_mask];
    
    [userDefaults setObject:@"0.0" forKey:kksharpen];
    [userDefaults setObject:@"0.2" forKey:kkeye_bright];//亮眼
    [userDefaults setObject:@"0.0" forKey:kktooth_whiten];
    
    [userDefaults setObject:@"0.0" forKey:kkremove_pouch_strength];
    [userDefaults setObject:@"0.0" forKey:kkremove_nasolabial_folds_strength];
    
    [userDefaults setObject:@"1.0" forKey:kkface_shape_level];
    [userDefaults setObject:@"0" forKey:kkchange_frames];
    [userDefaults setObject:@"5" forKey:kkface_shape];

    [userDefaults setObject:@"0.0" forKey:kkeye_enlarging];
    [userDefaults setObject:@"0.3" forKey:kkcheek_thinning];//瘦脸
    [userDefaults setObject:@"0.3" forKey:kkcheek_v];//V脸
    [userDefaults setObject:@"0" forKey:kkcheek_narrow];
    [userDefaults setObject:@"0" forKey:kkcheek_small];
    [userDefaults setObject:@"0" forKey:kkintensity_nose];
    [userDefaults setObject:@"0.5" forKey:kkintensity_forehead];
    [userDefaults setObject:@"0.5" forKey:kkintensity_mouth];
    [userDefaults setObject:@"0.5" forKey:kkintensity_chin];
    [userDefaults setObject:@"0.5" forKey:kkintensity_philtrum];
    [userDefaults setObject:@"0.5" forKey:kkintensity_long_nose];
    [userDefaults setObject:@"0.5" forKey:kkintensity_eye_space];
    [userDefaults setObject:@"0.5" forKey:kkintensity_eye_rotate];
    [userDefaults setObject:@"0.0" forKey:kkintensity_smile];
    [userDefaults setObject:@"0.5" forKey:kkintensity_canthus];
    [userDefaults setObject:@"0" forKey:kkintensity_cheekbones];
    [userDefaults setObject:@"0.0" forKey:kkintensity_lower_jaw];
    [userDefaults setObject:@"0.0" forKey:kkintensity_eye_circle];

    
    [userDefaults synchronize];

}
+(KKMyBeautyCache *)myBeauty
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    KKMyBeautyCache *userBeauty = [[KKMyBeautyCache alloc]init];
    
    NSString *kkcache = [userDefaults objectForKey:kkfilter_name];
    //解决拿不到缓存问题
    if (!kkcache.length) {
        [KKMyBeautyCache clearBeauty];
    }
    userBeauty.style_name = [userDefaults objectForKey:kkstyle_name] ;
    userBeauty.style_Title = [userDefaults objectForKey:kkstyle_Title] ;

    userBeauty.is_beauty_on = [[userDefaults objectForKey:kkis_beauty_on] intValue];
    userBeauty.use_landmark = [[userDefaults objectForKey:kkuse_landmark] intValue];
    userBeauty.filter_level = [[userDefaults objectForKey:kkfilter_level] floatValue];
    userBeauty.filter_name = [userDefaults objectForKey:kkfilter_name] ;
    userBeauty.filter_Title = [userDefaults objectForKey:kkfilter_Title] ;

    
    userBeauty.color_level = [[userDefaults objectForKey:kkcolor_level] floatValue];
    userBeauty.red_level = [[userDefaults objectForKey:kkred_level] floatValue];
    userBeauty.blur_level = [[userDefaults objectForKey:kkblur_level] floatValue];
    userBeauty.heavy_blur = [[userDefaults objectForKey:kkheavy_blur] intValue];
    userBeauty.blur_type = [[userDefaults objectForKey:kkblur_type] intValue];
    userBeauty.blur_use_mask = [[userDefaults objectForKey:kkblur_use_mask] intValue];

    userBeauty.sharpen = [[userDefaults objectForKey:kksharpen] floatValue];
    userBeauty.eye_bright = [[userDefaults objectForKey:kkeye_bright] floatValue];
    userBeauty.tooth_whiten = [[userDefaults objectForKey:kktooth_whiten] floatValue];
    
    userBeauty.remove_pouch_strength = [[userDefaults objectForKey:kkremove_pouch_strength] floatValue];
    userBeauty.remove_nasolabial_folds_strength = [[userDefaults objectForKey:kkremove_nasolabial_folds_strength] floatValue];

    userBeauty.face_shape_level = [[userDefaults objectForKey:kkface_shape_level] floatValue];
    userBeauty.change_frames = [[userDefaults objectForKey:kkchange_frames] intValue];
    userBeauty.face_shape = [[userDefaults objectForKey:kkface_shape] intValue];

    userBeauty.eye_enlarging = [[userDefaults objectForKey:kkeye_enlarging] floatValue];
    userBeauty.cheek_thinning = [[userDefaults objectForKey:kkcheek_thinning] floatValue];
    userBeauty.cheek_v = [[userDefaults objectForKey:kkcheek_v] floatValue];
    userBeauty.cheek_narrow = [[userDefaults objectForKey:kkcheek_narrow] floatValue];
    userBeauty.cheek_small = [[userDefaults objectForKey:kkcheek_small] floatValue];

    userBeauty.intensity_nose = [[userDefaults objectForKey:kkintensity_nose] floatValue];
    userBeauty.intensity_forehead = [[userDefaults objectForKey:kkintensity_forehead] floatValue];
    userBeauty.intensity_mouth = [[userDefaults objectForKey:kkintensity_mouth] floatValue];
    userBeauty.intensity_chin = [[userDefaults objectForKey:kkintensity_chin] floatValue];
    userBeauty.intensity_philtrum = [[userDefaults objectForKey:kkintensity_philtrum] floatValue];
    userBeauty.intensity_long_nose = [[userDefaults objectForKey:kkintensity_long_nose] floatValue];
    userBeauty.intensity_eye_space = [[userDefaults objectForKey:kkintensity_eye_space] floatValue];
    userBeauty.intensity_eye_rotate = [[userDefaults objectForKey:kkintensity_eye_rotate] floatValue];
    userBeauty.intensity_smile = [[userDefaults objectForKey:kkintensity_smile] floatValue];
    userBeauty.intensity_canthus = [[userDefaults objectForKey:kkintensity_canthus] floatValue];
    userBeauty.intensity_cheekbones = [[userDefaults objectForKey:kkintensity_cheekbones] floatValue];
    userBeauty.intensity_lower_jaw = [[userDefaults objectForKey:kkintensity_lower_jaw] floatValue];
    userBeauty.intensity_eye_circle = [[userDefaults objectForKey:kkintensity_eye_circle] floatValue];

    return userBeauty;
}


+ (FUBeautyParams *)kkDefaultBeauty
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FUBeautyParams *userBeauty = [[FUBeautyParams alloc] init];

    NSString *kkcache = [userDefaults objectForKey:kkfilter_name];
    //解决拿不到缓存问题
    if (!kkcache.length) {
        [KKMyBeautyCache clearBeauty];
    }

    
    userBeauty.is_beauty_on = [[userDefaults objectForKey:kkis_beauty_on] intValue];
    userBeauty.use_landmark = [[userDefaults objectForKey:kkuse_landmark] intValue];
    userBeauty.filter_level = [[userDefaults objectForKey:kkfilter_level] floatValue];
    userBeauty.filter_name = [userDefaults objectForKey:kkfilter_name] ;
    
    userBeauty.color_level = [[userDefaults objectForKey:kkcolor_level] floatValue];
    userBeauty.red_level = [[userDefaults objectForKey:kkred_level] floatValue];
    userBeauty.blur_level = [[userDefaults objectForKey:kkblur_level] floatValue];
    userBeauty.heavy_blur = [[userDefaults objectForKey:kkheavy_blur] intValue];
    userBeauty.blur_type = [[userDefaults objectForKey:kkblur_type] intValue];
    userBeauty.blur_use_mask = [[userDefaults objectForKey:kkblur_use_mask] intValue];

    userBeauty.sharpen = [[userDefaults objectForKey:kksharpen] floatValue];
    userBeauty.eye_bright = [[userDefaults objectForKey:kkeye_bright] floatValue];
    userBeauty.tooth_whiten = [[userDefaults objectForKey:kktooth_whiten] floatValue];
    
    userBeauty.remove_pouch_strength = [[userDefaults objectForKey:kkremove_pouch_strength] floatValue];
    userBeauty.remove_nasolabial_folds_strength = [[userDefaults objectForKey:kkremove_nasolabial_folds_strength] floatValue];

    userBeauty.face_shape_level = [[userDefaults objectForKey:kkface_shape_level] floatValue];
    userBeauty.change_frames = [[userDefaults objectForKey:kkchange_frames] intValue];
    userBeauty.face_shape = [[userDefaults objectForKey:kkface_shape] intValue];

    userBeauty.eye_enlarging = [[userDefaults objectForKey:kkeye_enlarging] floatValue];
    userBeauty.cheek_thinning = [[userDefaults objectForKey:kkcheek_thinning] floatValue];
    userBeauty.cheek_v = [[userDefaults objectForKey:kkcheek_v] floatValue];
    userBeauty.cheek_narrow = [[userDefaults objectForKey:kkcheek_narrow] floatValue];
    userBeauty.cheek_small = [[userDefaults objectForKey:kkcheek_small] floatValue];

    userBeauty.intensity_nose = [[userDefaults objectForKey:kkintensity_nose] floatValue];
    userBeauty.intensity_forehead = [[userDefaults objectForKey:kkintensity_forehead] floatValue];
    userBeauty.intensity_mouth = [[userDefaults objectForKey:kkintensity_mouth] floatValue];
    userBeauty.intensity_chin = [[userDefaults objectForKey:kkintensity_chin] floatValue];
    userBeauty.intensity_philtrum = [[userDefaults objectForKey:kkintensity_philtrum] floatValue];
    userBeauty.intensity_long_nose = [[userDefaults objectForKey:kkintensity_long_nose] floatValue];
    userBeauty.intensity_eye_space = [[userDefaults objectForKey:kkintensity_eye_space] floatValue];
    userBeauty.intensity_eye_rotate = [[userDefaults objectForKey:kkintensity_eye_rotate] floatValue];
    userBeauty.intensity_smile = [[userDefaults objectForKey:kkintensity_smile] floatValue];
    userBeauty.intensity_canthus = [[userDefaults objectForKey:kkintensity_canthus] floatValue];
    userBeauty.intensity_cheekbones = [[userDefaults objectForKey:kkintensity_cheekbones] floatValue];
    userBeauty.intensity_lower_jaw = [[userDefaults objectForKey:kkintensity_lower_jaw] floatValue];
    userBeauty.intensity_eye_circle = [[userDefaults objectForKey:kkintensity_eye_circle] floatValue];

    return userBeauty;
}

+ (void)kksaveBeauty:(FUBeautyParams *)kkMyBeautyCache
{
    KKMyBeautyCache *userBeauty = [[KKMyBeautyCache alloc] init];

    userBeauty.is_beauty_on = kkMyBeautyCache.is_beauty_on;
    userBeauty.use_landmark = kkMyBeautyCache.use_landmark;
    userBeauty.filter_level = kkMyBeautyCache.filter_level;
    userBeauty.filter_name = kkMyBeautyCache.filter_name;
    userBeauty.filter_Title = kkMyBeautyCache.filter_name;
    
    userBeauty.color_level = kkMyBeautyCache.color_level;
    userBeauty.red_level = kkMyBeautyCache.red_level;
    userBeauty.blur_level = kkMyBeautyCache.blur_level;
    userBeauty.heavy_blur = kkMyBeautyCache.heavy_blur;
    userBeauty.blur_type = kkMyBeautyCache.blur_type;
    userBeauty.blur_use_mask = kkMyBeautyCache.blur_use_mask;

    userBeauty.sharpen = kkMyBeautyCache.sharpen;
    userBeauty.eye_bright = kkMyBeautyCache.eye_bright;
    userBeauty.tooth_whiten = kkMyBeautyCache.tooth_whiten;
    
    userBeauty.remove_pouch_strength = kkMyBeautyCache.remove_pouch_strength;
    userBeauty.remove_nasolabial_folds_strength = kkMyBeautyCache.remove_nasolabial_folds_strength;

    userBeauty.face_shape_level = kkMyBeautyCache.face_shape_level;
    userBeauty.change_frames = kkMyBeautyCache.change_frames;
    userBeauty.face_shape = kkMyBeautyCache.face_shape;

    userBeauty.eye_enlarging = kkMyBeautyCache.eye_enlarging;
    userBeauty.cheek_thinning = kkMyBeautyCache.cheek_thinning;
    userBeauty.cheek_v = kkMyBeautyCache.cheek_v;
    userBeauty.cheek_narrow = kkMyBeautyCache.cheek_narrow;
    userBeauty.cheek_small = kkMyBeautyCache.cheek_small;

    userBeauty.intensity_nose = kkMyBeautyCache.intensity_nose;
    userBeauty.intensity_forehead = kkMyBeautyCache.intensity_forehead;
    userBeauty.intensity_mouth = kkMyBeautyCache.intensity_mouth;
    userBeauty.intensity_chin = kkMyBeautyCache.intensity_chin;
    userBeauty.intensity_philtrum = kkMyBeautyCache.intensity_philtrum;
    userBeauty.intensity_long_nose = kkMyBeautyCache.intensity_long_nose;
    userBeauty.intensity_eye_space = kkMyBeautyCache.intensity_eye_space;
    userBeauty.intensity_eye_rotate = kkMyBeautyCache.intensity_eye_rotate;
    userBeauty.intensity_smile = kkMyBeautyCache.intensity_smile;
    userBeauty.intensity_canthus = kkMyBeautyCache.intensity_canthus;
    userBeauty.intensity_cheekbones = kkMyBeautyCache.intensity_cheekbones;
    userBeauty.intensity_lower_jaw = kkMyBeautyCache.intensity_lower_jaw;
    userBeauty.intensity_eye_circle = kkMyBeautyCache.intensity_eye_circle;
    [KKMyBeautyCache saveBeauty:userBeauty];
}



- (void)kktemp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:@"fengya_ztt_fu" forKey:kkselectedItem];
    [userDefaults setObject:@"origin" forKey:kkselectedFilter];//
    [userDefaults setObject:@"0.5" forKey:kkselectedFilterLevel];//自然
    [userDefaults setObject:@"YES" forKey:kkskinDetectEnable];
    [userDefaults setObject:@"1" forKey:kkblurShape];
    [userDefaults setObject:@"4" forKey:kkfaceShape];
    [userDefaults setObject:@"0.69999999999999996" forKey:kkblurLevel];
    [userDefaults setObject:@"0.7" forKey:kkwhiteLevel];
    [userDefaults setObject:@"0.5" forKey:kkredLevel];
    
    [userDefaults setObject:@"0.5" forKey:kkeyelightingLevel];

    [userDefaults setObject:@"0.5" forKey:kkbeautyToothLevel];

    [userDefaults setObject:@"0.40000000000000002" forKey:kkenlargingLevel];
    [userDefaults setObject:@"0.5" forKey:kkthinningLevel];

    [userDefaults setObject:@"0.40000000000000002" forKey:kkenlargingLevel_new];
    [userDefaults setObject:@"0.5" forKey:kkthinningLevel_new];//瘦脸

    [userDefaults setObject:@"-0.20000000000000001" forKey:kkjewLevel];
    [userDefaults setObject:@"-0.20000000000000001" forKey:kkforeheadLevel];
    [userDefaults setObject:@"0.5" forKey:kknoseLevel];
    [userDefaults setObject:@"-0.099999999999999978" forKey:kkmouthLevel];

}

@end
