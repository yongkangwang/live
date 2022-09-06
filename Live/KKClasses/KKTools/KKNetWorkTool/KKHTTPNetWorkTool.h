//
//  KKHTTPNetWorkTool.h
//  yunbaolive
//
//  Created by Peter on 2019/12/14.
//  Copyright © 2019 cat. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>


///网络请求方法
typedef NS_ENUM (NSUInteger, KKHttpRequestType){
    
    KKHttpRequestTypeGET,
    KKHttpRequestTypePOST,
    KKHttpRequestTypeHEAD
    
};

///下载文件保存路径
typedef NS_ENUM(NSUInteger, KKDownloadDataPathType){
    
    KKDownloadDataPathTypCache,
    KKDownloadDataPathTypeDocument,
    KKDownloadDataPathTypTemp
    
};

///请求成功后的回调
typedef void(^SuccessBlock)(id _Nullable response);
///请求失败后的回调
typedef void(^FailureBlock)(NSError  * _Nullable error);
///下载数据的进度
typedef void(^DownloadProgressBlock)(NSProgress * _Nonnull downloadProgress);
///上传数据的进度
typedef void(^UploadProgressBlock)(NSProgress * _Nonnull uploadProgress);



@interface KKHTTPNetWorkTool : AFHTTPSessionManager

///查看网络状态
@property(assign,nonatomic)AFNetworkReachabilityStatus networkStatus;

///单例网络请求管理者
+(nullable instancetype)sharedManager;

///从网络服务器上获取数据
/*
 httpRequestType : 请求方式
 urlString : 拼接urlString
 parameters : 请求字典参数
 downloadProgressBlock : 下载进度block
 successBlock : 请求成功后的block
 failureBlock : 请求失败后的block
 mainView : hud要添加到的mainView
 */
-(void)kk_loadDataFromNetWorkWithHttpRequestType:(KKHttpRequestType)httpRequestType urlString:( NSString * _Nonnull )urlString parameters:(NSDictionary *_Nullable )parameters progressBlock:(_Nullable DownloadProgressBlock)downloadProgressBlock successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


///上传文件到网络服务器
/*
 请求方式为POST
 urlString : 拼接urlString
 parameters : 请求字典参数
 fileDataArray : 存放上传文件的数组(这里目前只支持jpeg和png图片)
 serverName : 要上传到服务器的字段(不包括[])
 fileName : 命名文件名
 mimeType : @"image/jpeg" 和 @"image/png"两种
 uploadProgressBlock : 上传进度block
 successBlock : 请求成功后的block
 failureBlock : 请求失败后的block
 mainView : hud要添加到的mainView
 */
-(void)kk_upLoadDataToNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters fileDataArray:(nullable NSArray *)fileDataArray serverName:(nonnull NSString *)serverName fileName:(nonnull NSString *)fileName mimeType:(nonnull NSString *)mimeType progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;



///上传图片和视频文件到网络服务器
/*
 请求方式为POST
 urlString : 拼接urlString
 parameters : 请求字典参数
 imageFileDataArray : 存放上传文件的数组(这里目前只支持jpeg和png图片)
 imageServerName : 要上传到服务器的字段(不包括[])
 imageFileName : 命名文件名
 imageMimeType : @"image/jpeg" 和 @"image/png"两种

 videoFilePathArray : 存放上传文件本地路径的数组(这里目前只支持mp4)
 videoServerName : 要上传到服务器的字段(不包括[])
 videoFileName : 命名文件名
 videoMimeType : @"video/mp4"

 uploadProgressBlock : 上传进度block
 successBlock : 请求成功后的block
 failureBlock : 请求失败后的block
 mainView : hud要添加到的mainView
 */
-(void)kk_upLoadDataImageAndVideoToNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters imageFileDataArray:(nullable NSArray *)imageFileDataArray imageServerName:(nonnull NSString *)imageServerName imageFileName:(nonnull NSString *)imageFileName imageMimeType:(nonnull NSString *)imageMimeType andVideoFilePathArray:(nullable NSArray *)videoFilePathArray videoServerName:(nonnull NSString *)videoServerName videoFileName:(nonnull NSString *)videoFileName videoMimeType:(nonnull NSString *)videoMimeType  progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;



///上传文件到网络服务器
/*
 请求方式为POST
 urlString : 拼接urlString
 parameters : 请求字典参数
 fileDataArray : 存放上传文件的数组(这里目前只支持jpeg和png图片)
 serverName : 要上传到服务器的字段(不包括[])
 fileName : 命名文件名
 mimeType : @"image/jpeg" 和 @"image/png"两种
 
 OriginalFilePathArray : 存放上传文件本地路径的数组(这里目前只支持jpeg和png图片)
OriginalServerName : 要上传到服务器的字段(不包括[])
OriginalFileName : 命名文件名
 OriginalMimeType : @"image/jpeg" 和 @"image/png"两种

 uploadProgressBlock : 上传进度block
 successBlock : 请求成功后的block
 failureBlock : 请求失败后的block
 mainView : hud要添加到的mainView
 */
-(void)kk_upLoadDataToTwoSeverNameNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters fileDataArray:(nullable NSArray *)fileDataArray serverName:(nonnull NSString *)serverName fileName:(nonnull NSString *)fileName mimeType:(nonnull NSString *)mimeType  andOriginalFilePathArray:(nullable NSArray *)OriginalFilePathArray OriginalServerName:(nonnull NSString *)OriginalServerName OriginalFileName:(nonnull NSString *)OriginalFileName OriginalMimeType:(nonnull NSString *)OriginalMimeType progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

@end

