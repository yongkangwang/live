//
//  KKInfoCache.m
//  yunbaolive
//
//  Created by Peter on 2020/10/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKInfoCache.h"

@implementation KKInfoCache

//最近使用小游戏数据库
/**
添加一条最近使用
*/
+ (void)kkAddGameRecentlyUsedWriteToPlist:(NSMutableDictionary *)dic
{
    NSMutableArray *resultArr = [self kkReadGameRecentlyUsedListFromPlist];
    if (resultArr ==nil) {
        resultArr = [NSMutableArray array];
    }
    
    
        [resultArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *msgdic = obj;
                if ([msgdic[@"youxi_id"] isEqualToString:dic[@"youxi_id"]]) {
                    *stop = YES;
                    [resultArr removeObject:msgdic];
                    *stop = NO; //移除了数组中的元素之后继续执行
                }
            }
        }];
    
    [resultArr insertObject:dic atIndex:0];
    if (resultArr.count>20) {
        [resultArr removeLastObject];
    }
    [self kkAddListGameRecentlyUsedWriteToPlist:resultArr];
}
//批量添加
+ (void)kkAddListGameRecentlyUsedWriteToPlist:(NSMutableArray *)array
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    KKLog(@"写入数据地址%@",path);
    
    NSString *fileName = [path stringByAppendingPathComponent:@"GameRecentlyUsedList.plist"];
    BOOL kkIsWrite = [array writeToFile:fileName atomically:YES];
     if (kkIsWrite) {
         KKLog(@"写入成功");
     }else{
         KKLog(@"写入失败");
     }
}

//删除一条最近使用
+ (void)kkDeleteGameRecentlyUsed:(NSString *)kkGameID
{
    NSMutableArray *resultArr = [self kkReadGameRecentlyUsedListFromPlist];
    if (resultArr ==nil) {
        resultArr = [NSMutableArray array];
    }
    [resultArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    for (NSMutableDictionary *dic in resultArr) {
        if ([dic[@"youxi_id"] isEqualToString:kkGameID]) {
            [resultArr removeObject:dic];
            break;
        }
//        youxi_name
//        youxi_tubiao
    }
    
    if (resultArr ==nil) {
        resultArr = [NSMutableArray array];
    }

    [self kkAddListGameRecentlyUsedWriteToPlist:resultArr];
    
}

//读取游戏最近使用数据
+ (NSMutableArray *)kkReadGameRecentlyUsedListFromPlist{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    KKLog(@"读取数据地址%@",path);
    
    NSString *fileName = [path stringByAppendingPathComponent:@"GameRecentlyUsedList.plist"];
    //反序列化，把plist文件数据读取出来，转为数组
//    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
   NSMutableArray *result = [NSMutableArray arrayWithContentsOfFile:fileName];
    KKLog(@"%@", result);
   NSMutableArray * kkresult = [NSMutableArray arrayWithArray:result];

    return kkresult;
}


//=====================================================================


//游戏最近使用 写入数据到plist
+ (void)kkGameRecentlyUsedWriteToPlist:(NSMutableArray *)array{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    KKLog(@"写入数据地址%@",path);
    
    NSString *fileName = [path stringByAppendingPathComponent:@"GameRecentlyUsed.plist"];
    
   BOOL kkIsWrite = [array writeToFile:fileName atomically:YES];
    if (kkIsWrite) {
        KKLog(@"写入成功");
    }else{
        KKLog(@"写入失败");
    }
}
//从plist读取 游戏最近使用数据
+ (NSArray *)kkReadGameRecentlyUsedFromPlist{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    KKLog(@"读取数据地址%@",path);
    
    NSString *fileName = [path stringByAppendingPathComponent:@"GameRecentlyUsed.plist"];
    //反序列化，把plist文件数据读取出来，转为数组
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    KKLog(@"%@", result);
    return result;
}

@end
