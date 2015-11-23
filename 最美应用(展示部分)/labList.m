//
//  labList.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/12.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "labList.h"
#import "labCell.h"

@interface labList ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,assign) BOOL isnotFirst;
@end

@implementation labList

-(instancetype)initWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 2.5, 0, 2.5);
//    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(45, frame.size.height);
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[labCell class] forCellWithReuseIdentifier:@"cell"];
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollPage:) name:@"scrollPage" object:nil];
        
        
        //添加手势
        
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longP:)];
        longP.minimumPressDuration = 0;
        [self addGestureRecognizer:longP];
    }
    
    return self;
}
-(void)longP:(UITapGestureRecognizer *)sender{
//    NSLog(@"longP");
    
    CGPoint point = [sender locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    NSArray *arr = [self visibleCells];
    for (labCell *cell in arr) {
        if (CGRectContainsPoint(cell.frame, point)) {
            NSIndexPath *idx = [self indexPathForCell:cell];
            
            int num = idx.item;
            //前部分
            for (int i = num - 4; i< num + 5 ; i++) {
                if (i < 0 || i >= _dataArr.count) {
                    continue;
                }
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
                labCell *subCell = (labCell *)[self cellForItemAtIndexPath:indexpath];
                [UIView animateWithDuration:0.25 animations:^{
                
                    subCell.transform = CGAffineTransformMakeTranslation(0, -40 + 10*ABS(i-num));

                } ];
            }
            
            break;
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (labCell *cell in arr) {

            if (CGRectContainsPoint(cell.frame, point)) {
                NSIndexPath *idx = [self indexPathForCell:cell];
                [self changeLabWithIndexpath:idx];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLab" object:idx];
            }
        }
    }
    
}



-(void)scrollPage:(NSNotification *)noti{
    NSIndexPath *idx = [NSIndexPath indexPathForItem:[noti.object intValue] inSection:0];
    [self selectLabWithIndexpath:idx];
    
}

-(void)selectLabWithIndexpath:(NSIndexPath *)idx{
    [self scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self changeLabWithIndexpath:idx];
}

-(void)changeLabWithIndexpath:(NSIndexPath *)idx{
    for (int i = 0; i< self.subviews.count; i++){
        
        labCell *cell = (labCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        CGAffineTransform trans ;
        
        if (i == idx.item) {
            trans = CGAffineTransformMakeTranslation(0, -40);
        }else{
            trans = CGAffineTransformIdentity;
        }
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
            
            cell.transform = trans;
            
        } completion:nil];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_isnotFirst) {
        [self selectLabWithIndexpath:[NSIndexPath indexPathForItem:0 inSection:0]];
        _isnotFirst = YES;
    }
}

#pragma mark  UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    labCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
