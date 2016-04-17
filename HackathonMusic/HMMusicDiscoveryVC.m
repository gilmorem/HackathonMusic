//
//  HMMusicDiscoveryVC.m
//  HackathonMusic
//
//  Created by Everett Gilmore on 4/16/16.
//  Copyright © 2016 Everett Gilmore. All rights reserved.
//

#import "YSLDraggableCardContainer.h"
#import "HMMusicDiscoveryVC.h"
#import "BottomContainerVC.h"
#import "YSLCardView.h"
#import "CardView.h"
#import "HMUser.h"
#import "HMPlayer.h"

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface HMMusicDiscoveryVC ()<YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>

@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) BottomContainerVC *bottomContainerVC;
@property (nonatomic) NSInteger progress;

@end

@implementation HMMusicDiscoveryVC{
    CGFloat yOrigin;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(23, 23, 23);
    
    self.bottomContainerVC = (BottomContainerVC *)self.childViewControllers.lastObject;
    
    [self setupCardView];
    

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setMinimumFractionDigits:2];
    [nf setMaximumFractionDigits:2];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString * str = [nf stringFromNumber:[HMUser currentUser].credits];
    str = [[HMUser currentUser].name stringByAppendingFormat:@" %@",[nf stringFromNumber:[HMUser currentUser].credits]];
    [self.UserNameCreditsButton setTitle:str forState:UIControlStateNormal];
}

-(void)setupCardView{
    yOrigin = 80.0;
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(0, yOrigin, self.view.frame.size.width, self.view.frame.size.width);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
    [self.view addSubview:_container];
    
    
    [_container reloadCardContainer];

}

- (NSArray *) dataSourceArray
{
    return [HMPlayer shared].songs;
}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor clearColor];
    
    Song * song = self.dataSourceArray[index];
    
    view.imageView.image = [UIImage imageNamed:song.artworkFilename];
   
    view.artistLabel.text = [song.artist uppercaseString];
    view.titleLabel.text = [song.title uppercaseString];
    
    if (index == 0){
        view.artistLabel.hidden = NO;
        view.titleLabel.hidden = NO;
    }else{
        view.artistLabel.hidden = YES;
        view.titleLabel.hidden = YES;
    }

    
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.dataSourceArray.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
        
        [self.bottomContainerVC resetViews];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
        
        [self.bottomContainerVC resetViews];
    }
    

}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    CardView *view = (CardView *)draggableView;
    
    view.artistLabel.hidden = NO;
    view.titleLabel.hidden = NO;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        view.selectedView.backgroundColor = RGB(66, 172, 225);
        view.selectedView.alpha = heightRatio > 0.8 ? 0.8 : heightRatio;
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container reloadCardContainer];
    });
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    NSLog(@"++ index : %ld",(long)index);
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void) setProgress:(NSInteger)progress
{
    if (progress > 100) {
        progress = 100;
    } else if (progress < 0) {
        progress = 0;
    }
    _progress = progress;
    
}
@end
