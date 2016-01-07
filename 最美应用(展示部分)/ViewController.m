//
//  ViewController.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/11.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "ViewController.h"
#import "dataModel.h"
#import "animationModal.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBgY;

@property (weak, nonatomic) IBOutlet UIView *buttonBG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labs;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic ,weak) UIImageView *currentImgView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation ViewController


- (IBAction)collectionBtnClick:(id)sender {
    UILabel *lab = _labs[0];
    lab.text = @"已收藏";
}
- (IBAction)backClick:(id)sender {
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [animationModal new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _name.text = _mod.name;
    _bgView.image = [UIImage imageNamed:_mod.imgName];
    [_scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"Offset"];
    [self HidenList];
    
    //添加手势返回
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
}

-(void)swipe:(UISwipeGestureRecognizer *)sender{
    [self backClick:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self showList];
}
-(void)HidenList{

    _backBtn.transform = CGAffineTransformMakeTranslation(-50, 0);
    _scroll.transform = CGAffineTransformMakeTranslation(0, _scroll.bounds.size.height);
    _buttonBG.alpha = 0;
    
    _titleView.transform = CGAffineTransformMakeTranslation(-20, -90);
    _icon.transform = CGAffineTransformMakeTranslation(-70, -70);
    
    UIImageView *img = [[UIImageView alloc]initWithImage:_bgView.image];
    img.frame = _oringeRect;
    [self.view addSubview:img];
    [self.view sendSubviewToBack:img];
    _currentImgView = img;
    
    _bgView.hidden = YES;
    
//    CGFloat x = _oringeRect.origin.x - _bgView.frame.origin.x;
//    CGFloat y = _oringeRect.origin.y - _bgView.frame.origin.y;
//    CGFloat scaleX = _oringeRect.size.width
}

-(void)showList{
    [UIView animateWithDuration:1 animations:^{
        _backBtn.transform = CGAffineTransformIdentity;
        _scroll.transform = CGAffineTransformIdentity;
        _bgView.transform = CGAffineTransformIdentity;
        _icon.transform = CGAffineTransformIdentity;
        _titleView.transform = CGAffineTransformIdentity;
        _currentImgView.frame = _bgView.frame;
    } completion:^(BOOL finished) {
        _buttonBG.alpha = 1;
        _bgView.hidden = NO;
        [_currentImgView removeFromSuperview];
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"Offset") {
//        NSLog(@"%@",change);
        CGPoint point = [change[@"new"] CGPointValue];
//        NSLog(@"%.2f",point.y);
        
        //移动buttonView
        _buttonBgY.constant = 220 - point.y;
//        NSLog(@"%.2f",_buttonBgY.constant);
        if (_buttonBgY.constant < 0) {
            _buttonBgY.constant = 0;
            [UIView animateWithDuration:0.25 animations:^{
                _collectBtn.transform = CGAffineTransformMakeTranslation(40, 0);
                _downloadBtn.transform = CGAffineTransformMakeTranslation(-40, 0);
                for (UILabel *lab in _labs) {
                    lab.alpha = 0;
                }
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                _collectBtn.transform = CGAffineTransformIdentity;
                _downloadBtn.transform = CGAffineTransformIdentity;
                for (UILabel *lab in _labs) {
                    lab.alpha = 1;
                }
            }];
        }
        
        //改变上部img
        if (point.y < 0) {
            
            CGFloat scale = 1 - point.y*2/150;
            _bgView.transform = CGAffineTransformMakeScale(scale, scale);
            
        }else{
            _bgView.transform = CGAffineTransformMakeTranslation(0, -point.y * 0.5);
            
//            NSLog(@"%@",NSStringFromCGRect(_buttonBG.frame));
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc{
    [_scroll removeObserver:self forKeyPath:@"contentOffset"];
}

@end
