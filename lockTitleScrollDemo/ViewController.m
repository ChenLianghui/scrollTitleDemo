//
//  ViewController.m
//  lockTitleScrollDemo
//
//  Created by 陈良辉 on 2017/5/24.
//  Copyright © 2017年 陈良辉. All rights reserved.
//

#import "ViewController.h"
#import "LHHeadTapView.h"

@interface ViewController ()<LHHeadTapDelegate>

@property (nonatomic,strong)LHHeadTapView *headView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UILabel *changedLabel;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) int number;
@property (nonatomic,strong) NSIndexPath *selectindexPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectindexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.view addSubview:self.headView];
}

- (LHHeadTapView *)headView{
    if (!_headView) {
        _headView = [[LHHeadTapView alloc] init];
        _headView.center = self.view.center;
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
        _headView.lockArray = array;
        _headView.lineColor = [UIColor redColor];
        _headView.delegate = self;
    }
    return _headView;
}

- (void)didTapItemWithIndexPath:(NSIndexPath *)indexPath{
    self.contentLabel.text = [NSString stringWithFormat:@"您点击了第%ld个",indexPath.item+1];
    _selectindexPath = indexPath;
}


- (IBAction)changeDataSouce:(UIButton *)sender {
    if ([self.textfield.text integerValue]>self.headView.lockArray.count) {
        NSLog(@"输入的文字不能大于%ld!",self.headView.lockArray.count);
        return;
    }
    if ([self.textfield.text isEqualToString:@""]) {
        _count = 1;
    }else{
        _count = [self.textfield.text intValue];
    }
    _number = arc4random()%10;
    [self.headView.lockArray replaceObjectAtIndex:_count-1 withObject:[NSString stringWithFormat:@"%d",_number]];
    [self.headView.collectionView reloadData];
    self.changedLabel.text = [NSString stringWithFormat:@"第%d个数据改变为%d",_count,_number];
}
- (IBAction)addItem:(UIButton *)sender {
    NSMutableArray *array = self.headView.lockArray;
    int newItem = arc4random()%10;
    [array addObject:[NSString stringWithFormat:@"%d",newItem]];
    self.headView.lockArray = array;
    [self.headView.collectionView reloadData];
}
- (IBAction)reduceItem:(UIButton *)sender {
    NSMutableArray *array = self.headView.lockArray;
    int currentNumber = (int)_selectindexPath.item;
    if (currentNumber<array.count-1) {
        [array removeLastObject];
        self.headView.lockArray = array;
        [self.headView.collectionView reloadData];
    }else{
        NSLog(@"只能删除选中之后的item！");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
