//
//  KKHTTPNetWorkTool.m
//  yunbaolive
//
//  Created by Peter on 2019/12/14.
//  Copyright © 2019 cat. All rights reserved.
//

#import "KKHTTPNetWorkTool.h"
#import "GiFHUD.h"
//#import "AFNetworkActivityIndicatorManager.h"

#import "KKNoNetworkAlertView.h"

///请求头字典
static NSDictionary *lsd_httpHeaders = nil;
///超时时间
static NSTimeInterval lsd_timeout = 0.0;

@interface KKHTTPNetWorkTool ()


///下载管理者
@property(strong,nonatomic)AFURLSessionManager *downloadManager;
///下载队列
@property(strong,nonatomic)NSOperationQueue *downloadOperationQueue;

@property(strong,nonatomic)NSURLSession *downLoadSession;

@property(strong,nonatomic)NSData *resumeData;
///下载任务
@property(strong,nonatomic)NSURLSessionDownloadTask *downloadTask;

@property(weak,nonatomic)KKNoNetworkAlertView *kkNoNetworkV;
///debug打印开关
@property (nonatomic,assign) BOOL debug;


@end

@implementation KKHTTPNetWorkTool

static NSString *_baseUrlString = nil;
static KKHTTPNetWorkTool *_instance = nil;


#pragma mark -- 单例对象
+(instancetype)sharedManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc]initWithBaseURL:[NSURL URLWithString:_baseUrlString]];
    
            ///设置请求头
            for (NSString *key in lsd_httpHeaders.allKeys) {
                if (lsd_httpHeaders[key] != nil) {
                    [_instance.requestSerializer setValue:lsd_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            //加了这两句开屏广告就需要客户端编码解析,不加这两句进入直播房间的接口好像不行
//            _instance.requestSerializer = [AFHTTPRequestSerializer serializer];
            _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
//            _instance.responseSerializer = [AFJSONResponseSerializer serializer];加上这个开屏广告OK，但是直播间进入后台返回 code=3840

            _instance.responseSerializer.acceptableContentTypes =
             [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"application/xml", @"text/xml",@"image/*",nil];
            
            //无条件的信任服务器上的证书
//            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
            // 客户端是否信任非法证书
//            securityPolicy.allowInvalidCertificates = YES;
            // 是否在证书域字段中验证域名
//            securityPolicy.validatesDomainName = NO;
        
//            _instance.securityPolicy = securityPolicy;
//            [_instance kkMonitorNetworking];//2.7.7
            
            if (lsd_timeout) {
                _instance.requestSerializer.timeoutInterval = lsd_timeout;
            }else
            {
                _instance.requestSerializer.timeoutInterval = 50.0;
            }
            
            _instance.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
//            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        }
    });
    return _instance;
}


