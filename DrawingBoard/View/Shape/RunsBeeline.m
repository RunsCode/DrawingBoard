//
//  RunsBeeline.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsBeeline.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"

@interface RunsBeeline ()<RunsShapeProtocol>

@end

@implementation RunsBeeline

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    
    if (brush.frames.count < 2) {//两点确定一条直线
        RunsLogEX(@"RunsBeeline drawContext : 画直线 坐标集合长度错误");
        return;
    }
    
    //设置笔冒
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置画线的连接处　拐点圆滑
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextBeginPath(context);
    CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
    CGContextMoveToPoint(context, origin.x, origin.y);
    CGPoint next = brush.frames.lastObject.CGRectValue.origin;
    CGContextAddLineToPoint(context, next.x, next.y);
    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextSetLineWidth(context, brush.width);
    CGContextStrokePath(context);
}

- (CGPathRef)pathWithBrush:(id<RunsBrushProtocol>)brush {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    return path.CGPath;
}


@end
