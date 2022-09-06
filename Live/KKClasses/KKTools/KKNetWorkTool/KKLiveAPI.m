//
//  KKLiveAPI.m
//  yunbaolive
//
//  Created by Peter on 2019/12/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import "KKLiveAPI.h"

//关注的直播中的主播
#define KKPostLiveAttentionInfoAPI @""


////直播间在线人员
#define KKGetLiveUserOnlineInfoAPI @""

//首页直播
#define KKPostHomeLiveInfoAPI @""

// 获取视频链接
#define KKPostVideoURLInfoAPI @""

// TRTC房间一起看视频列表
#define KKPostTRTCVideoListInfoAPI @""

//检查直播房间
#define KKPostCheckLiveInfoAPI @""

//搜索音乐
#define KKGetMusicInfoAPI @""

// // 一键打招呼
#define KKPostHelloInfoAPI @""

// 竞技分类获
#define KKSportsClassInfoAPI @""

// 游戏试玩
#define KKGameTryToPlayInfoAPI @""

// 游戏类型下的列表数据
#define KKGetLiveGameListInfoAPI @""

// 开始花币转换
#define KKPostLiveGameStartConversionMoneyInfoAPI @""

// 花币转换信息展示
#define KKPostLiveGameConversionMoneyInfoAPI @""

// 游戏分类列表
#define KKPostLiveGameClassListInfoAPI @""

// 游戏评论
#define KKPostLiveGameSendCommentInfoAPI @""

// 游戏评论列表
#define KKPostLiveGameCommentInfoAPI @""

//游戏收藏
#define KKPostLiveGameCollectInfoAPI @""

//游戏详情
#define KKPostLiveGameDetailsInfoAPI @""

//游戏list
#define KKPostLiveGameListInfoAPI @""

// 首页轮播、游戏 热门数据
#define KKPostLiveTopInfoAPI @""

// 娱乐
#define KKPost1v1AmusementInfoAPI @""

//用户背包
#define PostUserKnapsackInfoAPI @""

//首页新开数据
#define GetNewStartListInfoAPI @""

//请求用户观看的直播间 底部数据
#define PostLiveBroadcastRoomBottomAPI @""

//请求用户观看的直播间 底部数据
#define PostLiveRoomBottomAPI @""

//复制分享的链接接口
#define PostCompanyURLImageAPI @""
//创建直播间接口
#define PostCreateLiveRoomAPI @""
//复制分享的链接接口
#define PostShearURLInfo @""
//首页轮播图
#define KKGetLiveTopViewInfo @""
//进入房间需要调用的接口，里边有用户的全部信息，还有socket链接地址
#define KKPlayRoomApi @""
//直播间内主播肉票榜API
#define KKGetLiveRankListInfoApi @""
//关闭直播
#define KKGetLiveStopRoomInfoApi @""

//首页列表数据
#define KKGetLiveListInfoApi @""


@implementation KKLiveAPI

//关注的正在开播的主播
+ (void)kk_PostLiveAttentionInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveAttentionInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}


//直播间在线人员
+ (void)kk_GetLiveUserOnlineInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",KKGetLiveUserOnlineInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

//首页直播
+ (void)kk_PostHomeLiveInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostHomeLiveInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}


//发送弹幕
+ (void)kk_PostSendBarrageIDInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.sendBarrage"];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:url parameters:[NSDictionary dictionary] progressBlock:nil successBlock:^(id  _Nullable response) {
            if (successBlock) {
                successBlock(response);
            }
       } failureBlock:^(NSError * _Nullable error) {
           if (failureBlock) {
               failureBlock(error);
           }
       } mainView:mainView];
    
}

//  发红包
+ (void)kk_GetRedEnvelopeInfoURL:(NSString *)url successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{

    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:url parameters:[NSDictionary dictionary] progressBlock:nil successBlock:^(id  _Nullable response) {
           if ([response[@"ret"] integerValue] == 200) {
               if (successBlock) {
                   successBlock(response[@"data"]);
               }
           }else{
               [MBProgressHUD showError:response[@"msg"]];
           }
       } failureBlock:^(NSError * _Nullable error) {
           if (failureBlock) {
               failureBlock(error);
           }
       } mainView:mainView];

}


// 解析视频链接
+ (void)kk_PostVideoURLInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostVideoURLInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}


// TRTC房间一起看视频列表
+ (void)kk_PostTRTCVideoListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostTRTCVideoListInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

// 检查直播间
+ (void)kk_PostCheckLiveInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",KKPostCheckLiveInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}


