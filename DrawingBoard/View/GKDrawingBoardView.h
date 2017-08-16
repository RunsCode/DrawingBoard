//
//  GKDrawingBoardView.h
//  GuoKao
//
//  Created by wang on 16/6/10.
//  Copyright © 2016年 ShangHai HongYiTong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKDrawingBoardView : UIView
@property (nonatomic, assign) CGFloat lineWidth;;
@property (nonatomic, strong) UIColor *lineColor;
- (void)clearLine;
- (void)undo;
- (void)redo;
@end
