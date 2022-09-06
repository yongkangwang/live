//
//  KKLiveRoomScrollView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/19.
//  Copyright © 2021 cat. All rights reserved.
//



#import "KKLiveRoomScrollView.h"

#import "KKLiveViewerView.h"
#import "KKHorizontalView.h"


#import "AppDelegate.h"


@interface KKLiveRoomScrollView ()<UIScrollViewDelegate,AJWaveRefreshProtocol,KKLiveViewerViewDelegate>

//kk六道添加
// 切换分页的视图，属于控制器z所加载的最底层的视图，
@property (nonatomic, strong)UIScrollView *kkscrollView;

@property(weak,nonatomic)KKLiveViewerView *kkTopViewerV;
@property(weak,nonatomic)KKLiveViewerView *kkMiddleViewerV;
@property(weak,nonatomic)KKLiveViewerView *kkBottomViewerV;

//当前播放的房间
@property(weak,nonatomic)KKLiveViewerView *kkCurrentViewerV;

//分页控制器
@property (nonatomic, strong) UIPageControl *kkpageControl;
@property (nonatomic, assign, readonly) NSInteger kkcurrentPage;
//是否为上层控制器进入的房间
@property (nonatomic, assign) NSInteger kkisFirstComein;

@property (nonatomic,assign) BOOL kkIsShowHorizontalView;
//1.8六道添加，用于解决密码房间没模糊遮罩问题
@property (nonatomic,assign) BOOL kkIsCanWatch;
//
//主播列表数据
@property(strong,nonatomic)NSMutableArray *kkzhuboModelArr;

//横屏
@property(weak,nonatomic)KKHorizontalView *kkHorizontalView;

@property (nonatomic,assign) CGFloat kkScreenH;
@property (nonatomic,assign) CGFloat kkScreenW;

@end

@implementation KKLiveRoomScrollView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.kkScreenH = KKScreenHeight;
        self.kkScreenW = KKScreenWidth;
        
        [self kkInitBuild];
        //初始化切换房间功能视图
        [self kkInitContentView];

    }
    return self;
}

- (void)kkInitBuild
{
    self.kkIsShowHorizontalView = NO;
}

- (void)kkInitContentView
{
    //设置滚动视图的内边距kk
    self.kkscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addSubview: self.kkscrollView];
    
    KKLiveViewerView *kkTopViewerV = [[KKLiveViewerView alloc]init];
    self.kkTopViewerV = kkTopViewerV;
    [self.kkscrollView addSubview:kkTopViewerV];
    kkTopViewerV.kkViewerViewDelegate = self;
    
    KKLiveViewerView *kkMiddleViewerV = [[KKLiveViewerView alloc]init];
    self.kkMiddleViewerV = kkMiddleViewerV;
    [self.kkscrollView addSubview:kkMiddleViewerV];
    kkMiddleViewerV.kkViewerViewDelegate = self;

    KKLiveViewerView *kkBottomViewerV = [[KKLiveViewerView alloc]init];
    self.kkBottomViewerV = kkBottomViewerV;
    [self.kkscrollView addSubview:kkBottomViewerV];
    kkBottomViewerV.kkViewerViewDelegate = self;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.kkTopViewerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.kkscrollView);
        make.width.height.mas_equalTo(self.kkscrollView);
    }];

    [self.kkMiddleViewerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTopViewerV.mas_bottom);
        make.left.mas_equalTo(self.kkscrollView);
        make.width.height.mas_equalTo(self.kkscrollView);
    }];

    [self.kkBottomViewerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkMiddleViewerV.mas_bottom);
        make.left.mas_equalTo(self.kkscrollView);
        make.width.height.mas_equalTo(self.kkscrollView);
    }];

}


- (void)kkInitData
{
    [self kkinitRoomData];
}

- (void)headerRereshing
{
    self.kkLoadPage = 1;
    [self kkscrollViewHeadAndFooterRefresh];
}
- (void)footerRereshing
{
    self.kkLoadPage++;
    [self kkscrollViewHeadAndFooterRefresh];
}