// 搜索音乐
+ (void)kk_GetMusicInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [purl stringByAppendingFormat:@"/?service=%@",KKGetMusicInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

// 一键打招呼
+ (void)kk_PostHelloInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostHelloInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}


// 竞技分类获取
+ (void)kk_PostSportsClassInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKSportsClassInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}


// 游戏试玩
+ (void)kk_PostGameTryToPlayInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKGameTryToPlayInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

// 游戏类型下的列表数据
+ (void)kk_GetLiveGameListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKGetLiveGameListInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}


// 开始花币转换
+ (void)kk_PostLiveGameStartConversionMoneyInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameStartConversionMoneyInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}

// 花币转换信息展示
+ (void)kk_PostLiveGameConversionMoneyInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameConversionMoneyInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}

// 游戏分类列表
+ (void)kk_GetLiveGameClassListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameClassListInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}


// 游戏评论
+ (void)kk_PostLiveGameSendCommentInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameSendCommentInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

// 游戏评论列表
+ (void)kk_GetLiveGameCommentInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameCommentInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}

// 游戏收藏
+ (void)kk_PostLiveGameCollectInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameCollectInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              if ([response[@"status"] integerValue] == 1) {
                  if (successBlock) {
                          successBlock(response);
                      }
              }else{
                  [MBProgressHUD kkshowMessage:response[@"cont"]];
              }

          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];
}
// 游戏详情数据
+ (void)kk_PostLiveGameDetailsInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameDetailsInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              if (successBlock) {
                      successBlock(response);
                  }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}


// 游戏list数据
+ (void)kk_PostLiveGameListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveGameListInfoAPI];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              if (successBlock) {
                      successBlock(response);
                  }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}

// 首页轮播、游戏 热门数据
+ (void)kk_PostLiveTopInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
        NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPostLiveTopInfoAPI];
              [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
                  if (successBlock) {
                          successBlock(response);
                      }
              } failureBlock:^(NSError * _Nullable error) {
                  if (failureBlock) {
                      failureBlock(error);
                  }
              } mainView:mainView];

}


// 娱乐
+ (void)kk_PostAmusementInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKPost1v1AmusementInfoAPI];
//     urlString  = [urlString stringByAppendingFormat:@"?uid=%@&token=%@",parameters[@"uid"],parameters[@"token"]];
          [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              if (successBlock) {
                      successBlock(response);
                  }
          } failureBlock:^(NSError * _Nullable error) {
              if (failureBlock) {
                  failureBlock(error);
              }
          } mainView:mainView];

}


//用户背包
+ (void)kk_PostUserKnapsackListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",PostUserKnapsackInfoAPI];
      [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
          if (successBlock) {
                  successBlock(response);
              }
      } failureBlock:^(NSError * _Nullable error) {
          if (failureBlock) {
              failureBlock(error);
          }
      } mainView:mainView];

}


//首页新开数据
+ (void)kk_GetNewStartListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",GetNewStartListInfoAPI];
      [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
          if (successBlock) {
                  successBlock(response);
              }
      } failureBlock:^(NSError * _Nullable error) {
          if (failureBlock) {
              failureBlock(error);
          }
      } mainView:mainView];
}

//开播直播间 底部数据
+ (void)kk_PostLiveBroadcastRoomBottomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",PostLiveBroadcastRoomBottomAPI];
      [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
         
          if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
          if (successBlock) {
                  successBlock(response);
              }
          }else{
          }
      } failureBlock:^(NSError * _Nullable error) {
          if (failureBlock) {
              failureBlock(error);
          }
      } mainView:mainView];
}


//请求用户观看的直播间 底部数据
+ (void)kk_PostLiveRoomBottomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",PostLiveRoomBottomAPI];
      [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
         
          if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
          if (successBlock) {
                  successBlock(response);
              }
          }else{
          }
      } failureBlock:^(NSError * _Nullable error) {
          if (failureBlock) {
              failureBlock(error);
          }
      } mainView:mainView];
}


//请求公司网址水印图片
+ (void)kk_PostCompanyURLImageInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
        NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",PostCompanyURLImageAPI];
           [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              
               if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
               if (successBlock) {
                       successBlock(response);
                   }
               }else{
               }
           } failureBlock:^(NSError * _Nullable error) {
               if (failureBlock) {
                   failureBlock(error);
               }
           } mainView:mainView];
}


//直播间列表数据
+ (void)kk_PostLiveRoomListInfoApiURL:(NSString *)kkURL Withparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",kkURL];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
       
