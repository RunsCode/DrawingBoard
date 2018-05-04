//
//  RunsShapeProtocol.h
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define SHAPE_DISPLACEMENT (4)

typedef NS_ENUM(NSUInteger, ShapeType) {
    ShapeType_Polyline  = 0 << SHAPE_DISPLACEMENT,//折线
    ShapeType_Beeline   = 1 << SHAPE_DISPLACEMENT,//直线
    ShapeType_Square    = 2 << SHAPE_DISPLACEMENT,//矩形
    ShapeType_Ellipse   = 3 << SHAPE_DISPLACEMENT,//椭圆
    ShapeType_Round     = 4 << SHAPE_DISPLACEMENT,//正圆
    ShapeType_Text      = 5 << SHAPE_DISPLACEMENT,//文字
    ShapeType_Eraser    = 6 << SHAPE_DISPLACEMENT,//橡皮擦
    ShapeType_Default   = ShapeType_Polyline,
};


@protocol RunsBrushProtocol;
@protocol RunsShapeProtocol <NSObject>
@property(nonatomic, assign) CGRect bounds;
+ (instancetype)shapeWithBounds:(CGRect)bounds;
@required
- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush;
@end
