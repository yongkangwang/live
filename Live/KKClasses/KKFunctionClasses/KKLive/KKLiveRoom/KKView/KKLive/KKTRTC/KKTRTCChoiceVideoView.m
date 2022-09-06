//
//  KKTRTCChoiceVideoView.m
//  yunbaolive
//
//  Created by Peter on 2021/4/26.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCChoiceVideoView.h"

#import "CGXPageCollectionWaterView.h"
#import "CGXPageCollectionHeaderModel.h"

#import "KKTRTCChoiceVideoCell.h"
#import "KKBarrageWebView.h"
#import "YCXMenu.h"


@interface KKTRTCChoiceVideoView ()<CGXPageCollectionUpdateViewDelegate>

@property(weak,nonatomic)UIButton *kkBGCoverBtn;

@property(weak,nonatomic)UIView *kkContentView;

@property(weak,nonatomic)UIButton *kkGoBackBtn;
@property(weak,nonatomic)UIButton *kkBackHomeBtn;
@property(weak,nonatomic)UIButton *kkCollectBtn;//收藏

@property(weak,nonatomic)UIButton *kkCircuitryBtn;//线路
@property(weak,nonatomic)UIButton *kkEnshrineVideoBtn;//收藏

@property(weak,nonatomic)UIButton *kkLookTogetherBtn;

@property (nonatomic , weak) CGXPageCollectionWaterView *generalView;

@property (nonatomic,copy) NSString * kkCircuitryNum;//线路数
@property (nonatomic,assign) NSInteger kkCurrentCircuitryNum;//当前线路


@property(strong,nonatomic)NSMutableArray *kkVideoListArr;

@property(weak,nonatomic)KKBarrageWebView *kkVideoWebView;

@property(strong,nonatomic)NSDictionary *kkCurrentVideoDic;
//线路
@property(strong,nonatomic)NSMutableArray *kkCircuitryMoreFunctionArr;

@end

@implementation KKTRTCChoiceVideoView

- (void)kkRefreshData
{
    [self kkInitData];

}

-(void)kkShow{
            
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [self kkInitData];

    [self layoutIfNeeded];

}

- (void)kkDismiss
{
//    [self removeFromSuperview];
    if (self.kkCloseViewBlock) {
        self.kkCloseViewBlock(@"");
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.kkRoomType = 1;
        //添加子控件
        [self kkInitView];
//        [self kkInitData];
    }
    return self;
}

