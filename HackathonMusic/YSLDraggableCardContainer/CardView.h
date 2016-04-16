//
//  CardView.h
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCardView.h"
#import <MarqueeLabel/MarqueeLabel.h>

@interface CardView : YSLCardView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UIView *selectedView;

@end