#pragma mark -- 从网络服务器上获取数据
-(void)kk_loadDataFromNetWorkWithHttpRequestType:(KKHttpRequestType)httpRequestType urlString:( NSString * _Nonnull )urlString parameters:(NSDictionary *)parameters progressBlock:(_Nullable DownloadProgressBlock)downloadProgressBlock successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(UIView *)mainView
{
    NSMutableDictionary *kkpDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([KKChatConfig getOwnID]),@"uid",minstr([KKChatConfig getOwnToken]),@"token", nil];

    [kkpDic addEntriesFromDictionary:parameters];
    WeakSelf;
    MBProgressHUD *hud = [weakSelf hudWithmainView:mainView];

    if (httpRequestType == KKHttpRequestTypeGET) {
        
        if (weakSelf.debug) {
//            LSDLog(@"\nmethod:GET \nurl = %@, \nparameters = \n%@",urlString,parameters);
        }
        _instance.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        
        
        [_instance GET:urlString parameters:kkpDic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            if (downloadProgressBlock) {
                downloadProgressBlock(downloadProgress);
            }

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
                if (weakSelf.debug) {
    //                LSDLog(@"\nsuccess: \nresponse = \n%@",responseObject);
                }
                
            [self kkHudHide:hud];

                if (successBlock) {
                    NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    //开屏广告能解析，登录接口无法解析
                    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
                    if (expression) {
                        NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                        if (!result) {
                        }
                    }
                    
                    NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
                    
                    if ([jsondic[@"status"] integerValue] == 700) {
                        [[YBToolClass sharedInstance] quitLogin];
                        [MBProgressHUD kkshowMessage:jsondic[@"cont"]];
                    }else{
                        successBlock(jsondic);
                    }

                }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NSString kkChangeNetworkURL];
            if (weakSelf.debug) {
//                LSDLog(@"\nfailure: \nerror = \n%@",error);
            }
            [self kkHudHide:hud];

            if (failureBlock) {
                failureBlock(error);
            }
            [weakSelf kkNoNetWork:error];
        }];
        
    }
    else if (httpRequestType == KKHttpRequestTypePOST){
        
        
        if (weakSelf.debug) {
//            LSDLog(@"\nmethod:POST \nurl = %@,\nparameters = \n%@",urlString,parameters);
        }
        
        [_instance POST:urlString parameters:kkpDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            if (downloadProgressBlock) {
                downloadProgressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            [weakSelf kkHudHide:hud];

                if (weakSelf.debug) {
    //                LSDLog(@"\nsuccess: \nresponse = \n%@",responseObject);
                }
                
                if (successBlock) {
                    
                    NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                    //开屏广告能解析，登录接口无法解析
                    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
                    if (expression) {
                        NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                        if (!result) {
                        }
                    }
                    NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
    //                NSNumber *number = [jsondic valueForKey:@"ret"];
                    //
                    if ([jsondic[@"status"] integerValue] == 700) {
                        [[YBToolClass sharedInstance] quitLogin];
                        [MBProgressHUD kkshowMessage:jsondic[@"cont"]];

                    }else{
                        successBlock(jsondic);
                    }

                }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NSString kkChangeNetworkURL];

            if (weakSelf.debug) {
//                LSDLog(@"\nfailure: \nerror = \n%@",error);   
            }
            [weakSelf kkHudHide:hud];

            if (failureBlock) {
                failureBlock(error);
            }
            [weakSelf kkNoNetWork:error];

        }];
        
        
    }
    else if(httpRequestType == KKHttpRequestTypeHEAD){
        
        if (weakSelf.debug) {
//            LSDLog(@"\nmethod:HEAD \nurl = %@,\nparameters = \n%@",urlString,parameters);
        }
        
        [_instance HEAD:urlString parameters:kkpDic headers:nil success:^(NSURLSessionDataTask * _Nonnull task) {
            
            [weakSelf kkHudHide:hud];
            if (weakSelf.debug) {
//                LSDLog(@"\nsuccess: \ntask = \n%@",task);
            }
            
            if (successBlock) {
                successBlock(task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NSString kkChangeNetworkURL];

            [self kkHudHide:hud];

            if (weakSelf.debug) {
//                LSDLog(@"\nfailure: \nerror = \n%@",error);
            }
            
            if (failureBlock) {
                failureBlock(error);
            }
            [self kkNoNetWork:error];

        }];
        
    }
    
}


- (void)kkNoNetWork:(NSError *)error
{
//    NSLog(@"%@    看点击发送了打开 %zd",error,error.code);
    if (error.code != -1020) {
        return;
    }
    if (self.kkNoNetworkV) {
        return;
    }
    if ([[KKUserDefaults valueForKey:@"KKNoNetworkViewController"] boolValue]) {
        return;
    }
    KKNoNetworkAlertView *kkalert = [[KKNoNetworkAlertView alloc]init];
    [kkalert kkShow];
    self.kkNoNetworkV = kkalert;
    
    return;//弹出视图有问题
    
//    Code=-1020 "目前不允许数据连接
    if (error.code != -1020) {
        return;
    }
    NSLog(@"%@    看点击发送了打开 %zd",error,error.code);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:@"数据网络权限未授权！请在系统设置中开启网路权限！" preferredStyle:UIAlertControllerStyleAlert];
    //添加一个取消按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self kkOpenJurisdiction];
    }]];
    
   [[MXBADelegate sharedAppDelegate] presentViewController:alert animated:YES completion:nil];

}