- (void)kkInitView
{
//    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkDismiss)];
//    [self addGestureRecognizer:tapges];
    
    
    UIButton *kkBGCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:kkBGCoverBtn];
    self.kkBGCoverBtn = kkBGCoverBtn;
    [kkBGCoverBtn addTarget:self action:@selector(kkDismiss) forControlEvents:UIControlEventTouchUpInside];

    UIView *kkContentView = [[UIView alloc] init];
    self.kkContentView = kkContentView;
    [self addSubview:kkContentView];
    kkContentView.backgroundColor = [UIColor colorWithHexString:@"#151723"];
    
    UIButton *kkGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentView addSubview:kkGoBackBtn];
    self.kkGoBackBtn = kkGoBackBtn;
    [kkGoBackBtn setImage:[UIImage imageNamed:@"KKRank_backBtn_icon"] forState:UIControlStateNormal];
    [kkGoBackBtn addTarget:self action:@selector(kkGoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    kkGoBackBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 15, 12.5, 10);

    UIButton *kkBackHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentView addSubview:kkBackHomeBtn];
    self.kkBackHomeBtn = kkBackHomeBtn;
    [kkBackHomeBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_BackHome_icon"] forState:UIControlStateNormal];
    [kkBackHomeBtn addTarget:self action:@selector(kkBackHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentView addSubview:kkCollectBtn];
    self.kkCollectBtn = kkCollectBtn;
    [kkCollectBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_Collect_icon"] forState:UIControlStateNormal];
    [kkCollectBtn addTarget:self action:@selector(kkCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *kkCircuitryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentView addSubview:kkCircuitryBtn];
    self.kkCircuitryBtn = kkCircuitryBtn;
    kkCircuitryBtn.titleLabel.font = KKPhoenFont13;
    [kkCircuitryBtn setTitle:@"线路1" forState:UIControlStateNormal];
    [kkCircuitryBtn addTarget:self action:@selector(kkCircuitryBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *kkLookTogetherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentView addSubview:kkLookTogetherBtn];
    self.kkLookTogetherBtn = kkLookTogetherBtn;
    [kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_LookTogether_icon"] forState:UIControlStateNormal];
    [kkLookTogetherBtn addTarget:self action:@selector(kkLookTogetherBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self setupLayoutAndCollectionView];
    
    KKBarrageWebView *kkVideoWebView = [[KKBarrageWebView alloc]init];
    [self.kkContentView addSubview:kkVideoWebView];
    self.kkVideoWebView = kkVideoWebView;
    kkVideoWebView.backgroundColor = KKWhiteColor;
    kkVideoWebView.hidden = YES;
    kkVideoWebView.kkScrollEnabled = YES;
//    NSString *kkurl = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=wmai&a=uyouxi_log"];
//    kkurl = [NSString kk_AppendH5URL:kkurl];
//    kkVideoWebView.kkUrls = kkurl;
//    kkBarrageWebView.kkWebView.scrollView.scrollEnabled = YES;
//    kkBarrageWebView.kkWebView.scrollView.bounces = YES;

}

/**
 * 创建布局和collectionView
 */
- (void)setupLayoutAndCollectionView{
    
    CGXPageCollectionWaterView *generalView = [[CGXPageCollectionWaterView alloc]  init];
    self.generalView = generalView;
    [self.kkContentView addSubview:self.generalView];

    self.generalView.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight/2);
   self.generalView.viewDelegate = self;
   self.generalView.isShowDifferentColor = NO;
   self.generalView.isRoundEnabled = YES;
//   self.generalView.collectionView.contentInset = UIEdgeInsetsMake(KKNavH, 0, 15, 0);

    [self.generalView registerCell:[KKTRTCChoiceVideoCell class] IsXib:NO];
    

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkBGCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self kkLayoutTopView];

    [self.generalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(self.kkContentView.mas_top).mas_offset(50);
        make.bottom.mas_equalTo(-ShowDiff);
    }];

    [self.kkVideoWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.generalView);
    }];

}

- (void)kkLayoutTopView
{
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(KKScreenHeight/1.5);
    }];
    
    [self.kkGoBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.kkContentView);
        make.height.width.mas_equalTo(45);
    }];

    [self.kkLookTogetherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkGoBackBtn);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(82);
    }];

    [self.kkCircuitryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkGoBackBtn);
        make.right.mas_equalTo(self.kkLookTogetherBtn.mas_left).mas_offset(-20);
//        make.left.mas_equalTo(self.kkBackHomeBtn.mas_right).mas_offset(50);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(50);
    }];
    
    
    [self.kkCollectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkGoBackBtn);
        make.right.mas_equalTo(self.kkCircuitryBtn.mas_left).mas_offset(-5);
        make.height.width.mas_equalTo(45);
    }];
    
    [self.kkBackHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkGoBackBtn);
        make.right.mas_equalTo(self.kkCollectBtn.mas_left).mas_offset(-5);
//        make.left.mas_equalTo(self.kkGoBackBtn.mas_right).mas_offset(50);
        make.height.width.mas_equalTo(45);
    }];

}


