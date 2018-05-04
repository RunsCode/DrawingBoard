//
//  RunsBrushProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RunsShapeProtocol.h"

@protocol RunsBrushProtocol <NSObject>

@required
@property(nonatomic, copy) NSString *brushId;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) ShapeType shape;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSMutableArray<NSValue*> *frames;

@optional
@property (nonatomic, assign) BOOL isFill;
@property (nonatomic, strong) UIColor *fillColor;

/**
 抽象基本构造方法

 @param shape 绘制形状
 @param color 线条颜色
 @param width 线条粗细或者叫宽度
 @return 返回实例
 */
+ (instancetype)brushWithShape:(ShapeType)shape color:(UIColor *)color thickness:(CGFloat)width;
- (instancetype)deepCopy;
@end