#pragma mark ======上下滑动功能

//初始化切换房间的视图，    //第一次进入这个控制器时调用的方法, 只执行一次
- (void)kkinitRoomData
{
    //设置最大页数
    self.kkpageControl.numberOfPages = self.scrollarray.count;
    self.kkpageControl.currentPage = self.kkcurrentSelectItemIndex;
    _kkcurrentPage = self.kkcurrentSelectItemIndex;
    self.kkisFirstComein = 1;
    if (self.scrollarray.count <= 1) {
        //如果只有1个的时候 就不支持滑动
        self.kkscrollView.contentSize = CGSizeMake(0, KKScreenHeight);
    }else{
        //1个以上可以可滑动
        self.kkscrollView.contentSize = CGSizeMake(0, KKScreenHeight*3);
    }
    [self kkrefreshView];
}


#pragma mark- 切换房间后刷新视图
//每次切换房间都会调用
-(void)kkrefreshView{
    
    self.kkIsShowHorizontalView = NO;
    
    //能进到这个方法中，表示_kkcurrentPage值是房间切换后的房间下标
    //能进到这个方法表示视图滑动了，在这里更新视图数据
    NSInteger index = _kkcurrentPage;//这个值是当前数据在数组中的下标
    [self setRoomView:self.kkMiddleViewerV roomDic:self.scrollarray[index]];
    //三目运算（expression）？if-true-statement :if-false-statement;
    index = _kkcurrentPage-1<=0?0:_kkcurrentPage-1;

    [self setRoomView:self.kkTopViewerV roomDic:self.scrollarray[index]];
    
    index = _kkcurrentPage+1>=self.scrollarray.count-1?self.scrollarray.count-1:_kkcurrentPage+1;
    [self setRoomView:self.kkBottomViewerV roomDic:self.scrollarray[index]];
    
    //contentOffset:即偏移量,其中分为contentOffset.y=内容的顶部和frame顶部的差值
    //设置这一步是为了，房间切换后，kkscrollView，会进行偏移，中间kkmiddleImgView会被滑动到上一页或者下一页，这要看用户的操作了，为了实现无限循环轮播思路，这时kkmiddleImgView 已经加载了切换后房间的图片，我们需要将vkkscrollView的偏移量重新拉回来，这样就实现了视图重复利用轮播效果。让用户以为切换了视图，其实只是切换了数据而已
    //这里有问题，
    NSDictionary *currentRoomDic = self.scrollarray[_kkcurrentPage];
    self.playDoc = currentRoomDic;
    self.kkcurrentSelectItemIndex = _kkcurrentPage;
    
    if (self.kkcurrentPage == 0) {
        self.kkscrollView.contentOffset = CGPointMake(0, 0);
        self.kkTopViewerV.kkIsCanPlay = YES;
        self.kkTopViewerV.kkScrollarray = self.scrollarray;
        self.kkTopViewerV.kkcurrentSelectItemIndex = self.kkcurrentSelectItemIndex;
        
        self.kkBottomViewerV.kkIsCanPlay = NO;
        self.kkMiddleViewerV.kkIsCanPlay = NO;
        
        self.kkCurrentViewerV = self.kkTopViewerV;
    //在这里判断哪个页面可以播放视频
    }else if (self.kkcurrentPage == self.scrollarray.count - 1){
        self.kkscrollView.contentOffset = CGPointMake(0, KKScreenHeight*2);
        self.kkBottomViewerV.kkIsCanPlay = YES;
        self.kkBottomViewerV.kkScrollarray = self.scrollarray;
        self.kkBottomViewerV.kkcurrentSelectItemIndex = self.kkcurrentSelectItemIndex;

        self.kkTopViewerV.kkIsCanPlay = NO;
        self.kkMiddleViewerV.kkIsCanPlay = NO;
        
        self.kkCurrentViewerV = self.kkBottomViewerV;

    }else{
        //切换房间的方法，需要每次都调用
        self.kkscrollView.contentOffset = CGPointMake(0, KKScreenHeight);
        
        self.kkMiddleViewerV.kkIsCanPlay = YES;
        self.kkMiddleViewerV.kkScrollarray = self.scrollarray;
        self.kkMiddleViewerV.kkcurrentSelectItemIndex = self.kkcurrentSelectItemIndex;
        self.kkBottomViewerV.kkIsCanPlay = NO;
        self.kkTopViewerV.kkIsCanPlay = NO;
        self.kkCurrentViewerV = self.kkMiddleViewerV;

    }
    
}