- (void)kkInitData
{
    self.kkCurrentCircuitryNum = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(self.kkRoomType);
    
    [KKLiveAPI kk_PostTRTCVideoListInfoWithparameters:param successBlock:^(id  _Nullable response) {
        if ([response[@"status"] intValue] == 1) {
            NSString *kkCircuitry  = response[@"nums"];//线路总数
            self.kkCircuitryNum = kkCircuitry;
            NSMutableArray *listArr = response[@"cont"];
            NSMutableArray *kkVideoListArr = [self loadDealWithList:listArr];
            self.kkVideoListArr = kkVideoListArr;

            [self.generalView updateDataArray:kkVideoListArr IsDownRefresh:YES Page:1];
            [self kkCircuitryInit];
        }
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];
}

- (void)kkCircuitryInit
{
    int kknum = [self.kkCircuitryNum intValue];
    for (int i=0; i<kknum; i++) {
        YCXMenuItem *kkMakeGroupItem = [YCXMenuItem menuItem:[NSString stringWithFormat:@"线路%d",(i+1)] image:[UIImage imageNamed:@""] target:self action:@selector(kkCircuitryNumClick:)];
        kkMakeGroupItem.foreColor = KKBlackLabColor;
        kkMakeGroupItem.tag = (i+1);
        [self.kkCircuitryMoreFunctionArr addObject:kkMakeGroupItem];
    }

}

//处理数据源
- (NSMutableArray<CGXPageCollectionWaterSectionModel *> *)loadDealWithList:(NSMutableArray *)kkRowArr
{
    NSMutableArray *dateAry = [NSMutableArray array];
    int x = 1;//分多少组
    for (int i = 0; i<x; i++) {
        CGXPageCollectionWaterSectionModel *sectionModel = [[CGXPageCollectionWaterSectionModel alloc] init];
        
        sectionModel.insets = UIEdgeInsetsMake(2,2,2,2);
        sectionModel.minimumLineSpacing = 10;
        sectionModel.minimumInteritemSpacing = 10;
                //collectionview 边距
        sectionModel.borderEdgeInserts = UIEdgeInsetsMake(5, 15, 5, 15);

        NSMutableArray *itemArr = [NSMutableArray array];
        
        UIColor*randColor = [UIColor clearColor];
        sectionModel.row = 4;
        for (int j = 0; j<kkRowArr.count; j++) {
            CGXPageCollectionWaterRowModel *item = [[CGXPageCollectionWaterRowModel alloc] initWithCelllass:[KKTRTCChoiceVideoCell class] IsXib:NO];
            item.dataModel= kkRowArr[j];
            item.cellHeight = 85;
            item.cellColor =  randColor;
            [itemArr addObject:item];
        }
            
        sectionModel.rowArray = [NSMutableArray arrayWithArray:itemArr];
        [dateAry addObject:sectionModel];
    }
    return dateAry;
}

- (void)gx_PageCollectionBaseView:(CGXPageCollectionBaseView *)baseView DidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了分组%zd,行%zd",indexPath.section,indexPath.row);
    
    CGXPageCollectionWaterSectionModel *kkmodel = self.kkVideoListArr.lastObject;
    CGXPageCollectionWaterRowModel *kkrowModel = (CGXPageCollectionWaterRowModel *)kkmodel.rowArray[indexPath.row];
    NSDictionary *kkdic = kkrowModel.dataModel;
    self.kkCurrentVideoDic = kkdic;
    
    NSURL *url = [NSURL URLWithString:kkdic[@"shipinguanli_url"]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.kkVideoWebView.kkWebView loadRequest:request];
    self.kkVideoWebView.hidden = NO;
    
    if ([kkdic[@"shipinguanli_type"] intValue] == 1) {
        //不需要调用接口获取
        [self.kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_LookTogether_icon"] forState:UIControlStateNormal];
    }else if ([kkdic[@"shipinguanli_type"] intValue] == 2){
        //需要，
        [self.kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_VipLookTogether_icon"] forState:UIControlStateNormal];
    }
    
}

#pragma  mark ========== 事件处理
//手粗
- (void)kkEnshrineVideo
{
//    kk_PostEnshrineVideoInfoWithParameters
    
}


- (void)kkChangeWebURL:(NSDictionary *)dic;
{
    NSMutableDictionary *kkdic = [NSMutableDictionary dictionary];
    [kkdic setValue:dic[@"webType"] forKey:@"shipinguanli_type"];
    self.kkCurrentVideoDic = kkdic;
//    [self.kkCurrentVideoDic setValue:@"shipinguanli_type" forKey:dic[@"webType"]];
    NSURL *url = [NSURL URLWithString:dic[@"webUrl"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.kkVideoWebView.kkWebView loadRequest:request];
    self.kkVideoWebView.hidden = NO;
    
    if ([kkdic[@"shipinguanli_type"] intValue] == 1) {
        //不需要调用接口获取
        [self.kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_LookTogether_icon"] forState:UIControlStateNormal];
    }else if ([kkdic[@"shipinguanli_type"] intValue] == 2){
        //需要，vip播放
        [self.kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_VipLookTogether_icon"] forState:UIControlStateNormal];
    }

}

- (void)kkGoBackBtnClick
{
    [self.kkVideoWebView.kkWebView goBack];

}
- (void)kkBackHomeBtnClick
{
    self.kkVideoWebView.hidden = YES;
    self.kkCurrentVideoDic = [NSDictionary dictionary];

}
- (void)kkCollectBtnClick
{
    NSString *kkVideoTitle = self.kkVideoWebView.kkWebView.title;
    NSString *kkVideoURL = self.kkVideoWebView.kkWebView.URL.absoluteString;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"title"] = kkVideoTitle;
    param[@"url"] = kkVideoURL;

    [KKMyAPI kk_PostEnshrineVideoInfoWithParameters:param successBlock:^(id  _Nullable response) {
        if (response[@"cont"]) {
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
        
    } failureBlock:^(NSError * _Nullable error) {
        
    } mainView:self];
}

- (void)kkCircuitryNumClick:(YCXMenuItem *)item
{
    NSLog(@"YCXMenuItem %zd",item.tag);
}

//切换线路
- (void)kkCircuitryBtnClick
{
    [YCXMenu setTintColor:KKWhiteColor];
    [YCXMenu setHasShadow:YES];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"#EDEDED"]];
    WeakSelf;
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        CGRect kkMenuF = CGRectMake(self.frame.size.width - 50, KKNavH, 50, 0);
            kkMenuF = self.kkCircuitryBtn.frame;
            [YCXMenu showMenuInView:self.kkContentView fromRect:kkMenuF menuItems:self.kkCircuitryMoreFunctionArr selected:^(NSInteger index, YCXMenuItem *item) {
                NSLog(@"%@",item);
                [weakSelf.kkCircuitryBtn setTitle:[NSString stringWithFormat:@"线路%zd",item.tag] forState:UIControlStateNormal];
                weakSelf.kkCurrentCircuitryNum = item.tag;
            }];
        
        }
    
}

- (void)kkLookTogetherBtnClick
{
    if ([self.kkCurrentVideoDic[@"shipinguanli_type"] intValue] == 1) {
        //不需要调用接口获取,使用JS注入获取视频地址
        [self kkJSInject];
    }else if ([self.kkCurrentVideoDic[@"shipinguanli_type"] intValue] == 2){
        //需要，
        [self kkPostVideoUrl];

    }

}

- (void)kkJSInject
{
//    NSString *JsStr = @"(document.getElementsByTagName(\"video\")[0]).src";
    
    NSString *JsStr =  @"function w9a(i){return document.getElementsByTagName(i)[0];};function w9v(){return (w9a('video')?(w9a('video').src||''):'')};function w9s(){return (w9a('source')?(w9a('source').src||''):'')};function w9i(){return (w9a('iframe')?(w9a('iframe').src||''):'')};if(w9v()){if(w9v().split('blob:')[1]){w9r('3','');}else{w9r('1',w9v());}}else if (w9s()){w9r('1',w9s());}else if (w9i()){w9r('2', w9i());}else {w9r('3','');}function w9r(t,u){return {type:t,url:u}};";
    
    WeakSelf;
    [self.kkVideoWebView.kkWebView evaluateJavaScript:JsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(![response isEqual:[NSNull null]] && response != nil){
            //截获到视频地址了
            NSLog(@"response == %@",response);

            if ([response isKindOfClass:[NSDictionary class]]) {
                if ([response[@"type"] intValue] == 1) {
                    //表示返回了正常的videoURL
                    NSString *kkurl = response[@"url"];
                    //弹框提示
                    [weakSelf kkShowVideoURLAlert:kkurl];
                }else  if ([response[@"type"] intValue] == 2) {
                    //跳转网页
                    NSString *kkurl = response[@"url"];
                    NSURL *url = [NSURL URLWithString:kkurl];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [weakSelf.kkVideoWebView.kkWebView loadRequest:request];
                }
            }
            
        }else{
            //没有视频链接
        }
    }];

}

- (void)kkPostVideoUrl
{
    WeakSelf;
    NSString *kkVideoURL = self.kkVideoWebView.kkWebView.URL.absoluteString;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"url"] = kkVideoURL;
    param[@"type"] = @(self.kkCurrentCircuitryNum);//线路

    [KKLiveAPI kk_PostVideoURLInfoWithparameters:param successBlock:^(id  _Nullable response) {
        if ([response[@"status"] intValue]== 1) {
            NSString *kkurl = response[@"cont"];
            if ([response[@"type"] intValue] == 1) {
                //视频链接
                [weakSelf kkShowVideoURLAlert:kkurl];
            }else if ([response[@"type"] intValue] == 2){
                //网页
                NSURL *url = [NSURL URLWithString:kkurl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [weakSelf.kkVideoWebView.kkWebView loadRequest:request];
                weakSelf.kkVideoWebView.hidden = NO;
                    //不需要调用接口获取
                [weakSelf.kkLookTogetherBtn setImage:[UIImage imageNamed:@"KKTRTCRoom_LookTogether_icon"] forState:UIControlStateNormal];
                [weakSelf.kkCurrentVideoDic setValue:@"1" forKey:@"shipinguanli_type"];
            }
            
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];
        }
    } failureBlock:^(NSError * _Nullable error) {
        [MBProgressHUD kkshowMessage:error.localizedDescription];//报错信息
    } mainView:self];
}