-(void)kkOpenJurisdiction
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}
#pragma mark -- 上传图片到服务器上(支持多张上传)
-(void)kk_upLoadDataToNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters fileDataArray:(nullable NSArray *)fileDataArray serverName:(nonnull NSString *)serverName fileName:(nonnull NSString *)fileName mimeType:(nonnull NSString *)mimeType progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(UIView *)mainView
{
    
    // 获取转圈控件
    MBProgressHUD *hud = [self hudWithmainView:mainView];
    [_instance POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableArray *muArray = [NSMutableArray array];
        NSString *imageSuff = nil;
        
        if ([mimeType isEqualToString:@"image/jpeg"])
        {
            imageSuff = @".jpg";
            
            for (UIImage  *image in fileDataArray) {
                
                NSData *data =  UIImageJPEGRepresentation(image, kkImageCompress);
                [muArray addObject:data];
                
            }
            
        }else if([mimeType isEqualToString:@"image/png"])
        {
            imageSuff = @".png";
            
            for (UIImage  *image in fileDataArray) {
                
                NSData *data = UIImagePNGRepresentation(image);
                [muArray addObject:data];
                
            }
            
        }
        
        if (muArray.count == 1) {
            if ([mimeType isEqualToString:@"image/jpeg"])
            {
                [formData appendPartWithFileData:[muArray objectAtIndex:0] name:serverName fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:mimeType];
                
            }else if([mimeType isEqualToString:@"image/png"])
            {
              [formData appendPartWithFileData:[muArray objectAtIndex:0] name:serverName fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:mimeType];
//                [formData appendPartWithFormData:[muArray objectAtIndex:0] name:[NSString stringWithFormat:@"%@.png",fileName]];
            }
           
        }else{
            for (int i = 0; i < muArray.count ; i ++)
            {
                [formData appendPartWithFileData:[muArray objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]",serverName,i] fileName:[NSString stringWithFormat:@"%@%d%@",fileName,i,imageSuff] mimeType:mimeType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self kkHudHide:hud];

            NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
            if (expression) {
                NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                if (!result) {
                }
            }
            NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];

            if (successBlock) {
                successBlock(jsondic);
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self kkHudHide:hud];

        if (failureBlock) {
          failureBlock(error);
      }

    }];
    
}


#pragma mark -- MBProgressHUD的使用

- (void)kkHudHide:(MBProgressHUD *)hud
{
    if (hud) {
        [hud hideAnimated:YES];
    }
}
- (MBProgressHUD *)hudWithmainView:(UIView *)mainView{
    
    if (mainView == nil) {
        return  nil;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainView animated:YES];
    return hud;

}

- (void)kkHideDengHUDForView:(UIView *)mainView
{
    if (mainView) {
        [MBProgressHUD kk_hideDengHUDForView:mainView animated:YES];
    }
}
- (void)kkhudWithmainView:(UIView *)mainView
{
    if (mainView == nil) {
        return ;
    }
    [MBProgressHUD kk_showDengHUDAddedTo:mainView animated:YES];
}

#pragma mark -- 上传图片和视频到服务器上(支持多文件上传)
-(void)kk_upLoadDataImageAndVideoToNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters imageFileDataArray:(nullable NSArray *)imageFileDataArray imageServerName:(nonnull NSString *)imageServerName imageFileName:(nonnull NSString *)imageFileName imageMimeType:(nonnull NSString *)imageMimeType andVideoFilePathArray:(nullable NSArray *)videoFilePathArray videoServerName:(nonnull NSString *)videoServerName videoFileName:(nonnull NSString *)videoFileName videoMimeType:(nonnull NSString *)videoMimeType  progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    // 获取转圈控件
    MBProgressHUD *hud = [self hudWithmainView:mainView];

    [_instance POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            NSString *OriginalMimeType = parameters[@"imageTypeOriginal"];
            NSArray *OriginalFileDataArray = parameters[@"filey"];
            NSString *OriginalServerName = @"filey";
            NSString *OriginalFileName = parameters[@"OriginalImageName"];

            
            NSMutableArray *OriginalmuArray = [NSMutableArray array];
                    NSString *OriginalImageSuff = nil;
                    
                    if ([OriginalMimeType isEqualToString:@"image/jpeg"])
                    {
                        OriginalImageSuff = @".jpg";
                        
                        for (UIImage  *imageOriginal in OriginalFileDataArray) {
                            
                            NSData *dataOriginal =  UIImageJPEGRepresentation(imageOriginal, kkImageCompress);
                            [OriginalmuArray addObject:dataOriginal];
                            
                        }
                        
                    }else if([OriginalMimeType isEqualToString:@"image/png"])
                    {
                        OriginalImageSuff = @".png";
                        
                        for (UIImage  *imageOriginal in OriginalFileDataArray) {
                            
                            NSData *dataOriginal = UIImagePNGRepresentation(imageOriginal);
                            [OriginalmuArray addObject:dataOriginal];
                            
                        }
                        
                    }
                    
                    if (OriginalmuArray.count == 1) {
                        if ([OriginalMimeType isEqualToString:@"image/jpeg"])
                        {
                            [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:0] name:OriginalServerName fileName:[NSString stringWithFormat:@"%@.jpg",OriginalFileName] mimeType:OriginalMimeType];
                            
                        }else if([OriginalMimeType isEqualToString:@"image/png"])
                        {
                          [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:0] name:OriginalServerName fileName:[NSString stringWithFormat:@"%@.png",OriginalFileName] mimeType:OriginalMimeType];
                        }
                       
                    }else{
                        for (int i = 0; i < OriginalmuArray.count ; i ++)
                        {
                            [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]",OriginalServerName,i] fileName:[NSString stringWithFormat:@"%@%d%@",OriginalFileName,i,OriginalImageSuff] mimeType:OriginalMimeType];
                        }
                    }

            
            
            //kk六道图片
            NSMutableArray *imageMuArray = [NSMutableArray array];
            NSString *imageSuff = nil;
            
            if ([imageMimeType isEqualToString:@"image/jpeg"])
            {
                imageSuff = @".jpg";
                for (UIImage  *image in imageFileDataArray) {
                    NSData *data =  UIImageJPEGRepresentation(image, kkImageCompress);
                    [imageMuArray addObject:data];
                }
            }else if([imageMimeType isEqualToString:@"image/png"])
            {
                imageSuff = @".png";
                for (UIImage  *image in imageFileDataArray) {
                    NSData *data = UIImagePNGRepresentation(image);
                    [imageMuArray addObject:data];
                }

            }
            if (imageMuArray.count == 1) {
                if ([imageMimeType isEqualToString:@"image/jpeg"])
                {
                    [formData appendPartWithFileData:[imageMuArray objectAtIndex:0] name:imageServerName fileName:[NSString stringWithFormat:@"%@.jpg",imageFileName] mimeType:imageMimeType];
                }else if([imageMimeType isEqualToString:@"image/png"])
                {
                  [formData appendPartWithFileData:[imageMuArray objectAtIndex:0] name:imageServerName fileName:[NSString stringWithFormat:@"%@.png",imageFileName] mimeType:imageMimeType];
                }
            }else{
                for (int i = 0; i < imageMuArray.count ; i ++)
                {
                    [formData appendPartWithFileData:[imageMuArray objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]",imageServerName,i] fileName:[NSString stringWithFormat:@"%@%d%@",imageFileName,i,imageSuff] mimeType:imageMimeType];
                }
            }
            
            //kk六道视频
            NSMutableArray *kkVideoMuArray = [NSMutableArray array];
            NSString *kkVideoSuff = nil;
            if ([videoMimeType isEqualToString:@"video/mp4"])
               {
                   kkVideoSuff = @".mp4";
                   for (NSString  *videoPathStr in videoFilePathArray) {
                       [kkVideoMuArray addObject:videoPathStr];
                   }
    //               for (NSData  *videoData in videoFilePathArray) {
    //                   [kkVideoMuArray addObject:videoData];
    //               }

               }
            if (kkVideoMuArray.count == 1) {
                   if ([videoMimeType isEqualToString:@"video/mp4"])
                   {
                       NSURL *kkurl =[NSURL fileURLWithPath:kkVideoMuArray.lastObject];

    //                   NSURL *kkurl =[NSURL fileURLWithPath:parameters[@"kkvideoPath"]];
                       NSError *kkError;
                       BOOL kkSuccess = [formData appendPartWithFileURL:kkurl name:videoServerName fileName:[NSString stringWithFormat:@"%@.mp4",videoFileName] mimeType:videoMimeType error:&kkError];

                       if (!kkSuccess) {
                           NSLog(@"appendPartWithFileURL error: %@", kkError);
                       }
                   }
               }else{
                   for (int i = 0; i < kkVideoMuArray.count ; i ++)
                   {
                       NSError *kkError;
                       BOOL kkSuccess = [formData appendPartWithFileURL:[NSURL fileURLWithPath:kkVideoMuArray[i]] name:videoServerName fileName:[NSString stringWithFormat:@"%@%d%@",videoFileName,i,kkVideoSuff] mimeType:videoMimeType error:&kkError];
                       if (!kkSuccess) {
                           NSLog(@"appendPartWithFileURL error: %@", kkError);
                       }
                   }
               }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                [self kkHudHide:hud];
                NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
                if (expression) {
                    NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                    if (!result) {
                    }
                }
                NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];

                if (successBlock) {
                    successBlock(jsondic);
                }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self kkHudHide:hud];

      if (failureBlock) {
          failureBlock(error);
      }
    }];
    
}



