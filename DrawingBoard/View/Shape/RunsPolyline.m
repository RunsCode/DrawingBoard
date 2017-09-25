//
//  RunsPolyline.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsPolyline.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"

@interface RunsPolyline ()<RunsShapeProtocol>

@end

@implementation RunsPolyline

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    if (brush.frames.count <= 0) {
        NSLog(@"RunsPolyline drawContext : 画任意折线 坐标集合长度小于0");
        return;
    }
    
    __block CGPoint currentPoint;
    __block CGPoint previousPoint1;
    __block CGPoint previousPoint2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.miterLimit = 0;
    path.lineWidth = brush.width;
    [brush.color set];
    [brush.frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            previousPoint1 = previousPoint2 = currentPoint = obj.CGRectValue.origin;
            [path moveToPoint: CGPointMid(previousPoint1, previousPoint2)];
        }else {
            previousPoint2 = previousPoint1;
            previousPoint1 = currentPoint;
            currentPoint = obj.CGRectValue.origin;
            [path addLineToPoint: CGPointMid(previousPoint1, previousPoint2)];
            [path addQuadCurveToPoint: CGPointMid(currentPoint, previousPoint1) controlPoint: previousPoint1];
        }
    }];
    [path stroke];
}


static CGPoint CGPointMid(CGPoint a, CGPoint b) {
    return (CGPoint) {(a.x+b.x)/2.0, (a.y+b.y)/2.0};
}
@end
/**
 CGContextSetLineCap(context, kCGLineCapRound);
 CGContextSetBlendMode(context,kCGBlendModeNormal);
 CGContextSetLineJoin(context, kCGLineJoinRound);
 
 CGContextBeginPath(context);
 CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
 CGContextMoveToPoint(context, origin.x, origin.y);
 
 [brush.frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 CGPoint point = obj.CGRectValue.origin;
 CGContextAddLineToPoint(context, point.x,point.y);
 }];
 CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
 CGContextSetLineWidth(context, brush.width);
 CGContextStrokePath(context);
 */
