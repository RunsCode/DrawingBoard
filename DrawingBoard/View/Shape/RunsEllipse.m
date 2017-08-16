//
//  RunsEllipse.m
//  DrawingBoard
//
//  Created by runs on 2017/8/15.
//  Copyright © 2017年 Olacio. All rights reserved.
//

#import "RunsEllipse.h"
#import "RunsShapeProtocol.h"
#import "RunsBrushProtocol.h"

@interface RunsEllipse ()<RunsShapeProtocol>

@end

@implementation RunsEllipse

- (void)drawContext:(CGContextRef)context brush:(id<RunsBrushProtocol>)brush {
    if (brush.frames.count < 2) {
        NSLog(@"RunsEllipse drawContext : 画椭圆 坐标集合长度小于0");
        return;
    }
    CGPoint origin = brush.frames.firstObject.CGRectValue.origin;
    CGPoint next = brush.frames.lastObject.CGRectValue.origin;
    CGFloat width = next.x - origin.x;
    CGFloat height = next.y - origin.y;
    CGRect bounds = CGRectMake(origin.x, origin.y, width, height);
    
    CGContextSetLineWidth(context, brush.width);
    CGContextSetStrokeColorWithColor(context, brush.color.CGColor);
    
    if (brush.isFill) {
        CGContextSetFillColorWithColor(context, brush.fillColor.CGColor);
    }

    CGContextAddEllipseInRect(context, bounds);
    CGContextDrawPath(context, brush.isFill ? kCGPathFillStroke : kCGPathStroke);
}

@end
