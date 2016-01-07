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
#import "sideBar.h"

#define kWidth self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface pageListVc ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,copy) NSArray *colors;
@property (nonatomic ,copy) NSArray *dataArr;

@property (nonatomic ,weak) labList *labView;
@property (nonatomic ,weak) UIView *cleanView;
@property (nonatomic ,weak) sideBar *side;

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
    [self.bgView addSubview:labView];
    _labView = labView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedLab:) name:@"selectLab" object:nil];
    
    //边界拖拽盖板
    UIView *cleanView = [[UIView alloc]init];
    cleanView.frame = CGRectMake(-30, 0, 60, kHeight*0.75);
    [self.bgView addSubview:cleanView];
    _cleanView = cleanView;
    
    //边界拖拽
    UIPanGestureRecognizer *edgePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    [cleanView addGestureRecognizer:edgePan];
    
    sideBar *side = [[[NSBundle mainBundle]loadNibNamed:@"sideBar" owner:nil options:nil] firstObject];
    side.frame = self.view.bounds;
    [self.view addSubview:side];
    [self.view sendSubviewToBack:side];
    side.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _side = side;
    
}

-(void)edgePan:(UIScreenEdgePanGestureRecognizer *)sender{
    
    //移动page
    CGPoint point = [sender translationInView:nil];
//    NSLog(@"%@",NSStringFromCGPoint(point));
    self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, point.x, 0);
    [sender setTranslation:CGPointZero inView:nil];
    
    //移动bar
    CGPoint p = [sender locationInView:nil];
    CGFloat scale = p.x / (kWidth * 0.5);
    scale = scale > 1 ? 1 : scale;
    NSLog(@"%.2f",scale);
    self.side.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        CGAffineTransform trans;
        CGAffineTransform scale;
        CGFloat alpha;
        
        if (self.bgView.frame.origin.x > kWidth * 0.4) {
            trans = CGAffineTransformMakeTranslation(kWidth*0.8, 0);
            scale = CGAffineTransformMakeScale(1, 1);
            _cleanView.transform = CGAffineTransformMakeTranslation(30, 0);
            alpha = 0;
            _collection.scrollEnabled = NO;
        }else{
            trans = CGAffineTransformIdentity;
            scale = CGAffineTransformMakeScale(0.3, 0.3);
            _cleanView.transform = CGAffineTransformIdentity;
            alpha = 1;
            _collection.scrollEnabled = YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.transform = trans;
            self.side.transform = scale;
            _labView.alpha = alpha;
        }];
        
    }
    
}

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
