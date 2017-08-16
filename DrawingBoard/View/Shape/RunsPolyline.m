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
    CGContextSetLineCap(context, kCGLineCapRound);
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
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:origin];
//    [brush.frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (idx >= 3) {
//            CGPoint p2 = brush.frames[idx - 1].CGRectValue.origin;
//            CGPoint p3 = obj.CGRectValue.origin;
//            [path addQuadCurveToPoint:p3 controlPoint:p2];
//        }
//    }];
//    CGContextAddPath(context, path.CGPath);
//    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
//    CGContextSetLineWidth(context, brush.width);
//    CGContextStrokePath(context);
}

@end
