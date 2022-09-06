//
//  KKMyBeautyCache.h
//  yunbaolive
//
//  Created by Peter on 2020/6/8.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FUBeautyParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKMyBeautyCache : NSObject

+ (void)saveBeauty:(KKMyBeautyCache *)KKMyBeautyCache;
+ (void)clearBeauty;
//美颜缓存
+ (KKMyBeautyCache *)myBeauty;
//美颜缓存
+ (FUBeautyParams *)kkDefaultBeauty;

+ (void)kksaveBeauty:(FUBeautyParams *)kkMyBeautyCache;


//风格
@property (nonatomic,copy)  NSString *style_name;//英文
@property (nonatomic,copy)  NSString *style_Title;//


/* 全局参数 */
@property (nonatomic,assign)int is_beauty_on;
@property (nonatomic,assign)  int use_landmark;
/* 滤镜参数程度 */
@property (nonatomic,assign)float filter_level;
@property (nonatomic,copy)  NSString *filter_name;//英文
@property (nonatomic,copy)  NSString *filter_Title;//中文

/* 美白 */
@property (nonatomic,assign)float color_level;
/* 红润 */
@property (nonatomic,assign)float red_level;
/* 磨皮 *///精细磨皮
@property (nonatomic,assign)float blur_level;
@property (nonatomic,assign)int heavy_blur;
@property (nonatomic,assign)int blur_type;
@property (nonatomic,assign)int blur_use_mask;
/* 锐化 */
@property (nonatomic,assign)float sharpen;
/* 亮眼 */
@property (nonatomic,assign)float eye_bright;
/* 美牙 */
@property (nonatomic,assign)float tooth_whiten;
/* 去黑眼圈 */
@property (nonatomic,assign)float remove_pouch_strength;
/* 去法令纹 */
@property (nonatomic,assign)float remove_nasolabial_folds_strength;
/* 美型 */
/* 美型的整体程度 */
@property (nonatomic,assign)float face_shape_level;
/* 美型的渐变 */
@property (nonatomic,assign)int change_frames;
/* 美型的种类 */
@property (nonatomic,assign)int face_shape;
/* 大眼 */
@property (nonatomic,assign)float eye_enlarging;
/* 瘦脸 */
@property (nonatomic,assign)float cheek_thinning;
/* v脸程度 */
@property (nonatomic,assign)float cheek_v;
/* 窄脸程度 */
@property (nonatomic,assign)float cheek_narrow;
/* 小脸程度 */
@property (nonatomic,assign)float cheek_small;
/* 瘦鼻程度 */
@property (nonatomic,assign)float intensity_nose;
/* 额头调整 */
@property (nonatomic,assign)float intensity_forehead;
/* 嘴巴调整 */
@property (nonatomic,assign)float intensity_mouth;
/* 下巴调整 */
@property (nonatomic,assign)float intensity_chin;
/* 人中调节 */
@property (nonatomic,assign)float intensity_philtrum;
/* 鼻子长度 */
@property (nonatomic,assign)float intensity_long_nose;
/* 眼距调节 */
@property (nonatomic,assign)float intensity_eye_space;
/* 眼睛角度 */
@property (nonatomic,assign)float intensity_eye_rotate;
/* 微笑嘴角 */
@property (nonatomic,assign)float intensity_smile;
/* 开眼角程度 */
@property (nonatomic,assign)float intensity_canthus;
/* 瘦颧骨 */
@property (nonatomic,assign)float intensity_cheekbones;
/* 瘦下颌骨 */
@property (nonatomic,assign)float intensity_lower_jaw;
/* 圆眼 */
@property (nonatomic,assign)float intensity_eye_circle;

///===================================================

//string
@property (nonatomic, copy) NSString *selectedItem;     /**选中的道具名称*/

@property (nonatomic,copy) NSString * selectedFilter;//选中的滤镜
//double
@property (nonatomic,copy) NSString * selectedFilterLevel;//选中滤镜的 level

//BOOL值
@property (nonatomic,copy) NSString * skinDetectEnable;// 精准美肤
//NSInteger
@property (nonatomic,copy) NSString * blurShape;//美肤类型 (0、1、) 清晰：0，朦胧：1
@property (nonatomic,copy) NSString * faceShape;// 脸型 (0、1、2) 女神：0，网红：1，自然：2， 自定义：4

//double
@property (nonatomic,copy) NSString * blurLevel;// 磨皮(0.0 - 6.0)
@property (nonatomic,copy) NSString * whiteLevel;//美白
@property (nonatomic,copy) NSString * redLevel;//红润
@property (nonatomic,copy) NSString * eyelightingLevel;//亮眼
@property (nonatomic,copy) NSString * beautyToothLevel;//美牙
@property (nonatomic,copy) NSString * enlargingLevel;//大眼 (0~1)
@property (nonatomic,copy) NSString * thinningLevel;//瘦脸 (0~1)
@property (nonatomic,copy) NSString * enlargingLevel_new;//新版大眼 (0~1
@property (nonatomic,copy) NSString * thinningLevel_new;//新版瘦脸 (0~1)

@property (nonatomic,copy) NSString * jewLevel;//下巴 (0~1)
@property (nonatomic,copy) NSString * foreheadLevel;//额头 (0~1)
@property (nonatomic,copy) NSString * noseLevel;//鼻子 (0~1)
@property (nonatomic,copy) NSString * mouthLevel;//嘴型 (0~1)


@end

NS_ASSUME_NONNULL_END
