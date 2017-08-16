//
//  RunsBrushModel.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunsBrushProtocol.h"


@interface RunsBrushModel : NSObject<RunsBrushProtocol, NSCopying, NSCoding>
@property (nonatomic, assign) BOOL isFill;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) ShapeType shape;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSMutableArray<NSValue*> *frames;

+ (instancetype)brushWithShape:(ShapeType)shape lineColor:(UIColor *)color lineWidth:(CGFloat)width fillColor:(UIColor *)fillColor frames:(NSArray<NSValue*> *)frames fill:(BOOL)isFill;
+ (instancetype)defaultWithShape:(ShapeType)shape lineColor:(UIColor *)color lineWidth:(CGFloat)width frames:(NSArray<NSValue*> *)frames;
@end
