//
//  RunsEraser.m
//  OU_iPad
//
//  Created by runs on 2017/8/24.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsEraser.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"

@interface RunsEraser ()<RunsShapeProtocol>

@end

@implementation RunsEraser

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    if (brush.frames.count <= 0) {
        RunsLogEX(@"RunsPolyline drawContext : 画任意折线 坐标集合长度小于0");
        return;
    }
    CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, origin.x, origin.y);
    
    [brush.frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = obj.CGRectValue.origin;
        CGContextAddLineToPoint(context, point.x,point.y);
    }];
    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
    CGContextSetBlendMode(context,kCGBlendModeClear);
    CGContextSetLineWidth(context, brush.width);
    CGContextStrokePath(context);
}

@end