-(void)kk_upLoadDataToTwoSeverNameNetWorkWithUrlString:(nonnull NSString *)urlString parameters:(nullable id)parameters fileDataArray:(nullable NSArray *)fileDataArray serverName:(nonnull NSString *)serverName fileName:(nonnull NSString *)fileName mimeType:(nonnull NSString *)mimeType  andOriginalFilePathArray:(nullable NSArray *)OriginalFileDataArray OriginalServerName:(nonnull NSString *)OriginalServerName OriginalFileName:(nonnull NSString *)OriginalFileName OriginalMimeType:(nonnull NSString *)OriginalMimeType progress:(nullable UploadProgressBlock)uploadProgressBlock successBlock:(nullable SuccessBlock)successBlock failureBlock:(nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
     // 获取转圈控件
        [self kkhudWithmainView:mainView];
    [_instance POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSMutableArray *muArray = [NSMutableArray array];
        NSString *imageSuff = nil;
        
        if ([mimeType isEqualToString:@"image/jpeg"])
        {
            imageSuff = @".jpg";
            
            for (UIImage  *image in fileDataArray) {
                
                NSData *data =  UIImageJPEGRepresentation(image, kkImageCompress);
                [muArray addObject:data];
                
            }
            
        }else if([mimeType isEqualToString:@"image/png"])
        {
            imageSuff = @".png";
            
            for (UIImage  *image in fileDataArray) {
                
                NSData *data = UIImagePNGRepresentation(image);
                [muArray addObject:data];
                
            }
            
        }
        
        if (muArray.count == 1) {
            if ([mimeType isEqualToString:@"image/jpeg"])
            {
                [formData appendPartWithFileData:[muArray objectAtIndex:0] name:serverName fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:mimeType];
                
            }else if([mimeType isEqualToString:@"image/png"])
            {
              [formData appendPartWithFileData:[muArray objectAtIndex:0] name:serverName fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:mimeType];
//                [formData appendPartWithFormData:[muArray objectAtIndex:0] name:[NSString stringWithFormat:@"%@.png",fileName]];
            }
           
        }else{
            for (int i = 0; i < muArray.count ; i ++)
            {
                [formData appendPartWithFileData:[muArray objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]",serverName,i] fileName:[NSString stringWithFormat:@"%@%d%@",fileName,i,imageSuff] mimeType:mimeType];
            }
        }
        
        
        
        NSMutableArray *OriginalmuArray = [NSMutableArray array];
                NSString *OriginalImageSuff = nil;
                
                if ([OriginalMimeType isEqualToString:@"image/jpeg"])
                {
                    OriginalImageSuff = @".jpg";
                    
                    for (UIImage  *imageOriginal in OriginalFileDataArray) {
                        
                        NSData *dataOriginal =  UIImageJPEGRepresentation(imageOriginal, kkImageCompress);
                        [OriginalmuArray addObject:dataOriginal];
                        
                    }
                    
                }else if([OriginalMimeType isEqualToString:@"image/png"])
                {
                    OriginalImageSuff = @".png";
                    
                    for (UIImage  *imageOriginal in OriginalFileDataArray) {
                        
                        NSData *dataOriginal = UIImagePNGRepresentation(imageOriginal);
                        [OriginalmuArray addObject:dataOriginal];
                        
                    }
                    
                }
                
                if (OriginalmuArray.count == 1) {
                    if ([OriginalMimeType isEqualToString:@"image/jpeg"])
                    {
                        [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:0] name:OriginalServerName fileName:[NSString stringWithFormat:@"%@.jpg",OriginalFileName] mimeType:OriginalMimeType];
                        
                    }else if([OriginalMimeType isEqualToString:@"image/png"])
                    {
                      [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:0] name:OriginalServerName fileName:[NSString stringWithFormat:@"%@.png",OriginalFileName] mimeType:OriginalMimeType];
        //                [formData appendPartWithFormData:[muArray objectAtIndex:0] name:[NSString stringWithFormat:@"%@.png",fileName]];
                    }
                   
                }else{
                    for (int i = 0; i < OriginalmuArray.count ; i ++)
                    {
                        [formData appendPartWithFileData:[OriginalmuArray objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]",OriginalServerName,i] fileName:[NSString stringWithFormat:@"%@%d%@",OriginalFileName,i,OriginalImageSuff] mimeType:OriginalMimeType];
                    }
                }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self kkHideDengHUDForView:mainView];

        NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //开屏广告能解析，登录接口无法解析
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
        if (expression) {
            NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
            if (!result) {
            }
        }
        NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];

        if (successBlock) {
            successBlock(jsondic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self kkHideDengHUDForView:mainView];

        if (failureBlock) {
            failureBlock(error);
        }

    }];
    
}


@end
