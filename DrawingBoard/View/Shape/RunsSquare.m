//
//  RunsSquare.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsSquare.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"

@interface RunsSquare ()<RunsShapeProtocol>

@end


@implementation RunsSquare

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    if (brush.frames.count < 2) {
        RunsLogEX(@"RunsSquare drawContext : 画矩形 坐标集合长度小于0");
        return;
    }
    CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
    CGPoint next = brush.frames.lastObject.CGRectValue.origin;
    CGFloat width = next.x - origin.x;
    CGFloat height = next.y - origin.y;
    CGRect bounds = CGRectMake(origin.x, origin.y, width, height);
    CGContextSetLineWidth(context, brush.width);
    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
    CGContextStrokeRect(context, bounds);
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    if (brush.isFill) {
        CGContextSetFillColorWithColor(context,brush.fillColor.CGColor);
        CGContextFillRect(context, bounds);
    }
    CGContextDrawPath(context, brush.isFill ? kCGPathFillStroke : kCGPathStroke);
}

@end