- (void)kkShowVideoURLAlert:(NSString *)url
{
    NSString *kkVideoTitle = self.kkVideoWebView.kkWebView.title;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kkVideoTitle message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //添加一个按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"一起看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        if (self.kkIsAnchor) {
//            if (self.kkSelectVideoURLBlock) {
//                self.kkSelectVideoURLBlock(url);
//            }
//        }else{
            NSMutableDictionary *kkdic = [NSMutableDictionary dictionary];
            kkdic[@"title"] = kkVideoTitle;
            kkdic[@"url"] = url;
            kkdic[@"webType"] = self.kkCurrentVideoDic[@"shipinguanli_type"];
            NSString *kkVideoURL = self.kkVideoWebView.kkWebView.URL.absoluteString;
            kkdic[@"webUrl"] =kkVideoURL;
            
            if (self.kkUserSelectVideoBlock) {
                self.kkUserSelectVideoBlock(kkdic);
            }
//        }
        
        [self kkDismiss];
    }]];
    
    if (self.kkShowVideoURLAlertBlock) {
        self.kkShowVideoURLAlertBlock(alert);
    }

}





- (NSMutableArray *)kkVideoListArr
{
    if (!_kkVideoListArr) {
        _kkVideoListArr = [NSMutableArray array];
    }
    return _kkVideoListArr;
}

- (NSDictionary *)kkCurrentVideoDic
{
    if (!_kkCurrentVideoDic) {
        _kkCurrentVideoDic = [NSDictionary dictionary];
    }
    return _kkCurrentVideoDic;
}


- (NSMutableArray *)kkCircuitryMoreFunctionArr
{
    if (!_kkCircuitryMoreFunctionArr) {
        _kkCircuitryMoreFunctionArr = [NSMutableArray array];
    }
  return  _kkCircuitryMoreFunctionArr;
}
@end