//        if ([response[@"ret"] integerValue] == 200) {//200表示服务器正常返回
        if (successBlock) {
            if (successBlock) {
                successBlock(response);
            }

//            NSDictionary *dataDic = response[@"data"];
//            NSArray *infoArr = dataDic[@"info"];
//                successBlock(infoArr.lastObject);
            }
//        }else{
//            if (successBlock) {
//                successBlock(response);
//            }
//
//        }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } mainView:mainView];

}


//创建直播间接口
+ (void)kk_PostCreateLiveRoomInfoURL:(NSString *)parametStr Withparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",PostCreateLiveRoomAPI];

    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
              
               if ([response[@"ret"] integerValue] == 200) {//1表示服务器正常返回
               if (successBlock) {
                       successBlock(response[@"data"]);
                   }
               }else{
                   if (response[@"msg"]) {
                       [MBProgressHUD kkshowMessage:response[@"msg"]];
                   }
               }
           } failureBlock:^(NSError * _Nullable error) {
               if (failureBlock) {
                   failureBlock(error);
               }
           } mainView:mainView];

}


//复制分享的链接接口
+ (void)kk_PostShearURLInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",PostShearURLInfo];
       [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
          
           if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
           if (successBlock) {
                   successBlock(response);
               }
           }else{
//               if (response[@"cont"]) {
//                   [MBProgressHUD showMessage:response[@"cont"]];
//               }
           }
       } failureBlock:^(NSError * _Nullable error) {
           if (failureBlock) {
               failureBlock(error);
           }
       } mainView:mainView];

}


//首页轮播图
+ (void)kk_GetLiveTopViewInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl2 stringByAppendingFormat:@"%@",KKGetLiveTopViewInfo];
       [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
          
           if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
           if (successBlock) {
                   successBlock(response);
               }
           }else{
               if (response[@"cont"]) {
                   [MBProgressHUD showMessage:response[@"cont"]];
               }
           }
       } failureBlock:^(NSError * _Nullable error) {
           if (failureBlock) {
               failureBlock(error);
           }
       } mainView:mainView];
}

//首页列表数据
+ (void)kk_getLiveListInfoApiWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",KKGetLiveListInfoApi];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
            if (successBlock) {
               successBlock(response);
            }
//        if ([response[@"ret"] integerValue] == 200) {//200表示服务器正常返回
//        if (successBlock) {
//            NSDictionary *dataDic = response[@"data"];
//            NSArray *infoArr = dataDic[@"info"];
//                successBlock(infoArr.lastObject);
//            }
//        }else{
//            if (response[@"msg"]) {
//                [MBProgressHUD showMessage:response[@"msg"]];
//            }
//        }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } mainView:mainView];

}


//进入房间需要调用的接口，里边有用户的全部信息，还有socket链接地址
+(void)kk_playRoomWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
//    NSString *urlString = [BaseUrl stringByAppendingFormat:@"%@&uid=%@&token=%@&liveuid=%@&stream=%@&city=%@",KKPlayRoomApi,[Config getOwnID],[Config getOwnToken],[parameters valueForKey:@"uid"],[parameters valueForKey:@"stream"],[cityDefault getMyCity] ];
   
    
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",KKPlayRoomApi];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypePOST urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
       
        if ([response[@"ret"] integerValue] == 200) {//200表示服务器正常返回
        if (successBlock) {
                successBlock(response[@"data"]);
            }
        }else{
            if (response[@"cont"]) {
                [MBProgressHUD showMessage:response[@"msg"]];
            }
        }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } mainView:mainView];
}

//直播间内主播肉票榜dAPI
+ (void)kk_GetLiveRoomRankListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    
    NSString *urlString = [h5url stringByAppendingFormat:@"%@",KKGetLiveRankListInfoApi];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
        if (successBlock) {
            successBlock(response);
            }
    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } mainView:mainView];
    
}

+ (void)kk_GetLiveStopRoomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView
{
    NSString *urlString = [KKBaseUrl stringByAppendingFormat:@"%@",KKGetLiveStopRoomInfoApi];
    [[KKHTTPNetWorkTool sharedManager] kk_loadDataFromNetWorkWithHttpRequestType:KKHttpRequestTypeGET urlString:urlString parameters:parameters progressBlock:nil successBlock:^(id  _Nullable response) {
        
        if([response[@"ret"] isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            if (successBlock) {
                successBlock(response[@"data"]);
                }
        }else{
            NSArray *data = [response valueForKey:@"data"];
            [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
        }

    } failureBlock:^(NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } mainView:mainView];
    
}

@end


