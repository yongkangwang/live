//
//  KKShowRoomTitleView.m
//  yunbaolive
//
//  Created by Peter on 2020/2/19.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKShowRoomTitleView.h"

@interface KKShowRoomTitleView ()
@property(weak,nonatomic)UIImageView *kkShowRoomTitleImgView;
@property(weak,nonatomic)UILabel *kktitleLab;
//@property(weak,nonatomic)UIImageView *kkRightImgV;

@end


@implementation KKShowRoomTitleView
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KKWhiteColor;
        //添加子控件
        [self kksetupUI];
    }
    return self;
}
- (void)kksetupUI
{
      UIImageView *titleBackImgView = [[UIImageView alloc]init];
      self.kkShowRoomTitleImgView = titleBackImgView;
      titleBackImgView.contentMode = UIViewContentModeScaleToFill;
//      titleBackImgView.image = [UIImage imageNamed:@"KKLive_SecondPage_ShowLiveTitle_icon"];
    titleBackImgView.image = [UIImage imageNamed:@"KKLiveRoom_ShowLiveTitle_icon"];

    [self addSubview:titleBackImgView];

    UILabel *titL = [[UILabel alloc]init];
    self.kktitleLab = titL;
    [self addSubview:titL];

    titL.textAlignment = NSTextAlignmentLeft;
    titL.textColor = KKWhiteColor;
    titL.font = kkFontBoldMT(12);

//    UIImageView *kkRightImgV = [[UIImageView alloc]init];//图片高度49，宽度120
//    kkRightImgV.contentMode = UIViewContentModeScaleAspectFill;
//    kkRightImgV.image = [UIImage imageNamed:@"KKLive_SecondPage_ShowLiveTitleRigth_icon"];
//    self.kkRightImgV = kkRightImgV;
//    [self addSubview:kkRightImgV];

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupFrame];
}

- (void)setupFrame
{
    [self.kkShowRoomTitleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kktitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(12);
    }];
//    [self.kkRightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(25);
//        make.bottom.mas_equalTo(-3);
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(45);
//    }];


}

- (void)setKkShowRoomTitleDic:(NSDictionary *)kkShowRoomTitleDic
{
    _kkShowRoomTitleDic = kkShowRoomTitleDic;

    self.kktitleLab.text = minstr([kkShowRoomTitleDic valueForKey:@"title"]);

    if (self.kktitleLab.text.length>15) {
        [self.kktitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(198);
        }];
    }else{
        //15个字是198.89
        CGFloat kktitleLabW = [NSString kk_stringBoundsWithTitleString:self.kktitleLab.text andFontOfSize:13 rectSizeRate:1].size.width;
        [self.kktitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kktitleLabW);
        }];
    }
       [UIView animateWithDuration:2 animations:^{
           //执行两秒动画，透明度由0渐变到1
           self.alpha = 1;
       }];
    //8秒后执行
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
           [UIView animateWithDuration:2 animations:^{
               self.alpha = 0;
           } completion:^(BOOL finished) {
//               [self removeFromSuperview];
               self.hidden = YES;
           }];

       });

    
}
@end
