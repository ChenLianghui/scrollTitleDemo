//
//  LHHeadTapView.m
//  lockTitleScrollDemo
//
//  Created by 陈良辉 on 2017/5/24.
//  Copyright © 2017年 陈良辉. All rights reserved.
//

#import "LHHeadTapView.h"
#import "LHLockModel.h"
#define kScreenSize ([UIScreen mainScreen].bounds.size)
#define kLineHeight 4
#define kIndicateViewHeight 10
#define kMainColor [UIColor greenColor]
#define kViewSpace 5


//上方线条区域
@interface LHIndicateView : UIScrollView

@property (nonatomic,strong)UIView *lineView;

@end

@implementation LHIndicateView

- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenSize.width, kIndicateViewHeight);
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
    }
    return self;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kIndicateViewHeight - kLineHeight, (kScreenSize.width-3*kViewSpace)/4, kLineHeight)];
        _lineView.backgroundColor = kMainColor;
    }
    return _lineView;
}

@end

//collectionViewcell
@interface LHCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *lockImageView;
@property (nonatomic,strong)UILabel *lockStateLabel;

@end

@implementation LHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _lockStateLabel = [UILabel new];
    _lockStateLabel.frame = self.contentView.bounds;
    _lockStateLabel.font = [UIFont systemFontOfSize:30];
    _lockStateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lockStateLabel];
}

@end

//整体view
@interface LHHeadTapView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)LHIndicateView *indicateView;
@property (nonatomic,assign)CGFloat itemWidth;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)NSIndexPath *selectIndexPath;//选择item的indexpath

@end

@implementation LHHeadTapView


- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        _selectIndexPath = [[NSIndexPath alloc] init];
        _itemWidth = (kScreenSize.width-3*kViewSpace)/4;
        self.bounds = CGRectMake(0, 0, kScreenSize.width, _itemWidth+kIndicateViewHeight);
        _indicateView = [[LHIndicateView alloc] init];
        _lineView = [[UIView alloc] init];
        _lineView = self.indicateView.lineView;
        [self addSubview:_indicateView];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.lockArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    cell.lockStateLabel.text = self.lockArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapItemWithIndexPath:)]) {
        [self.delegate didTapItemWithIndexPath:indexPath];
    }
    
    LHCollectionViewCell *cell = (LHCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGFloat x = cell.center.x;
    CGFloat contentWidth = self.collectionView.contentSize.width;
    NSIndexPath *indexPath1;
    if (x<=kScreenSize.width/2) {
        if (collectionView.contentOffset.x == 0) {
            [self LineViewScrollToX:x];
            return;
        }else{
            indexPath1 = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }else if (x>=contentWidth-kScreenSize.width/2){
        if (collectionView.contentOffset.x == collectionView.contentSize.width-kScreenSize.width) {
            [self LineViewScrollToX:x];
            return;
        }else{
            indexPath1 = [NSIndexPath indexPathForItem:self.lockArray.count-1 inSection:0];
        }
        
    }else{
        //collectionview滚动
        indexPath1 = indexPath;
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self LineViewScrollToX:x];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        [self.indicateView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, 0) animated:NO];
    }
}

//线条动画
- (void)LineViewScrollToX:(CGFloat )x {
    
    [UIView animateWithDuration:0.2 animations:^{
        _lineView.center = CGPointMake(x, kIndicateViewHeight-kLineHeight/2);
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //因为为水平滚动，需要设置lineSpacing
        layout.minimumLineSpacing = kViewSpace;
//        layout.minimumInteritemSpacing = kViewSpace;
        layout.itemSize = CGSizeMake(_itemWidth, _itemWidth);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kIndicateViewHeight, kScreenSize.width, _itemWidth) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LHCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)setLineColor:(UIColor *)lineColor{
    self.lineView.backgroundColor = lineColor;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    CGRect frame = self.lineView.frame;
    frame.size.height = lineHeight;
    self.lineView.frame = frame;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    CGRect frame = self.lineView.frame;
    frame.size.width = lineWidth;
    self.lineView.frame = frame;
}

@end