-(void)setRoomView:(KKLiveViewerView *)view roomDic:(NSDictionary *)roomDic
{
    view.kkLiveInfo = roomDic;
    
}


//刷到顶部加载数据   //刷到底部加载更多数据
- (void)kkscrollViewHeadAndFooterRefresh
{
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    if (self.kkLiveType) {
        parame[@"type"] = @(self.kkLiveType); //type  1是颜值  2是一起看   不传是首页
    }
    parame[@"p"] = @(self.kkLoadPage);

    [KKLiveAPI  kk_PostHomeLiveInfoWithparameters:parame successBlock:^(id  _Nullable response) {

        [self.kkscrollView.mj_header endRefreshing];
        [self.kkscrollView.mj_footer endRefreshing];

        if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
            NSArray *list = response[@"rezhibo"];
            if (list.count == 0) {
                [MBProgressHUD kkshowMessage:@"没有更多数据了"];
                if (self.kkLoadPage!=1) {
                    self.kkLoadPage --;
                    [self.kkscrollView.mj_footer endRefreshingWithNoMoreData];
                }
                return ;
            }
            if (self.kkLoadPage == 1) {
                [self.scrollarray removeAllObjects];
                [self.kkzhuboModelArr removeAllObjects];
                //第一页如果有新数据，在当前页显示第一条数据
                //添加新数据
                   [self.scrollarray addObjectsFromArray:list];

                //初始化数据
                self.playDoc = self.scrollarray.firstObject;
                self.kkpageControl.numberOfPages = self.scrollarray.count;
                //加载数据要滚动一下视图，然后再赋值数据
                [self kkrefreshView];

            }else{
                //添加新数据
                   [self.scrollarray addObjectsFromArray:list];

                //这块页面
                //最后一页如果有新数据，在当前页显示上一次请求数据的最后一条数据
                //初始化数据
                self.kkpageControl.numberOfPages = self.scrollarray.count;
                self.kkscrollView.contentOffset = CGPointMake(0, CGRectGetHeight(self.bounds));
                                
                //切换直播间数据
                [self setRoomView:self.kkMiddleViewerV roomDic:self.playDoc];
                self.kkMiddleViewerV.kkIsCanPlay = YES;
                self.kkBottomViewerV.kkIsCanPlay = NO;
                self.kkTopViewerV.kkIsCanPlay = NO;
                self.kkCurrentViewerV = self.kkMiddleViewerV;

            }
            
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];

        }
    } failureBlock:^(NSError * _Nullable error) {
        [self.kkscrollView.mj_header endRefreshing];
        [self.kkscrollView.mj_footer endRefreshing];

    } mainView:self];
}

//判断是向上滑动还是向下滑动，判断是否可以继续滚动
-(void)kkrefreshCurrentPage
{
    if (self.kkscrollView.contentOffset.y >= CGRectGetHeight(self.bounds)*1.5 || (self.kkcurrentPage == 0 && self.kkscrollView.contentOffset.y >= CGRectGetHeight(self.bounds))) {
        _kkcurrentPage ++;//向上滑加载下一页
        if (_kkcurrentPage >= self.scrollarray.count-1) {
            _kkcurrentPage = self.scrollarray.count-1;
        }
    }else if (self.kkscrollView.contentOffset.y <= CGRectGetHeight(self.bounds)/2 || (self.kkcurrentPage == self.scrollarray.count - 2 && self.kkscrollView.contentOffset.y <= (CGRectGetHeight(self.bounds)*2) )
              
              ) {
        _kkcurrentPage--;//向下滑加载上一页
        
        if (_kkcurrentPage <= 0) {
            _kkcurrentPage = 0;//能进来表示 滑到了第一条数据，
        }
    }else{
        //解决从最后一条向上滑动，却没加载数据的问题，是因为少判断了一个可能性
        if (_kkcurrentPage == self.scrollarray.count - 1) {
            _kkcurrentPage--;//向下滑加载上一页
            
            if (_kkcurrentPage <= 0) {
                _kkcurrentPage = 0;//能进来表示 滑到了第一条数据，
            }

        }
    }
    
}

