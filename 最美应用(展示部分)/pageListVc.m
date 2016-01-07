//
//  pageListVc.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "pageListVc.h"
#import "ListCell.h"
#import "ViewController.h"
#import "dataModel.h"
#import "labList.h"

#define kWidth self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface pageListVc ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property(nonatomic,copy) NSArray *colors;
@property (nonatomic ,copy) NSArray *dataArr;

@end

@implementation pageListVc

-(NSArray *)dataArr{
    if (!_dataArr) {
        NSMutableArray *marr = [NSMutableArray array ];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"dataList" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            dataModel *mod = [dataModel modelWithDict:dict];
            [marr addObject:mod];
        }
        _dataArr = [marr copy];
    }
    return _dataArr;
}

-(NSArray *)colors{
    if (!_colors) {
        NSMutableArray *marr = [NSMutableArray array ];
        for (int i = 0; i< self.dataArr.count; i++) {
            UIColor *color = [UIColor colorWithHue:arc4random_uniform(256)/255.0 saturation:0.8 brightness:0.8 alpha:0.8];
            [marr addObject:color];
        }
        _colors = [marr copy];
    }
    return _colors;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.colors[0];
    labList *labView = [[labList alloc]initWithFrame:CGRectMake(0, kHeight - 60, kWidth, 120)];
    labView.dataArr = self.dataArr;
    [self.view addSubview:labView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedLab:) name:@"selectLab" object:nil];
    
//    //边界拖拽盖板
//    UIView *cleanView = [[UIView alloc]init];
//    cleanView.frame = CGRectMake(0, 0, 20, kHeight);
//    [self.view addSubview:cleanView];
//    
//    //边界拖拽
//    UIPanGestureRecognizer *edgePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
//
//    [cleanView addGestureRecognizer:edgePan];
}

//-(void)edgePan:(UIScreenEdgePanGestureRecognizer *)sender{
//    
//    CGPoint point = [sender translationInView:nil];
//    NSLog(@"%@",NSStringFromCGPoint(point));
//    self.collection.transform = CGAffineTransformMakeTranslation(point.x, 0);
//    
//}

-(void)selectedLab:(NSNotification *)noti{
    [self.collection scrollToItemAtIndexPath:noti.object atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma  mark dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexPath];
    
    cell.mod = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int i = self.collection.contentOffset.x / kWidth;
    self.view.backgroundColor = self.colors[i];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollPage" object:[NSNumber numberWithInt:i]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ListCell *cell = sender;
    NSIndexPath *idx = [self.collection indexPathForCell:cell];
    
    ViewController *vc = segue.destinationViewController;
    vc.oringeRect = [cell convertRect:cell.img.frame toView:self.view];
    vc.mod = self.dataArr[idx.row];
}

@end
