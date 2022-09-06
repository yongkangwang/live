//
//  KKInfoCache.h
//  yunbaolive
//
//  Created by Peter on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKInfoCache : NSObject



//最近使用小游戏数据库

/**
添加一条最近使用
*/
+ (void)kkAddGameRecentlyUsedWriteToPlist:(NSMutableDictionary *)dic;
//批量添加
+ (void)kkAddListGameRecentlyUsedWriteToPlist:(NSMutableArray *)array;


/**
删除一条最近使用
*/
+ (void)kkDeleteGameRecentlyUsed:(NSString *)kkGameID;

/**
读取最近小游戏使用数据

@return 小游戏列表数据
*/

+ (NSMutableArray *)kkReadGameRecentlyUsedListFromPlist;


//=====================================================================


//悬浮窗小游戏数据库

/**
游戏悬浮最近使用 写入数据到plist
*/
+ (void)kkGameRecentlyUsedWriteToPlist:(NSMutableArray *)array;
/**
从plist读取 游戏最近使用数据

@return 悬浮小游戏  读出数据
*/
+ (NSArray *)kkReadGameRecentlyUsedFromPlist;

@end

NS_ASSUME_NONNULL_END