#pragma mark ====scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.kkCurrentViewerV kkCoverBtnClick];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self kkrefreshCurrentPage];
        //判断是否滑动了视图因为_kkcurrentPage是下标，所以要加1才能正确判断是否是当前页
    if (self.kkpageControl.currentPage != _kkcurrentPage) {
        self.kkpageControl.currentPage = _kkcurrentPage;
        self.kkisFirstComein = 0;

        [self kkrefreshView];

        //滚动结束
//NSLog(@"切换房间滚动结束scrollView____DidEndDecelerating%@",self.scrollarray[_kkcurrentPage]);
        }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.kktextToolBar.kkTextField resignFirstResponder];
//        self.kktextToolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    
}
#pragma mark ====  以上是 上下滑动


#pragma mark ====   代理事件

//上下麦弹框
- (void)kkShowAlertMicrophone:(UIAlertController *)alert
{
//    if (self.kkShowAlertMicrophoneBlock) {
//        self.kkShowAlertMicrophoneBlock(alert);
//    }
    if ([self.kkDelegate respondsToSelector:@selector(kkShowAlertMicrophone:)]) {
        [self.kkDelegate kkShowAlertMicrophone:alert];
    }
    
}
- (void)kkShowPortrait
{
    self.kkIsShowHorizontalView = NO;

    [self setNeedsLayout];
    [self.kkCurrentViewerV setNeedsLayout];
    [self.kkCurrentViewerV kkCoverBtnClick];
}

- (void)kkPortraitBtnClick
{
//    if (self.kkPortraitBtnClickBlock) {
//        self.kkPortraitBtnClickBlock(@"");
//    }
    if ([self.kkDelegate respondsToSelector:@selector(kkPortraitBtnClick:)]) {
        [self.kkDelegate kkPortraitBtnClick:@""];
    }

}

- (void)kkShowHorizontalView:(KKHorizontalView *)horizontalV
{
    [self.kkCurrentViewerV kkCoverBtnClick];
    self.kkIsShowHorizontalView = YES;
    [self.kkCurrentViewerV kkShowHorizontalView:horizontalV];

}



//懒加载
- (UIScrollView *)kkscrollView{
    if (!_kkscrollView) {
        _kkscrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _kkscrollView.delegate = self;
        _kkscrollView.backgroundColor = KKWhiteColor;
        _kkscrollView.tag = 131;
        _kkscrollView.bounces = YES;
        _kkscrollView.showsHorizontalScrollIndicator = NO;
        _kkscrollView.showsVerticalScrollIndicator = NO;
        _kkscrollView.pagingEnabled = YES;//是否可以分页
    // 12.设置是否可以自动滚动到顶部(点击上面状态栏的时候),默认为true
        _kkscrollView.scrollsToTop = NO;
        _kkscrollView.contentSize = CGSizeMake(0, KKScreenHeight);
        
        //下拉刷新动效
        [_kkscrollView setupRefreshHeader:self];
        [_kkscrollView setupRefreshFooter:self];
    }
    return _kkscrollView;
}

-(UIPageControl*)kkpageControl
{
    if (!_kkpageControl) {
        _kkpageControl = [[UIPageControl alloc]init];
        _kkpageControl.hidesForSinglePage = YES;
        
    }
    return _kkpageControl;
}


@end
